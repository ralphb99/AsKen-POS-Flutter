import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

class EodSummaryService {
  final AppDatabase Database;

  const EodSummaryService({required this.Database});

  /// Applies one confirmed sale to the EOD aggregate.
  ///
  /// The caller must invoke this while its surrounding database transaction is
  /// open. TransactionService uses this contract so the transaction, print
  /// job, and EOD aggregate commit or roll back together.
  Future<void> RecordSale({
    required DateTime SoldAt,
    required List<EodSaleLine> Lines,
    required int SaleTotalInCents,
  }) async {
    await _RecordSale(
      SoldAt: SoldAt,
      Lines: Lines,
      SaleTotalInCents: SaleTotalInCents,
    );
  }

  Future<EodDashboardData> GetDashboard({
    required DateTime BusinessDate,
  }) async {
    final StartOfDay = _StartOfDay(BusinessDate);
    final EndOfDay = StartOfDay.add(const Duration(days: 1));
    final SummaryRow = await _GetSummaryRow(StartOfDay);
    final Transactions =
        await (Database.select(Database.transactions)..where(
              (Transaction) =>
                  Transaction.CreatedAt.isBiggerOrEqualValue(StartOfDay) &
                  Transaction.CreatedAt.isSmallerThanValue(EndOfDay) &
                  Transaction.Status.equals('completed'),
            ))
            .get();

    final CashierNames = _GetCashierNames(Transactions);

    return EodDashboardData(
      Summary: SummaryRow == null ? null : _ToRecord(SummaryRow),
      CashierNames: CashierNames,
    );
  }

  Future<List<EodSummaryRecord>> GetSummaries({
    DateTime? From,
    DateTime? To,
  }) async {
    final SummaryQuery = Database.select(Database.eodSummaries)
      ..orderBy([
        (Summary) => OrderingTerm(
          expression: Summary.BusinessDate,
          mode: OrderingMode.desc,
        ),
      ]);

    if (From != null || To != null) {
      SummaryQuery.where((Summary) {
        if (From != null && To != null) {
          return Summary.BusinessDate.isBiggerOrEqualValue(
                _BusinessDateKey(_StartOfDay(From)),
              ) &
              Summary.BusinessDate.isSmallerThanValue(
                _BusinessDateKey(_StartOfDay(To)),
              );
        }
        if (From != null) {
          return Summary.BusinessDate.isBiggerOrEqualValue(
            _BusinessDateKey(_StartOfDay(From)),
          );
        }
        return Summary.BusinessDate.isSmallerThanValue(
          _BusinessDateKey(_StartOfDay(To!)),
        );
      });
    }

    final SummaryRows = await SummaryQuery.get();
    return SummaryRows.map(_ToRecord).toList(growable: false);
  }

  Future<EodSummaryDetails?> GetDetails({required String BusinessDate}) async {
    final SummaryRow =
        await (Database.select(Database.eodSummaries)
              ..where((Summary) => Summary.BusinessDate.equals(BusinessDate)))
            .getSingleOrNull();

    if (SummaryRow == null) {
      return null;
    }

    final ItemRows =
        await (Database.select(Database.eodSummaryItems)
              ..where((Item) => Item.EodSummaryID.equals(SummaryRow.ID))
              ..orderBy([
                (Item) => OrderingTerm(expression: Item.ProductNameSnapshot),
                (Item) => OrderingTerm(expression: Item.UnitSnapshot),
              ]))
            .get();

    final StartOfDay = _ParseBusinessDateKey(BusinessDate);
    final EndOfDay = StartOfDay.add(const Duration(days: 1));
    final Transactions =
        await (Database.select(Database.transactions)..where(
              (Transaction) =>
                  Transaction.CreatedAt.isBiggerOrEqualValue(StartOfDay) &
                  Transaction.CreatedAt.isSmallerThanValue(EndOfDay) &
                  Transaction.Status.equals('completed'),
            ))
            .get();

    return EodSummaryDetails(
      Summary: _ToRecord(SummaryRow),
      Lines: ItemRows.map(_ToLine).toList(growable: false),
      CashierNames: _GetCashierNames(Transactions),
    );
  }

