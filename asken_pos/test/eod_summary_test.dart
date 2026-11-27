import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/TransactionService.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryExportService.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryService.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

void main() {
  late AppDatabase Database;
  late EodSummaryService EodService;

  setUp(() {
    Database = AppDatabase.forTesting(NativeDatabase.memory());
    EodService = EodSummaryService(Database: Database);
  });

  tearDown(() async {
    await Database.close();
  });

  test('aggregates repeated sales into one EOD line', () async {
    final ProductID = await Database.into(
      Database.products,
    ).insert(ProductsCompanion.insert(ProductName: 'Ballpen'));
    final ProductVariantID = await Database.into(Database.productVariants)
        .insert(
          ProductVariantsCompanion.insert(
            ProductID: ProductID,
            Unit: 'box',
            PriceInCents: 1200,
          ),
        );
    final SaleTime = DateTime(2026, 11, 27, 10);

    await Database.transaction(() async {
      await _InsertSale(
        Database: Database,
        EodService: EodService,
        TransactionID: 'ASK-001',
        CashierName: 'Ana',
        ProductVariantID: ProductVariantID,
        Quantity: 1,
        SaleTime: SaleTime,
      );
      await _InsertSale(
        Database: Database,
        EodService: EodService,
        TransactionID: 'ASK-002',
        CashierName: 'Ben',
        ProductVariantID: ProductVariantID,
        Quantity: 2,
        SaleTime: SaleTime.add(const Duration(hours: 1)),
      );
    });

    final Details = await EodService.GetDetails(BusinessDate: '2026-11-27');

    expect(Details == null, false);
    expect(Details!.Summary.TransactionCount, 2);
    expect(Details.Summary.SoldUnitCount, 3);
    expect(Details.Summary.TotalSalesInCents, 3600);
    expect(Details.Lines, hasLength(1));
    expect(Details.Lines.single.SoldUnits, 3);
    expect(Details.Lines.single.SoldTotalInCents, 3600);
    expect(Details.CashierNames, <String>['Ana', 'Ben']);
  });

  test('rolls back a transaction when EOD recording fails', () async {
    final ProductID = await Database.into(
      Database.products,
    ).insert(ProductsCompanion.insert(ProductName: 'Ballpen'));
    final ProductVariantID = await Database.into(Database.productVariants)
        .insert(
          ProductVariantsCompanion.insert(
            ProductID: ProductID,
            Unit: 'pc',
            PriceInCents: 600,
          ),
        );
    final TransactionService Service = TransactionService(
      Database: Database,
      EodService: EodService,
    );

    final CartItem InvalidItem = CartItem(
      CartProduct: ProductDisplayData(
        ProductID: ProductID,
        ProductVariantID: ProductVariantID,
        ProductName: 'Ballpen',
        Unit: 'pc',
        PriceInCents: 600,
      ),
      quantity: 0,
    );

    await expectLater(
      Service.SaveTransaction(
        CashierName: 'Ana',
        CartItems: <CartItem>[InvalidItem],
        CartTotalInCents: 0,
      ),
      throwsArgumentError,
    );

    expect(await Database.select(Database.transactions).get(), isEmpty);
    expect(await Database.select(Database.transactionItems).get(), isEmpty);
    expect(await Database.select(Database.eodSummaries).get(), isEmpty);
  });

  test('exports spreadsheet-friendly EOD totals', () {
    final Details = EodSummaryDetails(
      Summary: EodSummaryRecord(
        ID: 1,
        BusinessDate: '2026-11-27',
        TransactionCount: 1,
        SoldUnitCount: 2,
        TotalSalesInCents: 1200,
        CreatedAt: DateTime(2026, 11, 27),
        UpdatedAt: DateTime(2026, 11, 27),
      ),
      Lines: const <EodSummaryLine>[
        EodSummaryLine(
          ID: 1,
          EodSummaryID: 1,
          ProductVariantID: 1,
          ProductName: 'Ballpen',
          Unit: 'box',
          UnitPriceInCents: 600,
          SoldUnits: 2,
          SoldTotalInCents: 1200,
        ),
      ],
      CashierNames: <String>['Ana'],
    );

    final Csv = const EodSummaryExportService().ToCsv(Details);

    expect(Csv, contains('Item-Entry,Unit/Measurement'));
    expect(Csv, contains('"Ballpen","box",6.00,2,12.00'));
    expect(Csv, endsWith('TOTAL,,,,12.00'));
  });
}

Future<void> _InsertSale({
  required AppDatabase Database,
  required EodSummaryService EodService,
  required String TransactionID,
  required String CashierName,
  required int ProductVariantID,
  required int Quantity,
  required DateTime SaleTime,
}) async {
  final ID = await Database.into(Database.transactions).insert(
    TransactionsCompanion.insert(
      ReceiptNumber: TransactionID,
      CashierName: CashierName,
      TotalInCents: 1200 * Quantity,
      CreatedAt: Value(SaleTime),
    ),
  );

  await Database.into(Database.transactionItems).insert(
    TransactionItemsCompanion.insert(
      TransactionID: ID,
      ProductVariantID: ProductVariantID,
      ProductNameSnapshot: 'Ballpen',
      UnitSnapshot: 'box',
      UnitPriceInCents: 1200,
      Quantity: Quantity,
      LineTotalInCents: 1200 * Quantity,
    ),
  );

  await EodService.RecordSale(
    SoldAt: SaleTime,
    Lines: <EodSaleLine>[
      EodSaleLine(
        ProductVariantID: ProductVariantID,
        ProductName: 'Ballpen',
        Unit: 'box',
        UnitPriceInCents: 1200,
        Quantity: Quantity,
        LineTotalInCents: 1200 * Quantity,
      ),
    ],
    SaleTotalInCents: 1200 * Quantity,
  );
}
