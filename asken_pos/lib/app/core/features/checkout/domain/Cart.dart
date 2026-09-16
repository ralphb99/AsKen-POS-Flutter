import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';

class CartItem {
  final ProductDisplayData CartProduct;
  int quantity;

  CartItem({
    required this.CartProduct,
    this.quantity = 1,
  });

  int get LineTotalInCents => CartProduct.Variant.PriceInCents * quantity;
}
