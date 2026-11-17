import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveService.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';

final GoogleDriveConnectionProvider = AsyncNotifierProvider.autoDispose<
  GoogleDriveConnectionNotifier,
  GoogleDriveConnection?
>(GoogleDriveConnectionNotifier.new);

class GoogleDriveConnectionNotifier extends AsyncNotifier<GoogleDriveConnection?> {
  @override
  Future<GoogleDriveConnection?> build() async {
    ref.onDispose(() {
      ref.read(GoogleDriveServiceProvider).Dispose();
    });

    return null;
  }

  Future<void> Connect() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(GoogleDriveServiceProvider).Connect(),
    );
  }

  Future<void> Disconnect() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(GoogleDriveServiceProvider).Disconnect();
      return null;
    });
  }
}
