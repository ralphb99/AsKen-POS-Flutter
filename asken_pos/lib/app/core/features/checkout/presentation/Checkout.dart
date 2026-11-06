import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/TransactionPreview.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';
import 'dart:async';
import 'package:asken_pos/app/core/features/checkout/data/session/CheckoutSessionService.dart';

String formatPeso(int cents) => '₱${(cents / 100).toStringAsFixed(2)}';

class CheckoutPage extends StatefulWidget {
  final String CashierName;
  final ProductsService ProdService;
  final CheckoutSessionService SessionService;

  const CheckoutPage({
    super.key,
    required this.CashierName,
    required this.ProdService,
    required this.SessionService,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<CartItem> CartItems = [];
  final List<ProductDisplayData> ProductData = [];
  Timer? SessionSaveTimer;
  bool IsRestoringSession = true;
  bool IsLoadingProducts = true;
  String? ProductLoadError;
  String SearchQuery = '';


  int get CartTotalInCents => CartItems.fold(
        0,
        (sum, item) => sum + item.LineTotalInCents,
      );


  Future<void> PersistSession() async {
    try {
      final CurrentCart = List<CartItem>.unmodifiable(CartItems);

      if (CurrentCart.isEmpty) {
        await widget.SessionService.ClearSession();
        return;
      }

    await widget.SessionService.SaveSession(
      CashierName: widget.CashierName,
      CartItems: CurrentCart,
    );
  } catch (error) {
    debugPrint('Unable to save checkout session: $error');
  }
}


  void ScheduleSessionSave() {
      SessionSaveTimer?.cancel();

      SessionSaveTimer = Timer(
        const Duration(milliseconds: 400),
        () {
          unawaited(PersistSession());
        },
      );
  }


  //parsers for decoding Session from shared preferences
  int? ReadInt(dynamic Value) {
  if (Value is int) {
    return Value;
  }

  if (Value is num) {
    return Value.toInt();
  }

  return int.tryParse(Value?.toString() ?? '');
}

String? ReadRequiredString(dynamic Value) {
  if (Value is String && Value.trim().isNotEmpty) {
    return Value;
  }

  return null;
}

String? ReadOptionalString(dynamic Value) {
  if (Value is String && Value.trim().isNotEmpty) {
    return Value;
  }

  return null;
}

Future<void> RestoreSession() async {
  try {
    final Session = await widget.SessionService.LoadSession();

    if (!mounted) return;

    if (Session == null) {
      setState(() {
        IsRestoringSession = false;
      });
      return;
    }

    final RawItems = Session['items'];

    if (RawItems is! List) {
      setState(() {
        IsRestoringSession = false;
      });
      return;
    }

    final RestoredItems = <CartItem>[];

    for (final RawItem in RawItems) {
      if (RawItem is! Map) {
        continue;
      }

      final ProductID = ReadInt(RawItem['productId']);
      final ProductVariantID = ReadInt(RawItem['productVariantId']);
      final ProductName = ReadRequiredString(RawItem['productName']);
      final Unit = ReadRequiredString(RawItem['unit']);
      final PriceInCents = ReadInt(RawItem['priceInCents']);
      final Quantity = ReadInt(RawItem['quantity']);

      if (ProductID == null ||
          ProductVariantID == null ||
          ProductName == null ||
          Unit == null ||
          PriceInCents == null ||
          Quantity == null ||
          Quantity <= 0) {
        continue;
      }

      final Product = ProductDisplayData(
        ProductID: ProductID,
        ProductVariantID: ProductVariantID,
        ProductName: ProductName,
        Brand: ReadOptionalString(RawItem['brand']),
        Color: ReadOptionalString(RawItem['color']),
        Size: ReadOptionalString(RawItem['size']),
        Unit: Unit,
        PriceInCents: PriceInCents,
      );

      RestoredItems.add(
        CartItem(
          CartProduct: Product,
          quantity: Quantity,
        ),
      );
    }

    setState(() {
      CartItems
        ..clear()
        ..addAll(RestoredItems);

      IsRestoringSession = false;
    });
  } catch (error) {
    if (!mounted) return;

    setState(() {
      IsRestoringSession = false;
    });

    debugPrint('Unable to restore checkout session: $error');
  }
}
  void addToCart(ProductDisplayData product) {
  setState(() {
    final index = CartItems.indexWhere(
      (item) =>
          item.CartProduct.ProductVariantID ==
          product.ProductVariantID,
    );

    if (index >= 0) {
      CartItems[index].quantity++;
    } else {
      CartItems.add(
        CartItem(
          CartProduct: product,
        ),
      );
    }
  });

  ScheduleSessionSave();
}

  void changeQuantity(int index, int amount) {
  setState(() {
    CartItems[index].quantity += amount;

    if (CartItems[index].quantity <= 0) {
      CartItems.removeAt(index);
    }
  });

  ScheduleSessionSave();
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
      Product.ProductName,
      Product.Brand,
      Product.Color,
      Product.Size,
      Product.Unit,
    ].join(' ').toLowerCase();

    return SearchableText.contains(query);
  }).toList(growable: false);
}

@override
void initState() {
  super.initState();

  LoadProductData();
  RestoreSession();
}

@override
void dispose() {
  SessionSaveTimer?.cancel();
  super.dispose();
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
                          subtitle: Text('${product.Unit} • ${formatPeso(product.PriceInCents)}'),
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
              child: IsRestoringSession
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : CartItems.isEmpty
        ? const Center(
            child: Text('No items added yet.'),
          )
        : ListView.builder(
            itemCount: CartItems.length,
            itemBuilder: (context, index) {
              final item = CartItems[index];

              return ListTile(
                title: Text(
                  item.CartProduct.ProductDisplayName,
                ),
                subtitle: Text(
                  '${item.CartProduct.Unit} × '
                  '${item.quantity} • '
                  '${formatPeso(item.LineTotalInCents)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => changeQuantity(index, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      onPressed: () => changeQuantity(index, 1),
                      icon: const Icon(Icons.add),
                    ),
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
