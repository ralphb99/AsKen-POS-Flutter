import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryService.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

class TransactionService {
  final AppDatabase Database;
  final EodSummaryService EodService;

  const TransactionService({required this.Database, required this.EodService});

  Future<SavedTransaction> SaveTransaction({
    required String CashierName,
    required List<CartItem> CartItems,
    required int CartTotalInCents,
  }) async {
    if (CartItems.isEmpty) {
      throw ArgumentError('A transaction must contain at least one item.');
    }

    final ReceiptNumber = _CreateReceiptNumber();

    return Database.transaction(() async {
      final TransactionID = await Database.into(Database.transactions).insert(
        TransactionsCompanion.insert(
          ReceiptNumber: ReceiptNumber,
          CashierName: CashierName,
          TotalInCents: CartTotalInCents,
          PaymentMethod: const Value('cash'),
        ),
      );

      for (final Item in CartItems) {
        final Product = Item.CartProduct;

        await Database.into(Database.transactionItems).insert(
          TransactionItemsCompanion.insert(
            TransactionID: TransactionID,
            ProductVariantID: Product.ProductVariantID,
            ProductNameSnapshot: Product.ProductDisplayName,
            UnitSnapshot: Product.Unit,
            UnitPriceInCents: Product.PriceInCents,
            Quantity: Item.quantity,
            LineTotalInCents: Item.LineTotalInCents,
          ),
        );
      }

      await Database.into(Database.transactionPrintJobs).insert(
        TransactionPrintJobsCompanion.insert(TransactionID: TransactionID),
      );

      final SavedTransactionData =
          await (Database.select(Database.transactions)
                ..where((Transaction) => Transaction.ID.equals(TransactionID)))
              .getSingle();

      await EodService.RecordSale(
        SoldAt: SavedTransactionData.CreatedAt,
        Lines: CartItems.map(
          (Item) => EodSaleLine(
            ProductVariantID: Item.CartProduct.ProductVariantID,
            ProductName: Item.CartProduct.ProductDisplayName,
            Unit: Item.CartProduct.Unit,
            UnitPriceInCents: Item.CartProduct.PriceInCents,
            Quantity: Item.quantity,
            LineTotalInCents: Item.LineTotalInCents,
          ),
        ).toList(growable: false),
        SaleTotalInCents: CartTotalInCents,
      );

      return SavedTransaction(
        TransactionID: SavedTransactionData.ID,
        ReceiptNumber: SavedTransactionData.ReceiptNumber,
        CreatedAt: SavedTransactionData.CreatedAt,
      );
    });
  }

  String _CreateReceiptNumber() {
    final Now = DateTime.now();
    final Timestamp = DateFormat('yyyyMMdd-HHmmss').format(Now);
    final Microseconds = Now.microsecond.toString().padLeft(6, '0');

    return 'ASK-$Timestamp-$Microseconds';
  }
}

class SavedTransaction {
  final int TransactionID;
  final String ReceiptNumber;
  final DateTime CreatedAt;

  const SavedTransaction({
    required this.TransactionID,
    required this.ReceiptNumber,
    required this.CreatedAt,
  });
}
