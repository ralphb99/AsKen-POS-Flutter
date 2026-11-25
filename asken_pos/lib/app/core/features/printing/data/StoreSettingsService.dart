import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class StoreSettingsService {
  final AppDatabase Database;

  const StoreSettingsService({required this.Database});

  Future<StoreSetting> GetSettings() async {
    final Settings =
        await (Database.select(Database.storeSettings)
              ..orderBy([(Setting) => OrderingTerm(expression: Setting.ID)])
              ..limit(1))
            .getSingleOrNull();

    if (Settings != null) {
      return Settings;
    }

    await Database.EnsureStoreSettings();

    return (await (Database.select(Database.storeSettings)
          ..orderBy([(Setting) => OrderingTerm(expression: Setting.ID)])
          ..limit(1))
        .getSingle());
  }

  Future<void> EnsureSettings() async {
    await Database.EnsureStoreSettings();
  }

  Future<void> SaveSettings({
    required String StoreName,
    required String Address,
    required String? ContactNumber,
    required String? ReceiptFooter,
  }) async {
    final Settings = await GetSettings();

    await (Database.update(
      Database.storeSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      StoreSettingsCompanion(
        StoreName: Value(StoreName),
        Address: Value(Address),
        ContactNumber: Value(ContactNumber),
        ReceiptFooter: Value(ReceiptFooter),
      ),
    );
  }
}
