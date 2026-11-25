import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';
import 'package:asken_pos/app/core/features/printing/data/StoreSettingsService.dart';

class ReceiptDataService {
  final AppDatabase Database;
  final StoreSettingsService StoreSettings;

  const ReceiptDataService({
    required this.Database,
    required this.StoreSettings,
  });

  Future<ReceiptData> GetReceiptData({required int TransactionID}) async {
    final TransactionData =
        await (Database.select(Database.transactions)
              ..where((Transaction) => Transaction.ID.equals(TransactionID)))
            .getSingleOrNull();

    if (TransactionData == null) {
      throw StateError('The transaction no longer exists.');
    }

    final TransactionItems =
        await (Database.select(Database.transactionItems)
              ..where((Item) => Item.TransactionID.equals(TransactionID))
              ..orderBy([(Item) => OrderingTerm(expression: Item.ID)]))
            .get();
    final Settings = await StoreSettings.GetSettings();

    return ReceiptData(
      StoreName: Settings.StoreName,
      Address: Settings.Address,
      ContactNumber: Settings.ContactNumber,
      ReceiptFooter: Settings.ReceiptFooter,
      ReceiptNumber: TransactionData.ReceiptNumber,
      CashierName: TransactionData.CashierName,
      CreatedAt: TransactionData.CreatedAt,
      PaymentMethod: TransactionData.PaymentMethod,
      Items: TransactionItems.map(
        (Item) => ReceiptLineItem(
          ProductName: Item.ProductNameSnapshot,
          Unit: Item.UnitSnapshot,
          Quantity: Item.Quantity,
          UnitPriceInCents: Item.UnitPriceInCents,
          LineTotalInCents: Item.LineTotalInCents,
        ),
      ).toList(growable: false),
      TotalInCents: TransactionData.TotalInCents,
    );
  }
}