  /// Creates missing aggregates for transactions that existed before the EOD
  /// tables were introduced. Existing EOD rows are never overwritten.
  Future<void> EnsureSummariesFromTransactions() async {
    final TransactionRows = await Database.select(Database.transactions).get();
    if (TransactionRows.isEmpty) {
      return;
    }

    final ExistingSummaryRows = await Database.select(
      Database.eodSummaries,
    ).get();
    final ExistingBusinessDates = ExistingSummaryRows.map(
      (Summary) => Summary.BusinessDate,
    ).toSet();
    final MissingTransactions = TransactionRows.where((Transaction) {
      return Transaction.Status == 'completed' &&
          !ExistingBusinessDates.contains(
            _BusinessDateKey(_StartOfDay(Transaction.CreatedAt)),
          );
    }).toList(growable: false);

    if (MissingTransactions.isEmpty) {
      return;
    }

    final ItemRows = await Database.select(Database.transactionItems).get();
    final ItemsByTransactionID = <int, List<EodSaleLine>>{};
    for (final Item in ItemRows) {
      ItemsByTransactionID.putIfAbsent(Item.TransactionID, () => []).add(
        EodSaleLine(
          ProductVariantID: Item.ProductVariantID,
          ProductName: Item.ProductNameSnapshot,
          Unit: Item.UnitSnapshot,
          UnitPriceInCents: Item.UnitPriceInCents,
          Quantity: Item.Quantity,
          LineTotalInCents: Item.LineTotalInCents,
        ),
      );
    }

    await Database.transaction(() async {
      for (final Transaction in MissingTransactions) {
        final Lines = ItemsByTransactionID[Transaction.ID];
        if (Lines == null || Lines.isEmpty) {
          continue;
        }

        await _RecordSale(
          SoldAt: Transaction.CreatedAt,
          Lines: Lines,
          SaleTotalInCents: Transaction.TotalInCents,
        );
      }
    });
  }

  Future<void> _RecordSale({
    required DateTime SoldAt,
    required List<EodSaleLine> Lines,
    required int SaleTotalInCents,
  }) async {
    final ValidLines = Lines.where(
      (Line) =>
          Line.Quantity > 0 &&
          Line.LineTotalInCents >= 0 &&
          Line.UnitPriceInCents >= 0 &&
          Line.ProductName.trim().isNotEmpty &&
          Line.Unit.trim().isNotEmpty,
    ).toList(growable: false);
    if (ValidLines.isEmpty || SaleTotalInCents < 0) {
      throw ArgumentError('An EOD entry must contain at least one item.');
    }

    final BusinessDate = _BusinessDateKey(_StartOfDay(SoldAt));
    final TotalSoldUnits = ValidLines.fold(
      0,
      (Total, Line) => Total + Line.Quantity,
    );
    final SummaryRow = await _GetSummaryRow(SoldAt);
    int EodSummaryID;

    if (SummaryRow == null) {
      EodSummaryID = await Database.into(Database.eodSummaries).insert(
        EodSummariesCompanion.insert(
          BusinessDate: BusinessDate,
          TransactionCount: const Value(1),
          SoldUnitCount: Value(TotalSoldUnits),
          TotalSalesInCents: Value(SaleTotalInCents),
          UpdatedAt: Value(SoldAt),
        ),
      );
    } else {
      EodSummaryID = SummaryRow.ID;
      await (Database.update(
        Database.eodSummaries,
      )..where((Summary) => Summary.ID.equals(EodSummaryID))).write(
        EodSummariesCompanion(
          TransactionCount: Value(SummaryRow.TransactionCount + 1),
          SoldUnitCount: Value(SummaryRow.SoldUnitCount + TotalSoldUnits),
          TotalSalesInCents: Value(
            SummaryRow.TotalSalesInCents + SaleTotalInCents,
          ),
          UpdatedAt: Value(SoldAt),
        ),
      );
    }

    for (final Line in ValidLines) {
      final ExistingItem =
          await (Database.select(Database.eodSummaryItems)..where(
                (Item) =>
                    Item.EodSummaryID.equals(EodSummaryID) &
                    Item.ProductVariantID.equals(Line.ProductVariantID) &
                    Item.ProductNameSnapshot.equals(Line.ProductName) &
                    Item.UnitSnapshot.equals(Line.Unit) &
                    Item.UnitPriceInCents.equals(Line.UnitPriceInCents),
              ))
              .getSingleOrNull();

      if (ExistingItem == null) {
        await Database.into(Database.eodSummaryItems).insert(
          EodSummaryItemsCompanion.insert(
            EodSummaryID: EodSummaryID,
            ProductVariantID: Line.ProductVariantID,
            ProductNameSnapshot: Line.ProductName,
            UnitSnapshot: Line.Unit,
            UnitPriceInCents: Line.UnitPriceInCents,
            SoldUnits: Line.Quantity,
            SoldTotalInCents: Line.LineTotalInCents,
          ),
        );
        continue;
      }

      await (Database.update(
        Database.eodSummaryItems,
      )..where((Item) => Item.ID.equals(ExistingItem.ID))).write(
        EodSummaryItemsCompanion(
          SoldUnits: Value(ExistingItem.SoldUnits + Line.Quantity),
          SoldTotalInCents: Value(
            ExistingItem.SoldTotalInCents + Line.LineTotalInCents,
          ),
        ),
      );
    }
  }

