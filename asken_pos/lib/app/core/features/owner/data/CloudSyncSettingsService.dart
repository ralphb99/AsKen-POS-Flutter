import 'dart:math';

import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class CloudSyncSettingsService {
  static const String UnprovisionedStatus = 'unprovisioned';
  static const String ProvisioningStatus = 'provisioning';
  static const String ProvisionedStatus = 'provisioned';
  static const String RepairRequiredStatus = 'repair_required';

  final AppDatabase Database;

  const CloudSyncSettingsService({required this.Database});

  Future<CloudSyncSetting> GetSettings() async {
    await EnsureSettings();

    return (await (Database.select(Database.cloudSyncSettings)
          ..orderBy([(Setting) => OrderingTerm(expression: Setting.ID)])
          ..limit(1))
        .getSingle());
  }

  Future<void> EnsureSettings() async {
    final ExistingSettings = await (Database.select(
      Database.cloudSyncSettings,
    )..limit(1)).get();

    if (ExistingSettings.isEmpty) {
      await Database.into(Database.cloudSyncSettings).insert(
        CloudSyncSettingsCompanion.insert(
          TransactionLogsFolderID: '',
          EodLogsFolderID: '',
          InstallationID: Value(_CreateInstallationID()),
          ProvisioningStatus: const Value(UnprovisionedStatus),
          IsAppOwned: const Value(false),
        ),
      );
      return;
    }

    final Settings = ExistingSettings.first;
    if (Settings.InstallationID.isNotEmpty) {
      return;
    }

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        InstallationID: Value(_CreateInstallationID()),
        UpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> BeginProvisioning() async {
    final Settings = await GetSettings();

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        RootFolderID: const Value(null),
        TransactionLogsFolderID: const Value(''),
        EodLogsFolderID: const Value(''),
        FolderOwnerEmail: const Value(null),
        ProvisioningStatus: const Value(ProvisioningStatus),
        IsAppOwned: const Value(false),
        LastValidatedAt: const Value(null),
        UpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> SaveProvisioningProgress({
    String? RootFolderID,
    String? TransactionLogsFolderID,
    String? EodLogsFolderID,
  }) async {
    final Settings = await GetSettings();

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        RootFolderID: RootFolderID == null
            ? const Value.absent()
            : Value(RootFolderID),
        TransactionLogsFolderID: TransactionLogsFolderID == null
            ? const Value.absent()
            : Value(TransactionLogsFolderID),
        EodLogsFolderID: EodLogsFolderID == null
            ? const Value.absent()
            : Value(EodLogsFolderID),
        ProvisioningStatus: const Value(ProvisioningStatus),
        UpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> SaveProvisionedFolders({
    required String RootFolderID,
    required String TransactionLogsFolderID,
    required String EodLogsFolderID,
    required String FolderOwnerEmail,
  }) async {
    final Settings = await GetSettings();
    final ValidationTime = DateTime.now();

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        RootFolderID: Value(RootFolderID),
        TransactionLogsFolderID: Value(TransactionLogsFolderID),
        EodLogsFolderID: Value(EodLogsFolderID),
        FolderOwnerEmail: Value(FolderOwnerEmail),
        ProvisioningStatus: const Value(ProvisionedStatus),
        IsAppOwned: const Value(true),
        LastValidatedAt: Value(ValidationTime),
        UpdatedAt: Value(ValidationTime),
      ),
    );
  }

  Future<void> MarkValidated({required String FolderOwnerEmail}) async {
    final Settings = await GetSettings();
    final ValidationTime = DateTime.now();

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        FolderOwnerEmail: Value(FolderOwnerEmail),
        LastValidatedAt: Value(ValidationTime),
        UpdatedAt: Value(ValidationTime),
      ),
    );
  }

  Future<void> MarkProvisioningFailed() async {
    final Settings = await GetSettings();

    await (Database.update(
      Database.cloudSyncSettings,
    )..where((Setting) => Setting.ID.equals(Settings.ID))).write(
      CloudSyncSettingsCompanion(
        ProvisioningStatus: const Value(RepairRequiredStatus),
        IsAppOwned: const Value(false),
        UpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  String _CreateInstallationID() {
    final Generator = Random.secure();
    final Bytes = List<int>.generate(
      16,
      (_) => Generator.nextInt(256),
      growable: false,
    );

    return Bytes.map(
      (Byte) => Byte.toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}
