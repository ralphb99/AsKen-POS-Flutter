import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CheckoutSessionService {
  static const String SessionKey =
      'asken_pos.checkout_session.v1';

  const CheckoutSessionService();

  Future<void> SaveSession({
    required String CashierName,
    required List<CartItem> CartItems,
  }) async {
    final Preferences = await SharedPreferences.getInstance();

    final Session = {
      'version': 1,
      'cashierName': CashierName,
      'updatedAt': DateFormat.yMMMMEEEEd().add_jm().format(DateTime.now()),
      'items': CartItems.map((Item) {
        final Product = Item.CartProduct;

        return {
          'productId': Product.ProductID,
          'productVariantId': Product.ProductVariantID,
          'productName': Product.ProductName,
          'brand': Product.Brand,
          'color': Product.Color,
          'size': Product.Size,
          'unit': Product.Unit,
          'priceInCents': Product.PriceInCents,
          'quantity': Item.quantity,
        };
      }).toList(growable: false),
    };

    await Preferences.setString(
      SessionKey,
      jsonEncode(Session),
    );
  }

  Future<Map<String, dynamic>?> LoadSession() async {
    final Preferences = await SharedPreferences.getInstance();
    final StoredSession = Preferences.getString(SessionKey);

    if (StoredSession == null || StoredSession.isEmpty) {
      return null;
    }

    final DecodedSession = jsonDecode(StoredSession);

    if (DecodedSession is! Map<String, dynamic>) {
      return null;
    }

    return DecodedSession;
  }

  Future<void> ClearSession() async {
    final Preferences = await SharedPreferences.getInstance();
    await Preferences.remove(SessionKey);
  }
}
