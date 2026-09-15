import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPreviewArguments {
  final String CashierName;
  final List<CartItem> CartItems;
  final int CartTotalInCents;

  const TransactionPreviewArguments({
    required this.CashierName,
    required this.CartItems,
    required this.CartTotalInCents,
  });
}
class TransactionPreviewPage extends StatelessWidget {
  final String CashierName;
  final List<CartItem> CartItems;
  final int CartTotalInCents;

  const TransactionPreviewPage({
    super.key,
    required this.CashierName,
    required this.CartItems,
    required this.CartTotalInCents,
  });

  String formatPeso(int cents) {
    return '₱${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transaction Preview'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Text(
                        'AsKen General Supply Store',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
            const SizedBox(height: 16),
           
            Text('Brgy 1, Tuburan, Cebu',  style: Theme.of(context).textTheme.bodyMedium),
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Text('Cashier: $CashierName', style: Theme.of(context).textTheme.bodyMedium),
            Text('Date: ${DateFormat.yMMMMEEEEd().add_jm().format(DateTime.now())}'),
           const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            ...CartItems.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.product.ProductDisplayName),
                subtitle: Text(
                  '${item.product.unit} × ${item.quantity} '
                  '@ ${formatPeso(item.product.priceInCents)}',
                ),
                trailing: Text(
                  formatPeso(item.LineTotalInCents),
                ),
              ),
            ),
            const Divider(),
            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatPeso(CartTotalInCents),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // Database saving comes in the next checkpoint.
              },
              child: const Text('Confirm Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}