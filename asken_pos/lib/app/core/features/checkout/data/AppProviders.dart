import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';
import 'package:asken_pos/app/core/features/checkout/data/TransactionService.dart';
import 'package:asken_pos/app/core/features/checkout/data/session/CheckoutSessionService.dart';
import 'package:asken_pos/app/core/features/checkout/data/session/CashierSessionService.dart';
import 'package:asken_pos/app/core/features/owner/data/ProductManagementService.dart';
import 'package:asken_pos/app/core/features/owner/data/OwnerPinService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionRecordsService.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryService.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryExportService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionRetentionService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncBatchService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncOrchestrator.dart';
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveService.dart';
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveFileUploadService.dart';
import 'package:asken_pos/app/core/features/owner/data/CloudSyncSettingsService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncService.dart';
import 'package:asken_pos/app/core/features/printing/data/ReceiptDataService.dart';
import 'package:asken_pos/app/core/features/printing/data/StoreSettingsService.dart';
import 'package:asken_pos/app/core/features/printing/data/ThermalPrinterService.dart';
import 'package:asken_pos/app/core/features/printing/data/TransactionPrintJobService.dart';
import 'package:asken_pos/app/core/features/printing/data/TransactionPrintService.dart';
import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';
import 'package:asken_pos/app/core/features/owner/data/UpdateAppProtocolExportService.dart';
import 'package:asken_pos/app/core/features/owner/data/UpdateAppProtocolImportService.dart';
import 'package:asken_pos/app/core/features/owner/data/UpdateAppProtocolSnapshotService.dart';

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
  return TransactionService(
    Database: ref.watch(AppDatabaseProvider),
    EodService: ref.watch(EodSummaryServiceProvider),
  );
});

final EodSummaryServiceProvider = Provider<EodSummaryService>((ref) {
  return EodSummaryService(Database: ref.watch(AppDatabaseProvider));
});

final EodSummaryExportServiceProvider = Provider<EodSummaryExportService>(
  (ref) => const EodSummaryExportService(),
);

final TransactionRecordsServiceProvider = Provider<TransactionRecordsService>((
  ref,
) {
  return TransactionRecordsService(Database: ref.watch(AppDatabaseProvider));
});

final TransactionRetentionServiceProvider =
    Provider<TransactionRetentionService>((ref) {
      return TransactionRetentionService(
        Database: ref.watch(AppDatabaseProvider),
      );
    });

final TransactionSyncBatchServiceProvider =
    Provider<TransactionSyncBatchService>((ref) {
      return TransactionSyncBatchService(
        Database: ref.watch(AppDatabaseProvider),
      );
    });

final TransactionSyncOrchestratorProvider =
    Provider<TransactionSyncOrchestrator>((ref) {
      return TransactionSyncOrchestrator(
        BatchService: ref.watch(TransactionSyncBatchServiceProvider),
        RecordsService: ref.watch(TransactionRecordsServiceProvider),
        ExportService: ref.watch(TransactionExportServiceProvider),
        EodService: ref.watch(EodSummaryServiceProvider),
        EodExportService: ref.watch(EodSummaryExportServiceProvider),
        CloudSettingsService: ref.watch(CloudSyncSettingsServiceProvider),
      );
    });

final TransactionExportServiceProvider = Provider<TransactionExportService>(
  (ref) => const TransactionExportService(),
);

final GoogleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  final Service = GoogleDriveService(
    SettingsService: ref.watch(CloudSyncSettingsServiceProvider),
    StoreSettings: ref.watch(StoreSettingsServiceProvider),
  );

  ref.onDispose(() {
    Service.Dispose();
  });

  return Service;
});

final GoogleDriveFileUploadServiceProvider =
    Provider<GoogleDriveFileUploadService>((ref) {
      return GoogleDriveFileUploadService(
        DriveService: ref.watch(GoogleDriveServiceProvider),
      );
    });

final TransactionSyncServiceProvider = Provider<TransactionSyncService>((ref) {
  return TransactionSyncService(
    BatchService: ref.watch(TransactionSyncBatchServiceProvider),
    Orchestrator: ref.watch(TransactionSyncOrchestratorProvider),
    UploadService: ref.watch(GoogleDriveFileUploadServiceProvider),
    CloudSettingsService: ref.watch(CloudSyncSettingsServiceProvider),
  );
});

