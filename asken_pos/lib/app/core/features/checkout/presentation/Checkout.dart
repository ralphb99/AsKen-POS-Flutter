import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/TransactionPreview.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';


String formatPeso(int cents) => '₱${(cents / 100).toStringAsFixed(2)}';

class CheckoutPage extends StatefulWidget {
  final String CashierName;
  final ProductsService ProdService;

  const CheckoutPage({
    super.key,
    required this.CashierName,
    required this.ProdService,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<CartItem> CartItems = [];
  final List<ProductDisplayData> ProductData = [];

  bool IsLoadingProducts = true;
  String? ProductLoadError;
  String SearchQuery = '';


  int get CartTotalInCents => CartItems.fold(
        0,
        (sum, item) => sum + item.LineTotalInCents,
      );

  void addToCart(ProductDisplayData product) {
    setState(() {
      final index = CartItems.indexWhere((item) => item.CartProduct.Variant.ID == product.Variant.ID);
      if (index >= 0) {
        CartItems[index].quantity++;
      } else {
        CartItems.add(CartItem(CartProduct: product));
      }
    });
  }

  void changeQuantity(int index, int amount) {
    setState(() {
      CartItems[index].quantity += amount;
      if (CartItems[index].quantity <= 0) CartItems.removeAt(index);
    });
  }

  Future<void> LoadProductData() async {
  try {
    final Products = await widget.ProdService.GetProductData();

    if (!mounted) return;

    setState(() {
      ProductData
        ..clear()
        ..addAll(Products);

      IsLoadingProducts = false;
      ProductLoadError = null;
    });
  } catch (error) {
    if (!mounted) return;

    setState(() {
      IsLoadingProducts = false;
      ProductLoadError = error.toString();
    });
  }
}

List<ProductDisplayData> get filteredProducts {
  final query = SearchQuery.trim().toLowerCase();

  if (query.isEmpty) {
    return [];
  }

  return ProductData.where((Product) {
    final SearchableText = [
      Product.ProductDisplayName,
      Product.StoreProduct.ProductName,
      Product.StoreProduct.Brand,
      Product.Variant.Color,
      Product.Variant.Size,
      Product.Variant.Unit,
    ].join(' ').toLowerCase();

    return SearchableText.contains(query);
  }).toList(growable: false);
}

@override
void initState() {
  super.initState();
  LoadProductData();
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
                          subtitle: Text('${product.Variant.Unit} • ${formatPeso(product.Variant.PriceInCents)}'),
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
                          title: Text(item.CartProduct.ProductDisplayName),
                          subtitle: Text('${item.CartProduct.Variant.Unit} × ${item.quantity} • ${formatPeso(item.LineTotalInCents)}'),
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
