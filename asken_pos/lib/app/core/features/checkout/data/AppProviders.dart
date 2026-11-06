import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';
import 'package:asken_pos/app/core/features/checkout/data/TransactionService.dart';
import 'package:asken_pos/app/core/features/checkout/data/session/CheckoutSessionService.dart';
import 'package:asken_pos/app/core/features/checkout/data/session/CashierSessionService.dart';
import 'package:asken_pos/app/core/features/owner/data/ProductManagementService.dart';
import 'package:asken_pos/app/core/features/owner/data/OwnerPinService.dart';

final AppDatabaseProvider = Provider<AppDatabase>((ref) {
  final Database = AppDatabase();

  ref.onDispose(() {
    unawaited(Database.close());
  });

  return Database;
});

final ProductsServiceProvider = Provider<ProductsService>((ref) {
  return ProductsService(Database: ref.watch(AppDatabaseProvider));
});

final CheckoutSessionServiceProvider = Provider<CheckoutSessionService>((ref) {
  return const CheckoutSessionService();
});

final CashierSessionServiceProvider = Provider<CashierSessionService>((ref) {
  return const CashierSessionService();
});

final ActiveCashierProvider = FutureProvider<String?>((ref) async {
  return ref.read(CashierSessionServiceProvider).LoadCashierName();
});

final TransactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(Database: ref.watch(AppDatabaseProvider));
});

final ProductManagementServiceProvider = Provider<ProductManagementService>((
  ref,
) {
  return ProductManagementService(Database: ref.watch(AppDatabaseProvider));
});

final ManagedProductsProvider =
    FutureProvider.autoDispose<List<ProductDataRow>>((ref) {
      return ref
          .read(ProductManagementServiceProvider)
          .SearchProducts(IncludeInactive: true);
    });

final OwnerPinServiceProvider = Provider<OwnerPinService>((ref) {
  return const OwnerPinService();
});

final OwnerPinConfiguredProvider = FutureProvider<bool>((ref) async {
  return ref.read(OwnerPinServiceProvider).HasConfiguredPin();
});

final OwnerModeProvider = NotifierProvider<OwnerModeNotifier, bool>(
  OwnerModeNotifier.new,
);

class OwnerModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void SetOwnerMode(bool IsOwnerMode) {
    state = IsOwnerMode;
  }
}

final AppInitializationProvider = FutureProvider<void>((ref) async {
  await ref.read(AppDatabaseProvider).SeedProducts();
});