final CloudSyncSettingsServiceProvider = Provider<CloudSyncSettingsService>(
  (ref) {
    return CloudSyncSettingsService(Database: ref.watch(AppDatabaseProvider));
  },
);

final StoreSettingsServiceProvider = Provider<StoreSettingsService>((Ref) {
  return StoreSettingsService(Database: Ref.watch(AppDatabaseProvider));
});

final StoreSettingsProvider = FutureProvider<StoreSetting>((Ref) {
  return Ref.watch(StoreSettingsServiceProvider).GetSettings();
});

final TransactionPrintJobServiceProvider = Provider<TransactionPrintJobService>(
  (Ref) {
    return TransactionPrintJobService(Database: Ref.watch(AppDatabaseProvider));
  },
);

final ReceiptDataServiceProvider = Provider<ReceiptDataService>((Ref) {
  return ReceiptDataService(
    Database: Ref.watch(AppDatabaseProvider),
    StoreSettings: Ref.watch(StoreSettingsServiceProvider),
  );
});

final ThermalPrinterServiceProvider = Provider<ThermalPrinterService>((Ref) {
  return const PlaceholderThermalPrinterService();
});

final TransactionPrintServiceProvider = Provider<TransactionPrintService>((
  Ref,
) {
  return TransactionPrintService(
    JobService: Ref.watch(TransactionPrintJobServiceProvider),
    ReceiptService: Ref.watch(ReceiptDataServiceProvider),
    PrinterService: Ref.watch(ThermalPrinterServiceProvider),
  );
});

final PendingPrintJobsProvider =
    StreamProvider.autoDispose<List<PendingPrintJob>>(
      (Ref) =>
          Ref.watch(TransactionPrintJobServiceProvider).WatchActionableJobs(),
    );

final TransactionPrintJobProvider = FutureProvider.autoDispose
    .family<TransactionPrintJob?, int>((Ref, TransactionID) {
      return Ref.watch(
        TransactionPrintJobServiceProvider,
      ).GetJob(TransactionID: TransactionID);
    });

final UpdateAppProtocolSnapshotServiceProvider =
    Provider<UpdateAppProtocolSnapshotService>((Ref) {
      return UpdateAppProtocolSnapshotService(
        Database: Ref.watch(AppDatabaseProvider),
      );
    });

final UpdateAppProtocolExportServiceProvider =
    Provider<UpdateAppProtocolExportService>((Ref) {
      return UpdateAppProtocolExportService(
        Database: Ref.watch(AppDatabaseProvider),
        SnapshotService: Ref.watch(UpdateAppProtocolSnapshotServiceProvider),
      );
    });

final UpdateAppProtocolImportServiceProvider =
    Provider<UpdateAppProtocolImportService>((Ref) {
      return UpdateAppProtocolImportService(
        Database: Ref.watch(AppDatabaseProvider),
      );
    });

final TransactionSyncBatchesProvider =
    StreamProvider.autoDispose<List<TransactionSyncBatche>>((ref) {
      return ref
          .watch(TransactionSyncBatchServiceProvider)
          .WatchRecentBatches();
    });

final OwnerTransactionRecordsProvider = FutureProvider.autoDispose
    .family<List<TransactionRecord>, TransactionRecordsDateRange>((ref, Range) {
      return ref
          .read(TransactionRecordsServiceProvider)
          .GetTransactions(From: Range.From, To: Range.To);
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
  await ref.read(StoreSettingsServiceProvider).EnsureSettings();
  await ref.read(CloudSyncSettingsServiceProvider).EnsureSettings();
  await ref.read(EodSummaryServiceProvider).EnsureSummariesFromTransactions();
  await ref
      .read(TransactionSyncBatchServiceProvider)
      .RecoverInterruptedBatches();
  await ref.read(TransactionPrintJobServiceProvider).RecoverInterruptedJobs();
  await ref
      .read(TransactionRetentionServiceProvider)
      .DeleteSyncedTransactionsOlderThan();
});