  Future<EodSummary?> _GetSummaryRow(DateTime BusinessDate) {
    final BusinessDateKey = _BusinessDateKey(_StartOfDay(BusinessDate));
    return (Database.select(Database.eodSummaries)
          ..where((Summary) => Summary.BusinessDate.equals(BusinessDateKey)))
        .getSingleOrNull();
  }

  EodSummaryRecord _ToRecord(EodSummary Row) {
    return EodSummaryRecord(
      ID: Row.ID,
      BusinessDate: Row.BusinessDate,
      TransactionCount: Row.TransactionCount,
      SoldUnitCount: Row.SoldUnitCount,
      TotalSalesInCents: Row.TotalSalesInCents,
      CreatedAt: Row.CreatedAt,
      UpdatedAt: Row.UpdatedAt,
    );
  }

  EodSummaryLine _ToLine(EodSummaryItem Row) {
    return EodSummaryLine(
      ID: Row.ID,
      EodSummaryID: Row.EodSummaryID,
      ProductVariantID: Row.ProductVariantID,
      ProductName: Row.ProductNameSnapshot,
      Unit: Row.UnitSnapshot,
      UnitPriceInCents: Row.UnitPriceInCents,
      SoldUnits: Row.SoldUnits,
      SoldTotalInCents: Row.SoldTotalInCents,
    );
  }

  List<String> _GetCashierNames(List<Transaction> Transactions) {
    final CashierNames = Transactions.map(
      (Transaction) => Transaction.CashierName.trim(),
    ).where((CashierName) => CashierName.isNotEmpty).toSet().toList();
    CashierNames.sort();
    return List.unmodifiable(CashierNames);
  }

  DateTime _StartOfDay(DateTime Date) =>
      DateTime(Date.year, Date.month, Date.day);

  String _BusinessDateKey(DateTime Date) {
    final Year = Date.year.toString().padLeft(4, '0');
    final Month = Date.month.toString().padLeft(2, '0');
    final Day = Date.day.toString().padLeft(2, '0');
    return '$Year-$Month-$Day';
  }

  DateTime _ParseBusinessDateKey(String BusinessDateKey) {
    final Parts = BusinessDateKey.split('-');
    if (Parts.length != 3) {
      throw FormatException('Invalid EOD business date: $BusinessDateKey');
    }

    return DateTime(
      int.parse(Parts[0]),
      int.parse(Parts[1]),
      int.parse(Parts[2]),
    );
  }
}
