import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class TransactionRecord {
  final Transaction TransactionData;
  final List<TransactionItem> Items;

  const TransactionRecord({required this.TransactionData, required this.Items});
}

class TransactionRecordsDateRange {
  final DateTime From;
  final DateTime To;

  const TransactionRecordsDateRange({required this.From, required this.To});

  @override
  bool operator ==(Object Other) =>
      Other is TransactionRecordsDateRange &&
      Other.From == From &&
      Other.To == To;

  @override
  int get hashCode => Object.hash(From, To);
}

class TransactionRecordsService {
  final AppDatabase Database;

  const TransactionRecordsService({required this.Database});

  Future<List<TransactionRecord>> GetTransactions({
    DateTime? From,
    DateTime? To,
    String SearchQuery = '',
  }) async {
    final TransactionQuery = Database.select(Database.transactions)
      ..orderBy([
        (Transaction) => OrderingTerm(
          expression: Transaction.CreatedAt,
          mode: OrderingMode.desc,
        ),
      ]);
    if (From != null || To != null) {
      TransactionQuery.where((Transaction) {
        if (From != null && To != null) {
          return Transaction.CreatedAt.isBiggerOrEqualValue(From!) &
              Transaction.CreatedAt.isSmallerThanValue(To!);
        }
        if (From != null) {
          return Transaction.CreatedAt.isBiggerOrEqualValue(From!);
        }
        return Transaction.CreatedAt.isSmallerThanValue(To!);
      });
    }

    final Transactions = await TransactionQuery.get();
    final Query = SearchQuery.trim().toLowerCase();
    final Records = <TransactionRecord>[];

    for (final TransactionData in Transactions) {
      final SearchableText = [
        TransactionData.ReceiptNumber,
        TransactionData.CashierName,
        TransactionData.PaymentMethod,
        TransactionData.Status,
        TransactionData.SyncStatus,
      ].join(' ').toLowerCase();

      if (Query.isNotEmpty && !SearchableText.contains(Query)) {
        continue;
      }

      Records.add(
        TransactionRecord(
          TransactionData: TransactionData,
          Items: await _GetItems(TransactionData.ID),
        ),
      );
    }

    return Records;
  }

  Future<TransactionRecord?> GetTransaction(int TransactionID) async {
    final TransactionData =
        await (Database.select(Database.transactions)
              ..where((Transaction) => Transaction.ID.equals(TransactionID)))
            .getSingleOrNull();

    if (TransactionData == null) {
      return null;
    }

    return TransactionRecord(
      TransactionData: TransactionData,
      Items: await _GetItems(TransactionID),
    );
  }

  Future<List<TransactionItem>> _GetItems(int TransactionID) {
    return (Database.select(Database.transactionItems)
          ..where((Item) => Item.TransactionID.equals(TransactionID))
          ..orderBy([(Item) => OrderingTerm(expression: Item.ID)]))
        .get();
  }
}

class TransactionExportService {
  const TransactionExportService();

  String ToCsv(List<TransactionRecord> Records) {
    final Lines = <String>[
      'ReceiptNumber,CreatedAt,CashierName,PaymentMethod,Product,Unit,Quantity,UnitPrice,LineTotal,TransactionTotal,SyncStatus',
    ];

    for (final Record in Records) {
      final TransactionData = Record.TransactionData;
      for (final Item in Record.Items) {
        Lines.add(
          [
            _Escape(TransactionData.ReceiptNumber),
            _Escape(TransactionData.CreatedAt.toIso8601String()),
            _Escape(TransactionData.CashierName),
            _Escape(TransactionData.PaymentMethod),
            _Escape(Item.ProductNameSnapshot),
            _Escape(Item.UnitSnapshot),
            Item.Quantity,
            _FormatAmount(Item.UnitPriceInCents),
            _FormatAmount(Item.LineTotalInCents),
            _FormatAmount(TransactionData.TotalInCents),
            _Escape(TransactionData.SyncStatus),
          ].join(','),
        );
      }
    }

    return Lines.join('\n');
  }

  String ToText(List<TransactionRecord> Records) {
    final Lines = <String>[];
    for (final Record in Records) {
      final TransactionData = Record.TransactionData;
      Lines.add('Receipt: ${TransactionData.ReceiptNumber}');
      Lines.add('Date: ${TransactionData.CreatedAt.toIso8601String()}');
      Lines.add('Cashier: ${TransactionData.CashierName}');
      Lines.add('Payment: ${TransactionData.PaymentMethod}');
      for (final Item in Record.Items) {
        Lines.add(
          '${Item.Quantity} ${Item.UnitSnapshot} ${Item.ProductNameSnapshot} '
          '${_FormatAmount(Item.LineTotalInCents)}',
        );
      }
      Lines.add('TOTAL: ${_FormatAmount(TransactionData.TotalInCents)}');
      Lines.add('Sync: ${TransactionData.SyncStatus}');
      Lines.add('');
    }
    return Lines.join('\n');
  }

  String _Escape(String Value) => '"${Value.replaceAll('"', '""')}"';

  String _FormatAmount(int Cents) => (Cents / 100).toStringAsFixed(2);
}
