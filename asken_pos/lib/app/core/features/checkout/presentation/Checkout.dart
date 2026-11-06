import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:asken_pos/app/core/features/checkout/application/CheckoutController.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/TransactionPreview.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

String formatPeso(int Cents) => '\u20B1${(Cents / 100).toStringAsFixed(2)}';

class CheckoutPage extends ConsumerWidget {
  final String CashierName;

  const CheckoutPage({super.key, required this.CashierName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Checkout = ref.watch(CheckoutControllerProvider(CashierName));
    return Checkout.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (Error, StackTrace) => Scaffold(
        body: Center(child: Text('Unable to load checkout data: $Error')),
      ),
      data: (State) => _CheckoutContent(
        State: State,
        OnLogout: () async {
          await ref
              .read(CheckoutControllerProvider(CashierName).notifier)
              .ClearCheckoutSession();
          await ref.read(CashierSessionServiceProvider).ClearCashierName();
          ref.invalidate(ActiveCashierProvider);

          if (!context.mounted) {
            return;
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (Route<dynamic> Route) => false,
          );
        },
        OnSearchChanged: (Query) => ref
            .read(CheckoutControllerProvider(CashierName).notifier)
            .SetSearchQuery(Query),
        OnAddProduct: (Product) => ref
            .read(CheckoutControllerProvider(CashierName).notifier)
            .AddToCart(Product),
        OnChangeQuantity: (Index, Amount) => ref
            .read(CheckoutControllerProvider(CashierName).notifier)
            .ChangeQuantity(Index, Amount),
      ),
    );
  }
}

class _CheckoutContent extends StatelessWidget {
  final CheckoutState State;
  final Future<void> Function() OnLogout;
  final ValueChanged<String> OnSearchChanged;
  final ValueChanged<ProductDisplayData> OnAddProduct;
  final void Function(int Index, int Amount) OnChangeQuantity;

  const _CheckoutContent({
    required this.State,
    required this.OnLogout,
    required this.OnSearchChanged,
    required this.OnAddProduct,
    required this.OnChangeQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: OnLogout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, Constraints) {
            final IsWideLayout = Constraints.maxWidth >= 760;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: IsWideLayout
                      ? _BuildWideLayout(context)
                      : _BuildMobileLayout(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _BuildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CashierHeader(),
        const SizedBox(height: 20),
        _SearchSection(),
        const SizedBox(height: 20),
        _ProductResults(),
        const SizedBox(height: 20),
        _CartSection(context),
      ],
    );
  }

  Widget _BuildWideLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CashierHeader(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SearchSection(),
                  const SizedBox(height: 20),
                  _ProductResults(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(flex: 5, child: _CartSection(context)),
          ],
        ),
      ],
    );
  }

  Widget _CashierHeader() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade700,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              child: const Icon(Icons.person_outline, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Cashier',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    State.CashierName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextField(
          key: ValueKey<bool>(State.SearchQuery.isNotEmpty),
          onChanged: OnSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search product, color...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: State.SearchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear Search',
                    onPressed: () => OnSearchChanged(''),
                    icon: const Icon(Icons.clear),
                  ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ProductResults() {
    if (State.SearchQuery.trim().isEmpty) {
      return _EmptyPanel(
        IconData: Icons.search_outlined,
        Message: 'Search for a product to add it to the transaction.',
      );
    }

    if (State.FilteredProducts.isEmpty) {
      return _EmptyPanel(
        IconData: Icons.inventory_2_outlined,
        Message: 'No matching products found.',
      );
    }

    return Card(
      shadowColor: Colors.black,
      elevation: 3,
      color: Colors.grey.shade100,
      child: Column(
        children: [
          for (final Product in State.FilteredProducts)
            ListTile(
              contentPadding: const EdgeInsetsGeometry.fromLTRB(14, 4, 14, 4),
              title: Text(
                Product.ProductDisplayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${Product.Unit} • ${formatPeso(Product.PriceInCents)}',
              ),
              trailing: IconButton.filledTonal(
                tooltip: 'Add product',
                onPressed: () => OnAddProduct(Product),
                icon: const Icon(Icons.add),
              ),
            ),
        ],
      ),
    );
  }

  Widget _CartSection(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white.withAlpha(300),
      shadowColor: Colors.black,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Current Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${State.CartItems.length} line item${State.CartItems.length == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (State.CartItems.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 42),
                child: _EmptyPanel(
                  IconData: Icons.shopping_cart_outlined,
                  Message: 'Your order is empty.',
                ),
              )
            else
              ...State.CartItems.asMap().entries.map(
                (Entry) => _CartLine(
                  Item: Entry.value,
                  OnDecrease: () => OnChangeQuantity(Entry.key, -1),
                  OnIncrease: () => OnChangeQuantity(Entry.key, 1),
                ),
              ),
            const Divider(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Text(
                  formatPeso(State.CartTotalInCents),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: State.CartItems.isEmpty
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.transactionpreview,
                        arguments: TransactionPreviewArguments(
                          CashierName: State.CashierName,
                          CartItems: List.unmodifiable(State.CartItems),
                          CartTotalInCents: State.CartTotalInCents,
                        ),
                      );
                    },
              label: const Text('Review Transaction'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _EmptyPanel({required IconData IconData, required String Message}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(IconData, size: 34, color: Colors.grey.shade500),
        const SizedBox(height: 8),
        Text(
          Message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _CartLine extends StatelessWidget {
  final CartItem Item;
  final VoidCallback OnDecrease;
  final VoidCallback OnIncrease;

  const _CartLine({
    required this.Item,
    required this.OnDecrease,
    required this.OnIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Item.CartProduct.ProductDisplayName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  '${Item.CartProduct.Unit} • ${formatPeso(Item.LineTotalInCents)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: OnDecrease,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('${Item.quantity}'),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: OnIncrease,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
