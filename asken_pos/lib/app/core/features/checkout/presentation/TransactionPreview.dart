import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:asken_pos/app/core/features/checkout/application/CheckoutController.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

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

class TransactionPreviewPage extends ConsumerStatefulWidget {
  final String CashierName;
  final List<CartItem> CartItems;
  final int CartTotalInCents;

  const TransactionPreviewPage({
    super.key,
    required this.CashierName,
    required this.CartItems,
    required this.CartTotalInCents,
  });

  @override
  ConsumerState<TransactionPreviewPage> createState() =>
      _TransactionPreviewPageState();
}

class _TransactionPreviewPageState
    extends ConsumerState<TransactionPreviewPage> {
  bool IsSaving = false;
  String? SaveError;

  String FormatPeso(int Cents) => '\u20B1${(Cents / 100).toStringAsFixed(2)}';

  String FormatQuantity(CartItem Item) =>
      '${Item.quantity} ${Item.CartProduct.Unit}';

  Future<void> ConfirmTransaction() async {
    if (IsSaving || widget.CartItems.isEmpty) {
      return;
    }

    setState(() {
      IsSaving = true;
      SaveError = null;
    });

    try {
      final ReceiptNumber = await ref
          .read(TransactionServiceProvider)
          .SaveTransaction(
            CashierName: widget.CashierName,
            CartItems: widget.CartItems,
            CartTotalInCents: widget.CartTotalInCents,
          );

      await ref
          .read(CheckoutControllerProvider(widget.CashierName).notifier)
          .ClearCheckoutSession();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction saved: $ReceiptNumber')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.checkout,
        (Route<dynamic> Route) => false,
        arguments: widget.CashierName,
      );
    } catch (Error) {
      if (!mounted) {
        return;
      }

      setState(() {
        IsSaving = false;
        SaveError = 'Unable to save the transaction. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime Now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Receipt Preview'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, Constraints) {
            final ReceiptWidth = Constraints.maxWidth > 620
                ? 560.0
                : Constraints.maxWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Center(
                child: SizedBox(
                  width: ReceiptWidth,
                  child: Column(
                    children: [
                      _ReceiptCard(
                        StoreName: 'AsKen General Supply Store',
                        Address: 'Brgy 1, Tuburan, Cebu',
                        ContactNumber: null,
                        CashierName: widget.CashierName,
                        DateTimeValue: Now,
                        CartItems: widget.CartItems,
                        CartTotalInCents: widget.CartTotalInCents,
                        FormatPeso: FormatPeso,
                        FormatQuantity: FormatQuantity,
                        Theme: Theme.of(context),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: IsSaving ? null : ConfirmTransaction,
                          label: Text(
                            IsSaving
                                ? 'Saving Transaction...'
                                : 'Confirm Transaction',
                          ),
                          iconAlignment: IconAlignment.end,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SaveError ??
                            'The receipt will be saved locally after confirmation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SaveError == null ? null : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final String StoreName;
  final String Address;
  final String? ContactNumber;
  final String CashierName;
  final DateTime DateTimeValue;
  final List<CartItem> CartItems;
  final int CartTotalInCents;
  final String Function(int Cents) FormatPeso;
  final String Function(CartItem Item) FormatQuantity;
  final ThemeData Theme;

  const _ReceiptCard({
    required this.StoreName,
    required this.Address,
    required this.ContactNumber,
    required this.CashierName,
    required this.DateTimeValue,
    required this.CartItems,
    required this.CartTotalInCents,
    required this.FormatPeso,
    required this.FormatQuantity,
    required this.Theme,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat ReceiptDateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 36,
              color: Theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              StoreName,
              textAlign: TextAlign.center,
              style: Theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Address,
              textAlign: TextAlign.center,
              style: Theme.textTheme.bodyMedium,
            ),
            if (ContactNumber != null && ContactNumber!.isNotEmpty)
              Text(
                ContactNumber!,
                textAlign: TextAlign.center,
                style: Theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 20),
            const _ReceiptDivider(),
            const SizedBox(height: 14),
            _MetadataRow(
              Label: 'Date',
              Value: ReceiptDateFormat.format(DateTimeValue),
            ),
            const SizedBox(height: 6),
            _MetadataRow(Label: 'Cashier', Value: CashierName),
            const SizedBox(height: 6),
            const SizedBox(height: 14),
            const _ReceiptDivider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'ITEM/S',
                    style: Theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'QTY',
                    textAlign: TextAlign.center,
                    style: Theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'AMOUNT',
                    textAlign: TextAlign.end,
                    style: Theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...CartItems.map(
              (Item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Item.CartProduct.ProductDisplayName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${FormatQuantity(Item)} @ '
                            '${FormatPeso(Item.CartProduct.PriceInCents)}',
                            style: Theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${Item.quantity}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        FormatPeso(Item.LineTotalInCents),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _ReceiptDivider(),
            const SizedBox(height: 14),
            // _TotalRow(Label: 'Subtotal', Value: FormatPeso(CartTotalInCents)),
            const SizedBox(height: 8),
            _TotalRow(
              Label: 'TOTAL',
              Value: FormatPeso(CartTotalInCents),
              IsEmphasized: true,
            ),
            const SizedBox(height: 20),
            Text(
              'Thank you for supporting us!',
              textAlign: TextAlign.center,
              style: Theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please check your items before leaving.',
              textAlign: TextAlign.center,
              style: Theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final String Label;
  final String Value;

  const _MetadataRow({required this.Label, required this.Value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Label, style: Theme.of(context).textTheme.bodySmall),
        Flexible(
          child: Text(
            Value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String Label;
  final String Value;
  final bool IsEmphasized;

  const _TotalRow({
    required this.Label,
    required this.Value,
    this.IsEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle BaseStyle = IsEmphasized
        ? Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyLarge!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Label, style: BaseStyle),
        Text(Value, style: BaseStyle),
      ],
    );
  }
}
