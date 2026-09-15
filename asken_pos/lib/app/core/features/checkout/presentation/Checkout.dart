import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/data/SampleProducts.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/TransactionPreview.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

String formatPeso(int cents) => '₱${(cents / 100).toStringAsFixed(2)}';

class CheckoutPage extends StatefulWidget {
  final String CashierName;
  const CheckoutPage({super.key, required this.CashierName});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<CartItem> CartItems = [];
  String SearchQuery = '';

  List<ProductVariant> get filteredProducts {
    final query = SearchQuery.trim().toLowerCase();
    if (query.isEmpty) return [];
    return sampleProducts.where((product) {
      return product.ProductDisplayName.toLowerCase().contains(query) ||
          product.unit.toLowerCase().contains(query);
    }).toList();
  }

  int get CartTotalInCents => CartItems.fold(
        0,
        (sum, item) => sum + item.LineTotalInCents,
      );

  void addToCart(ProductVariant product) {
    setState(() {
      final index = CartItems.indexWhere((item) => item.product.ID == product.ID);
      if (index >= 0) {
        CartItems[index].quantity++;
      } else {
        CartItems.add(CartItem(product: product));
      }
    });
  }

  void changeQuantity(int index, int amount) {
    setState(() {
      CartItems[index].quantity += amount;
      if (CartItems[index].quantity <= 0) CartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('${DateFormat.yMMMEd().format(DateTime.now())}'),
        elevation: 2,
        centerTitle: true,
        shadowColor: Colors.black,
        backgroundColor: Colors.grey.shade50,
      ),
      body: Padding(
      padding: EdgeInsets.only(
        left: 35,
        right: 35,
        top: 20,
        bottom: 90,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cashier: ${widget.CashierName}', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 20),

            TextField(
              onChanged: (value) => setState(() => SearchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search for products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
           Flexible(
              flex: 2,
              child: SearchQuery.trim().isEmpty
                  ? const Center(child: Text('Search for products to add to list'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ListTile(
                          title: Text(product.ProductDisplayName),
                          subtitle: Text('${product.unit} • ${formatPeso(product.priceInCents)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => addToCart(product),
                          ),
                        );
                      },
                    ),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Text(
              'Current items', 
              style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              flex: 2,
              child: CartItems.isEmpty
                  ? Center(child: Text('No items added yet.'))
                  : ListView.builder(
                      itemCount: CartItems.length,
                      itemBuilder: (context, index) {
                        final item = CartItems[index];
                        return ListTile(
                          title: Text(item.product.ProductDisplayName),
                          subtitle: Text('${item.product.unit} × ${item.quantity} • ${formatPeso(item.LineTotalInCents)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () => changeQuantity(index, -1), icon: const Icon(Icons.remove)),
                              Text('${item.quantity}'),
                              IconButton(onPressed: () => changeQuantity(index, 1), icon: const Icon(Icons.add)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text('Total: ${formatPeso(CartTotalInCents)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                   if (CartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Add at least one item first.'),
                        ),
                      );
                      return;
                    }else{
                      Navigator.pushNamed(
                        context,
                        AppRoutes.transactionpreview,
                        arguments: TransactionPreviewArguments(
                          CashierName: widget.CashierName,
                          CartItems: List.unmodifiable(CartItems),
                          CartTotalInCents: CartTotalInCents,
                        ),
                      );
                    } 
                },
                child: Text('Preview Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
