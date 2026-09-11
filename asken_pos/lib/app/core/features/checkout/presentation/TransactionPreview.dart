import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Transaction Preview'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Receipt Preview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('AsKen Store'),
            const Text('Store address goes here'),
            const Divider(),
            Text('Cashier: $CashierName'),
            Text('Date: ${DateTime.now()}'),
            const Divider(),
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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ${formatPeso(CartTotalInCents)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
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