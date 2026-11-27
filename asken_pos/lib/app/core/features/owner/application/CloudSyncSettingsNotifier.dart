import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';

final CloudSyncSettingsProvider = AsyncNotifierProvider.autoDispose<
  CloudSyncSettingsNotifier,
  CloudSyncSetting
>(CloudSyncSettingsNotifier.new);

class CloudSyncSettingsNotifier extends AsyncNotifier<CloudSyncSetting> {
  @override
  Future<CloudSyncSetting> build() {
    return ref.read(CloudSyncSettingsServiceProvider).GetSettings();
  }
}
