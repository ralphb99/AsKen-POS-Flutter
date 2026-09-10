import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';

class CartItem {
  final ProductVariant product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get LineTotal => product.price * quantity;
}