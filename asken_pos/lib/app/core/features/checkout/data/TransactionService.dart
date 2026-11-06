import 'package:intl/intl.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';

class TransactionService {
  final AppDatabase Database;

  const TransactionService({required this.Database});

  Future<String> SaveTransaction({
    required String CashierName,
    required List<CartItem> CartItems,
    required int CartTotalInCents,
  }) async {
    if (CartItems.isEmpty) {
      throw ArgumentError('A transaction must contain at least one item.');
    }

    final ReceiptNumber = _CreateReceiptNumber();

    await Database.transaction(() async {
      final TransactionID = await Database.into(Database.transactions).insert(
        TransactionsCompanion.insert(
          ReceiptNumber: ReceiptNumber,
          CashierName: CashierName,
          TotalInCents: CartTotalInCents,
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
    });

    return ReceiptNumber;
  }

  String _CreateReceiptNumber() {
    final Now = DateTime.now();
    final Timestamp = DateFormat('yyyyMMdd-HHmmss').format(Now);
    final Microseconds = Now.microsecond.toString().padLeft(6, '0');

    return 'ASK-$Timestamp-$Microseconds';
  }
}
