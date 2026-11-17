import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncService.dart';

final TransactionSyncProvider = AsyncNotifierProvider.autoDispose<
  TransactionSyncNotifier,
  TransactionSyncResult?
>(TransactionSyncNotifier.new);

class TransactionSyncNotifier extends AsyncNotifier<TransactionSyncResult?> {
  @override
  Future<TransactionSyncResult?> build() async => null;

  Future<void> SyncNow() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(TransactionSyncServiceProvider).SyncPendingBatches(),
    );
  }
}
