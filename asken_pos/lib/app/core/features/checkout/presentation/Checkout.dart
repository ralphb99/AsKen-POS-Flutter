import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:asken_pos/app/core/features/checkout/data/SampleProducts.dart';

class CheckoutPage extends StatefulWidget {
  final String CashierName;

  const CheckoutPage({
    super.key,
    required this.CashierName,
  });
@override
  State<CheckoutPage> createState() => _CheckoutPageState();

}

bool MatchesProduct(ProductVariant product, String query) {
  return product.ProductDisplayName.toLowerCase().contains(query.trim().toLowerCase());
}

class _CheckoutPageState extends State<CheckoutPage> {
  // String get CashierName => widget.CashierName;
  final List<CartItem> CartItems = [];
  String SearchQuery = '';

  List<ProductVariant> get filteredProducts {
    final query = SearchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return sampleProducts;
    }

    return sampleProducts.where((product) {
        return product.ProductDisplayName.toLowerCase().contains(query) ||
            product.unit.toLowerCase().contains(query);
      }).toList();
    }

    double get CartTotal {
      return CartItems.fold(
        0, (sum, item) => sum + item.LineTotal,
      );
    }

  void AddToCart(ProductVariant product) {
      setState(() {
        final ExistingIndex = CartItems.indexWhere(
          (item) => item.product.ID == product.ID,
        );

        if (ExistingIndex >= 0) {
          CartItems[ExistingIndex].quantity++;
        } else {
          CartItems.add(CartItem(product: product));
        }
    });
  }

  void IncreaseQuantity(int index) {
    setState(() {
      CartItems[index].quantity++;
    });
  }

  void DecreaseQuantity(int index) {
    setState(() {
      if (CartItems[index].quantity > 1) {
        CartItems[index].quantity--;
      } else {
        CartItems.removeAt(index);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cashier: ${widget.CashierName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
           
                          Text('No items added yet.'),
            

            Spacer(),
            Text('Total: 0.00'),
          ],
        ),
      ),
    );
   }
}
