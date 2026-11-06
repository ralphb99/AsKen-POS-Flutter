import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/Login.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/Checkout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AsKenPOS()));
}

class AsKenPOS extends ConsumerWidget {
  const AsKenPOS({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Initialization = ref.watch(AppInitializationProvider);

    return Initialization.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (Error, StackTrace) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Unable to initialize the local database: $Error'),
          ),
        ),
      ),
      data: (_) {
        final ActiveCashier = ref.watch(ActiveCashierProvider);

        return ActiveCashier.when(
          loading: () => const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
          error: (Error, StackTrace) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Unable to restore cashier session: $Error'),
              ),
            ),
          ),
          data: (CashierName) => MaterialApp(
            title: 'AsKen POS',
            debugShowCheckedModeBanner: false,
            home: CashierName == null
                ? const LoginPage()
                : CheckoutPage(CashierName: CashierName),
            onGenerateRoute: (settings) {
              return AppRoutes.generateRoute(settings);
            },
          ),
        );
      },
    );
  }
}
