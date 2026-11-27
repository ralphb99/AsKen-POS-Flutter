import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/owner/data/UpdateAppProtocolExportService.dart';
import 'package:asken_pos/app/core/features/owner/domain/UpdateAppProtocolImport.dart';

class UpdateAppProtocolImportService {
  static const Set<String> SupportedTransactionSyncStatuses = <String>{
    'pending',
    'uploading',
    'synced',
    'failed',
  };

  final AppDatabase Database;

  const UpdateAppProtocolImportService({required this.Database});

  Future<UpdateAppProtocolImportDocument?> PickAndValidate() async {
    final SelectedFiles = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['askenbackup'],
      dialogTitle: 'Select an AsKen POS update backup',
    );

    if (SelectedFiles.isEmpty) {
      return null;
    }

    final SelectedFile = SelectedFiles.first;
    final FileBytes = await SelectedFile.readAsBytes();

    return _ParseDocument(
      SourceFileName: SelectedFile.name,
      FileBytes: FileBytes,
    );
  }

  Future<UpdateAppProtocolImportPreview> BuildPreview(
    UpdateAppProtocolImportDocument Document,
  ) async {
    final Plan = await Database.transaction(() => _BuildRestorePlan(Document));

    return UpdateAppProtocolImportPreview(
      SourceFileName: Document.SourceFileName,
      CreatedAtUtc: Document.CreatedAtUtc,
      IncomingCounts: _GetIncomingCounts(Document),
      ConflictCounts: Plan.GetSkippedCounts(Document),
      UnsyncedTransactionCount: Document.GetUnsyncedTransactionCount(),
    );
  }

  Future<UpdateAppProtocolImportResult> Restore(
    UpdateAppProtocolImportDocument Document,
  ) async {
    return Database.transaction(() async {
      final Plan = await _BuildRestorePlan(Document);

      for (final ProductRow in Document.Products) {
        final ProductID = _ReadID(ProductRow, 'Products');
        if (!Plan.InsertProductIDs.contains(ProductID)) {
          continue;
        }

        await Database.into(Database.products).insert(
          ProductsCompanion.insert(
            ID: Value(ProductID),
            ProductName: _ReadString(ProductRow, 'ProductName', 'Products'),
            Brand: Value(_ReadNullableString(ProductRow, 'Brand', 'Products')),
            IsActive: Value(_ReadBool(ProductRow, 'IsActive', 'Products')),
            CreatedAt: Value(
              _ReadDateTime(ProductRow, 'CreatedAt', 'Products'),
            ),
          ),
        );
      }

      for (final ProductVariantRow in Document.ProductVariants) {
        final ProductVariantID = _ReadID(ProductVariantRow, 'ProductVariants');
        if (!Plan.InsertProductVariantIDs.contains(ProductVariantID)) {
          continue;
        }

        await Database.into(Database.productVariants).insert(
          ProductVariantsCompanion.insert(
            ID: Value(ProductVariantID),
            ProductID: _ReadInt(
              ProductVariantRow,
              'ProductID',
              'ProductVariants',
            ),
            Color: Value(
              _ReadNullableString(
                ProductVariantRow,
                'Color',
                'ProductVariants',
              ),
            ),
            Size: Value(
              _ReadNullableString(ProductVariantRow, 'Size', 'ProductVariants'),
            ),
            Unit: _ReadString(ProductVariantRow, 'Unit', 'ProductVariants'),
            PriceInCents: _ReadInt(
              ProductVariantRow,
              'PriceInCents',
              'ProductVariants',
            ),
            IsActive: Value(
              _ReadBool(ProductVariantRow, 'IsActive', 'ProductVariants'),
            ),
          ),
        );
      }

      for (final EodSummaryRow in Document.EodSummaries) {
        final EodSummaryID = _ReadID(EodSummaryRow, 'EodSummaries');
        if (!Plan.InsertEodSummaryIDs.contains(EodSummaryID)) {
          continue;
        }

        await Database.into(Database.eodSummaries).insert(
          EodSummariesCompanion.insert(
            ID: Value(EodSummaryID),
            BusinessDate: _ReadString(
              EodSummaryRow,
              'BusinessDate',
              'EodSummaries',
            ),
            TransactionCount: Value(
              _ReadInt(EodSummaryRow, 'TransactionCount', 'EodSummaries'),
            ),
            SoldUnitCount: Value(
              _ReadInt(EodSummaryRow, 'SoldUnitCount', 'EodSummaries'),
            ),
            TotalSalesInCents: Value(
              _ReadInt(EodSummaryRow, 'TotalSalesInCents', 'EodSummaries'),
            ),
            CreatedAt: Value(
              _ReadDateTime(EodSummaryRow, 'CreatedAt', 'EodSummaries'),
            ),
            UpdatedAt: Value(
              _ReadDateTime(EodSummaryRow, 'UpdatedAt', 'EodSummaries'),
            ),
          ),
        );
      }

      for (final EodSummaryItemRow in Document.EodSummaryItems) {
        final EodSummaryItemID = _ReadID(EodSummaryItemRow, 'EodSummaryItems');
        if (!Plan.InsertEodSummaryItemIDs.contains(EodSummaryItemID)) {
          continue;
        }

        final SourceEodSummaryID = _ReadInt(
          EodSummaryItemRow,
          'EodSummaryID',
          'EodSummaryItems',
        );
        final TargetEodSummaryID = Plan.EodSummaryTargetIDs[SourceEodSummaryID];
        if (TargetEodSummaryID == null) {
          throw StateError(
            'The target EOD summary for $SourceEodSummaryID is missing.',
          );
        }

        await Database.into(Database.eodSummaryItems).insert(
          EodSummaryItemsCompanion.insert(
            ID: Value(EodSummaryItemID),
            EodSummaryID: TargetEodSummaryID,
            ProductVariantID: _ReadInt(
              EodSummaryItemRow,
              'ProductVariantID',
              'EodSummaryItems',
            ),
            ProductNameSnapshot: _ReadString(
              EodSummaryItemRow,
              'ProductNameSnapshot',
              'EodSummaryItems',
            ),
            UnitSnapshot: _ReadString(
              EodSummaryItemRow,
              'UnitSnapshot',
              'EodSummaryItems',
            ),
            UnitPriceInCents: _ReadInt(
              EodSummaryItemRow,
              'UnitPriceInCents',
              'EodSummaryItems',
            ),
            SoldUnits: _ReadInt(
              EodSummaryItemRow,
              'SoldUnits',
              'EodSummaryItems',
            ),
            SoldTotalInCents: _ReadInt(
              EodSummaryItemRow,
              'SoldTotalInCents',
              'EodSummaryItems',
            ),
          ),
        );
      }

      for (final TransactionSyncBatchRow in Document.TransactionSyncBatches) {
        final TransactionSyncBatchID = _ReadID(
          TransactionSyncBatchRow,
          'TransactionSyncBatches',
        );
        if (!Plan.InsertTransactionSyncBatchIDs.contains(
          TransactionSyncBatchID,
        )) {
          continue;
        }

        await Database.into(Database.transactionSyncBatches).insert(
          TransactionSyncBatchesCompanion.insert(
            ID: Value(TransactionSyncBatchID),
            BusinessDate: _ReadString(
              TransactionSyncBatchRow,
              'BusinessDate',
              'TransactionSyncBatches',
            ),
            FileName: _ReadString(
              TransactionSyncBatchRow,
              'FileName',
              'TransactionSyncBatches',
            ),
            TextFileName: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'TextFileName',
                'TransactionSyncBatches',
              ),
            ),
            RemoteFileID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'RemoteFileID',
                'TransactionSyncBatches',
              ),
            ),
            RemoteTextFileID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'RemoteTextFileID',
                'TransactionSyncBatches',
              ),
            ),
            Checksum: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'Checksum',
                'TransactionSyncBatches',
              ),
            ),
            TextChecksum: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'TextChecksum',
                'TransactionSyncBatches',
              ),
            ),
            EodFileName: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodFileName',
                'TransactionSyncBatches',
              ),
            ),
            EodTextFileName: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodTextFileName',
                'TransactionSyncBatches',
              ),
            ),
            EodRemoteFileID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodRemoteFileID',
                'TransactionSyncBatches',
              ),
            ),
            EodRemoteTextFileID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodRemoteTextFileID',
                'TransactionSyncBatches',
              ),
            ),
            EodChecksum: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodChecksum',
                'TransactionSyncBatches',
              ),
            ),
            EodTextChecksum: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodTextChecksum',
                'TransactionSyncBatches',
              ),
            ),
            TransactionLogsFolderID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'TransactionLogsFolderID',
                'TransactionSyncBatches',
              ),
            ),
            EodLogsFolderID: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'EodLogsFolderID',
                'TransactionSyncBatches',
              ),
            ),
            RecordCount: Value(
              _ReadInt(
                TransactionSyncBatchRow,
                'RecordCount',
                'TransactionSyncBatches',
              ),
            ),
            Status: Value(
              _ReadString(
                TransactionSyncBatchRow,
                'Status',
                'TransactionSyncBatches',
              ),
            ),
            AttemptCount: Value(
              _ReadInt(
                TransactionSyncBatchRow,
                'AttemptCount',
                'TransactionSyncBatches',
              ),
            ),
            LastAttemptAt: Value(
              _ReadNullableDateTime(
                TransactionSyncBatchRow,
                'LastAttemptAt',
                'TransactionSyncBatches',
              ),
            ),
            LastError: Value(
              _ReadNullableString(
                TransactionSyncBatchRow,
                'LastError',
                'TransactionSyncBatches',
              ),
            ),
            UploadedAt: Value(
              _ReadNullableDateTime(
                TransactionSyncBatchRow,
                'UploadedAt',
                'TransactionSyncBatches',
              ),
            ),
            CreatedAt: Value(
              _ReadDateTime(
                TransactionSyncBatchRow,
                'CreatedAt',
                'TransactionSyncBatches',
              ),
            ),
          ),
        );
      }

      for (final TransactionRow in Document.Transactions) {
        final TransactionID = _ReadID(TransactionRow, 'Transactions');
        if (!Plan.InsertTransactionIDs.contains(TransactionID)) {
          continue;
        }

        final SourceSyncBatchID = _ReadNullableString(
          TransactionRow,
          'SyncBatchID',
          'Transactions',
        );
        final TargetSyncBatchID = SourceSyncBatchID == null
            ? null
            : Plan.BatchTargetIDs[int.parse(SourceSyncBatchID)]?.toString();

        await Database.into(Database.transactions).insert(
          TransactionsCompanion.insert(
            ID: Value(TransactionID),
            ReceiptNumber: _ReadString(
              TransactionRow,
              'ReceiptNumber',
              'Transactions',
            ),
            CashierName: _ReadString(
              TransactionRow,
              'CashierName',
              'Transactions',
            ),
            TotalInCents: _ReadInt(
              TransactionRow,
              'TotalInCents',
              'Transactions',
            ),
            Status: Value(
              _ReadString(TransactionRow, 'Status', 'Transactions'),
            ),
            PaymentMethod: Value(
              _ReadString(TransactionRow, 'PaymentMethod', 'Transactions'),
            ),
            SyncStatus: Value(
              _ReadString(TransactionRow, 'SyncStatus', 'Transactions'),
            ),
            SyncAttemptCount: Value(
              _ReadInt(TransactionRow, 'SyncAttemptCount', 'Transactions'),
            ),
            LastSyncAttemptAt: Value(
              _ReadNullableDateTime(
                TransactionRow,
                'LastSyncAttemptAt',
                'Transactions',
              ),
            ),
            SyncedAt: Value(
              _ReadNullableDateTime(TransactionRow, 'SyncedAt', 'Transactions'),
            ),
            LastSyncError: Value(
              _ReadNullableString(
                TransactionRow,
                'LastSyncError',
                'Transactions',
              ),
            ),
            SyncBatchID: Value(TargetSyncBatchID),
            CreatedAt: Value(
              _ReadDateTime(TransactionRow, 'CreatedAt', 'Transactions'),
            ),
          ),
        );
      }

      for (final TransactionPrintJobRow in Document.TransactionPrintJobs) {
        final TransactionPrintJobID = _ReadID(
          TransactionPrintJobRow,
          'TransactionPrintJobs',
        );
        if (!Plan.InsertTransactionPrintJobIDs.contains(
          TransactionPrintJobID,
        )) {
          continue;
        }

        await Database.into(Database.transactionPrintJobs).insert(
          TransactionPrintJobsCompanion.insert(
            ID: Value(TransactionPrintJobID),
            TransactionID: _ReadInt(
              TransactionPrintJobRow,
              'TransactionID',
              'TransactionPrintJobs',
            ),
            Status: Value(
              _ReadString(
                TransactionPrintJobRow,
                'Status',
                'TransactionPrintJobs',
              ),
            ),
            AttemptCount: Value(
              _ReadInt(
                TransactionPrintJobRow,
                'AttemptCount',
                'TransactionPrintJobs',
              ),
            ),
            LastAttemptAt: Value(
              _ReadNullableDateTime(
                TransactionPrintJobRow,
                'LastAttemptAt',
                'TransactionPrintJobs',
              ),
            ),
            PrintedAt: Value(
              _ReadNullableDateTime(
                TransactionPrintJobRow,
                'PrintedAt',
                'TransactionPrintJobs',
              ),
            ),
            LastError: Value(
              _ReadNullableString(
                TransactionPrintJobRow,
                'LastError',
                'TransactionPrintJobs',
              ),
            ),
            CreatedAt: Value(
              _ReadDateTime(
                TransactionPrintJobRow,
                'CreatedAt',
                'TransactionPrintJobs',
              ),
            ),
          ),
        );
      }

      for (final TransactionItemRow in Document.TransactionItems) {
        final TransactionItemID = _ReadID(
          TransactionItemRow,
          'TransactionItems',
        );
        if (!Plan.InsertTransactionItemIDs.contains(TransactionItemID)) {
          continue;
        }

        await Database.into(Database.transactionItems).insert(
          TransactionItemsCompanion.insert(
            ID: Value(TransactionItemID),
            TransactionID: _ReadInt(
              TransactionItemRow,
              'TransactionID',
              'TransactionItems',
            ),
            ProductVariantID: _ReadInt(
              TransactionItemRow,
              'ProductVariantID',
              'TransactionItems',
            ),
            ProductNameSnapshot: _ReadString(
              TransactionItemRow,
              'ProductNameSnapshot',
              'TransactionItems',
            ),
            UnitSnapshot: _ReadString(
              TransactionItemRow,
              'UnitSnapshot',
              'TransactionItems',
            ),
            UnitPriceInCents: _ReadInt(
              TransactionItemRow,
              'UnitPriceInCents',
              'TransactionItems',
            ),
            Quantity: _ReadInt(
              TransactionItemRow,
              'Quantity',
              'TransactionItems',
            ),
            LineTotalInCents: _ReadInt(
              TransactionItemRow,
              'LineTotalInCents',
              'TransactionItems',
            ),
          ),
        );
      }

      for (final StoreSettingRow in Document.StoreSettings) {
        final StoreSettingID = _ReadID(StoreSettingRow, 'StoreSettings');
        if (!Plan.InsertStoreSettingIDs.contains(StoreSettingID)) {
          continue;
        }

        await Database.into(Database.storeSettings).insert(
          StoreSettingsCompanion.insert(
            ID: Value(StoreSettingID),
            StoreName: _ReadString(
              StoreSettingRow,
              'StoreName',
              'StoreSettings',
            ),
            Address: _ReadString(StoreSettingRow, 'Address', 'StoreSettings'),
            ContactNumber: Value(
              _ReadNullableString(
                StoreSettingRow,
                'ContactNumber',
                'StoreSettings',
              ),
            ),
            ReceiptFooter: Value(
              _ReadNullableString(
                StoreSettingRow,
                'ReceiptFooter',
                'StoreSettings',
              ),
            ),
          ),
        );
      }

      for (final CloudSyncSettingRow in Document.CloudSyncSettings) {
        final CloudSyncSettingID = _ReadID(
          CloudSyncSettingRow,
          'CloudSyncSettings',
        );
        if (!Plan.InsertCloudSyncSettingIDs.contains(CloudSyncSettingID)) {
          continue;
        }

        await Database.into(Database.cloudSyncSettings).insert(
          CloudSyncSettingsCompanion.insert(
            ID: Value(CloudSyncSettingID),
            RootFolderID: Value(
              _ReadNullableString(
                CloudSyncSettingRow,
                'RootFolderID',
                'CloudSyncSettings',
              ),
            ),
            TransactionLogsFolderID: _ReadString(
              CloudSyncSettingRow,
              'TransactionLogsFolderID',
              'CloudSyncSettings',
            ),
            EodLogsFolderID: _ReadString(
              CloudSyncSettingRow,
              'EodLogsFolderID',
              'CloudSyncSettings',
            ),
            InstallationID: Value(
              _ReadNullableString(
                    CloudSyncSettingRow,
                    'InstallationID',
                    'CloudSyncSettings',
                  ) ??
                  '',
            ),
            FolderOwnerEmail: Value(
              _ReadNullableString(
                CloudSyncSettingRow,
                'FolderOwnerEmail',
                'CloudSyncSettings',
              ),
            ),
            ProvisioningStatus: Value(
              _ReadNullableString(
                    CloudSyncSettingRow,
                    'ProvisioningStatus',
                    'CloudSyncSettings',
                  ) ??
                  'unprovisioned',
            ),
            IsAppOwned: Value(
              _ReadBoolOrDefault(
                CloudSyncSettingRow,
                'IsAppOwned',
                'CloudSyncSettings',
                false,
              ),
            ),
            LastValidatedAt: Value(
              _ReadNullableDateTime(
                CloudSyncSettingRow,
                'LastValidatedAt',
                'CloudSyncSettings',
              ),
            ),
            UpdatedAt: Value(
              _ReadDateTime(
                CloudSyncSettingRow,
                'UpdatedAt',
                'CloudSyncSettings',
              ),
            ),
          ),
        );
      }

      return UpdateAppProtocolImportResult(
        InsertedCounts: Plan.GetInsertedCounts(Document),
        SkippedCounts: Plan.GetSkippedCounts(Document),
        UnsyncedTransactionsRestored: Document.Transactions.where(
          (TransactionRow) =>
              Plan.InsertTransactionIDs.contains(
                _ReadID(TransactionRow, 'Transactions'),
              ) &&
              _ReadString(TransactionRow, 'SyncStatus', 'Transactions') !=
                  'synced',
        ).length,
      );
    });
  }

  UpdateAppProtocolImportDocument _ParseDocument({
    required String SourceFileName,
    required List<int> FileBytes,
  }) {
    dynamic DecodedDocument;

    try {
      DecodedDocument = jsonDecode(utf8.decode(FileBytes));
    } catch (Error) {
      throw FormatException('The selected backup is not valid UTF-8 JSON.');
    }

    if (DecodedDocument is! Map) {
      throw FormatException('The selected backup has no valid document root.');
    }

    final Document = Map<String, dynamic>.from(DecodedDocument);
    final Manifest = _ReadMap(Document['Manifest'], 'Manifest');
    final Data = _ReadMap(Document['Data'], 'Data');
    final ProtocolName = _ReadString(Manifest, 'ProtocolName', 'Manifest');
    final ProtocolVersion = _ReadInt(Manifest, 'ProtocolVersion', 'Manifest');
    final DatabaseSchemaVersion = _ReadInt(
      Manifest,
      'DatabaseSchemaVersion',
      'Manifest',
    );
    final CreatedAtUtc = _ReadDateTime(Manifest, 'CreatedAtUtc', 'Manifest');
    final DataChecksumSHA256 = _ReadString(
      Manifest,
      'DataChecksumSHA256',
      'Manifest',
    );
    final Counts = _ReadCounts(Manifest['Counts']);

    if (ProtocolName != UpdateAppProtocolExportService.ProtocolName) {
      throw FormatException('This backup is not an AsKen POS backup.');
    }

    if (ProtocolVersion != UpdateAppProtocolExportService.ProtocolVersion) {
      throw FormatException(
        'Unsupported backup protocol version: $ProtocolVersion.',
      );
    }

    if (DatabaseSchemaVersion > Database.schemaVersion) {
      throw FormatException(
        'This backup needs database schema version $DatabaseSchemaVersion, but this app supports version ${Database.schemaVersion}.',
      );
    }

    final ActualChecksumSHA256 = sha256
        .convert(utf8.encode(jsonEncode(Data)))
        .toString();
    if (ActualChecksumSHA256 != DataChecksumSHA256) {
      throw FormatException(
        'The backup checksum does not match. The file may be damaged or modified.',
      );
    }

    final ParsedDocument = UpdateAppProtocolImportDocument(
      SourceFileName: SourceFileName,
      ProtocolVersion: ProtocolVersion,
      DatabaseSchemaVersion: DatabaseSchemaVersion,
      CreatedAtUtc: CreatedAtUtc,
      DataChecksumSHA256: DataChecksumSHA256,
      Counts: Counts,
      Products: _ReadRecords(Data, 'Products'),
      ProductVariants: _ReadRecords(Data, 'ProductVariants'),
      Transactions: _ReadRecords(Data, 'Transactions'),
      TransactionItems: _ReadRecords(Data, 'TransactionItems'),
      TransactionPrintJobs: _ReadOptionalRecords(Data, 'TransactionPrintJobs'),
      TransactionSyncBatches: _ReadRecords(Data, 'TransactionSyncBatches'),
      EodSummaries: _ReadOptionalRecords(Data, 'EodSummaries'),
      EodSummaryItems: _ReadOptionalRecords(Data, 'EodSummaryItems'),
      StoreSettings: _ReadRecords(Data, 'StoreSettings'),
      CloudSyncSettings: _ReadOptionalRecords(Data, 'CloudSyncSettings'),
    );

    _ValidateDocumentData(ParsedDocument);
    return ParsedDocument;
  }

  Future<_ImportRestorePlan> _BuildRestorePlan(
    UpdateAppProtocolImportDocument Document,
  ) async {
    final ExistingProducts = await Database.select(Database.products).get();
    final ExistingProductVariants = await Database.select(
      Database.productVariants,
    ).get();
    final ExistingTransactions = await Database.select(
      Database.transactions,
    ).get();
    final ExistingTransactionItems = await Database.select(
      Database.transactionItems,
    ).get();
    final ExistingTransactionPrintJobs = await Database.select(
      Database.transactionPrintJobs,
    ).get();
    final ExistingTransactionSyncBatches = await Database.select(
      Database.transactionSyncBatches,
    ).get();
    final ExistingEodSummaries = await Database.select(
      Database.eodSummaries,
    ).get();
    final ExistingEodSummaryItems = await Database.select(
      Database.eodSummaryItems,
    ).get();
    final ExistingStoreSettings = await Database.select(
      Database.storeSettings,
    ).get();
    final ExistingCloudSyncSettings = await Database.select(
      Database.cloudSyncSettings,
    ).get();

    final ExistingProductIDs = ExistingProducts.map((Row) => Row.ID).toSet();
    final ExistingProductVariantIDs = ExistingProductVariants.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingTransactionIDs = ExistingTransactions.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingReceiptNumbers = ExistingTransactions.map(
      (Row) => Row.ReceiptNumber,
    ).toSet();
    final ExistingTransactionItemIDs = ExistingTransactionItems.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingTransactionPrintJobIDs = ExistingTransactionPrintJobs.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingTransactionPrintJobTransactionIDs =
        ExistingTransactionPrintJobs.map((Row) => Row.TransactionID).toSet();
    final ExistingTransactionSyncBatchIDs = ExistingTransactionSyncBatches.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingBusinessDates = <String, int>{
      for (final Row in ExistingTransactionSyncBatches)
        Row.BusinessDate: Row.ID,
    };
    final ExistingEodSummaryIDs = ExistingEodSummaries.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingEodBusinessDates = <String, int>{
      for (final Row in ExistingEodSummaries) Row.BusinessDate: Row.ID,
    };
    final ExistingEodSummaryItemIDs = ExistingEodSummaryItems.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingStoreSettingIDs = ExistingStoreSettings.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingCloudSyncSettingIDs = ExistingCloudSyncSettings.map(
      (Row) => Row.ID,
    ).toSet();

    final InsertProductIDs = <int>{};
    for (final Row in Document.Products) {
      final ID = _ReadID(Row, 'Products');
      if (!ExistingProductIDs.contains(ID)) {
        InsertProductIDs.add(ID);
      }
    }

    final InsertProductVariantIDs = <int>{};
    for (final Row in Document.ProductVariants) {
      final ID = _ReadID(Row, 'ProductVariants');
      if (!ExistingProductVariantIDs.contains(ID)) {
        InsertProductVariantIDs.add(ID);
      }
    }

    final EodSummaryTargetIDs = <int, int>{};
    final InsertEodSummaryIDs = <int>{};
    for (final Row in Document.EodSummaries) {
      final SourceID = _ReadID(Row, 'EodSummaries');
      final BusinessDate = _ReadString(Row, 'BusinessDate', 'EodSummaries');
      if (ExistingEodSummaryIDs.contains(SourceID)) {
        EodSummaryTargetIDs[SourceID] = SourceID;
      } else if (ExistingEodBusinessDates.containsKey(BusinessDate)) {
        EodSummaryTargetIDs[SourceID] = ExistingEodBusinessDates[BusinessDate]!;
      } else {
        EodSummaryTargetIDs[SourceID] = SourceID;
        InsertEodSummaryIDs.add(SourceID);
      }
    }

    final InsertEodSummaryItemIDs = <int>{};
    for (final Row in Document.EodSummaryItems) {
      final ID = _ReadID(Row, 'EodSummaryItems');
      final SourceEodSummaryID = _ReadInt(
        Row,
        'EodSummaryID',
        'EodSummaryItems',
      );
      if (!ExistingEodSummaryItemIDs.contains(ID) &&
          InsertEodSummaryIDs.contains(SourceEodSummaryID)) {
        InsertEodSummaryItemIDs.add(ID);
      }
    }

    final BatchTargetIDs = <int, int>{};
    final InsertTransactionSyncBatchIDs = <int>{};
    for (final Row in Document.TransactionSyncBatches) {
      final SourceID = _ReadID(Row, 'TransactionSyncBatches');
      final BusinessDate = _ReadString(
        Row,
        'BusinessDate',
        'TransactionSyncBatches',
      );
      if (ExistingTransactionSyncBatchIDs.contains(SourceID)) {
        BatchTargetIDs[SourceID] = SourceID;
      } else if (ExistingBusinessDates.containsKey(BusinessDate)) {
        BatchTargetIDs[SourceID] = ExistingBusinessDates[BusinessDate]!;
      } else {
        BatchTargetIDs[SourceID] = SourceID;
        InsertTransactionSyncBatchIDs.add(SourceID);
      }
    }

    final InsertTransactionIDs = <int>{};
    for (final Row in Document.Transactions) {
      final ID = _ReadID(Row, 'Transactions');
      final ReceiptNumber = _ReadString(Row, 'ReceiptNumber', 'Transactions');
      if (!ExistingTransactionIDs.contains(ID) &&
          !ExistingReceiptNumbers.contains(ReceiptNumber)) {
        InsertTransactionIDs.add(ID);
      }
    }

    final InsertTransactionItemIDs = <int>{};
    for (final Row in Document.TransactionItems) {
      final ID = _ReadID(Row, 'TransactionItems');
      final TransactionID = _ReadInt(Row, 'TransactionID', 'TransactionItems');
      if (!ExistingTransactionItemIDs.contains(ID) &&
          InsertTransactionIDs.contains(TransactionID)) {
        InsertTransactionItemIDs.add(ID);
      }
    }

    final InsertTransactionPrintJobIDs = <int>{};
    for (final Row in Document.TransactionPrintJobs) {
      final ID = _ReadID(Row, 'TransactionPrintJobs');
      final TransactionID = _ReadInt(
        Row,
        'TransactionID',
        'TransactionPrintJobs',
      );
      if (!ExistingTransactionPrintJobIDs.contains(ID) &&
          !ExistingTransactionPrintJobTransactionIDs.contains(TransactionID) &&
          InsertTransactionIDs.contains(TransactionID)) {
        InsertTransactionPrintJobIDs.add(ID);
      }
    }

    final InsertStoreSettingIDs = <int>{};
    for (final Row in Document.StoreSettings) {
      final ID = _ReadID(Row, 'StoreSettings');
      if (!ExistingStoreSettingIDs.contains(ID)) {
        InsertStoreSettingIDs.add(ID);
      }
    }

    final InsertCloudSyncSettingIDs = <int>{};
    for (final Row in Document.CloudSyncSettings) {
      final ID = _ReadID(Row, 'CloudSyncSettings');
      if (!ExistingCloudSyncSettingIDs.contains(ID)) {
        InsertCloudSyncSettingIDs.add(ID);
      }
    }

    return _ImportRestorePlan(
      InsertProductIDs: InsertProductIDs,
      InsertProductVariantIDs: InsertProductVariantIDs,
      EodSummaryTargetIDs: EodSummaryTargetIDs,
      InsertEodSummaryIDs: InsertEodSummaryIDs,
      InsertEodSummaryItemIDs: InsertEodSummaryItemIDs,
      BatchTargetIDs: BatchTargetIDs,
      InsertTransactionSyncBatchIDs: InsertTransactionSyncBatchIDs,
      InsertTransactionIDs: InsertTransactionIDs,
      InsertTransactionItemIDs: InsertTransactionItemIDs,
      InsertTransactionPrintJobIDs: InsertTransactionPrintJobIDs,
      InsertStoreSettingIDs: InsertStoreSettingIDs,
      InsertCloudSyncSettingIDs: InsertCloudSyncSettingIDs,
    );
  }

  Map<String, int> _GetIncomingCounts(
    UpdateAppProtocolImportDocument Document,
  ) {
    return <String, int>{
      'Products': Document.Products.length,
      'ProductVariants': Document.ProductVariants.length,
      'Transactions': Document.Transactions.length,
      'TransactionItems': Document.TransactionItems.length,
      'TransactionPrintJobs': Document.TransactionPrintJobs.length,
      'TransactionSyncBatches': Document.TransactionSyncBatches.length,
      'EodSummaries': Document.EodSummaries.length,
      'EodSummaryItems': Document.EodSummaryItems.length,
      'StoreSettings': Document.StoreSettings.length,
      'CloudSyncSettings': Document.CloudSyncSettings.length,
    };
  }

  List<Map<String, dynamic>> _ReadRecords(
    Map<String, dynamic> Data,
    String Key,
  ) {
    final RawRecords = Data[Key];
    if (RawRecords is! List) {
      throw FormatException('The backup data collection "$Key" is missing.');
    }

    return RawRecords.map((Record) {
      if (Record is! Map) {
        throw FormatException('The backup collection "$Key" is invalid.');
      }

      return Map<String, dynamic>.from(Record);
    }).toList(growable: false);
  }

  List<Map<String, dynamic>> _ReadOptionalRecords(
    Map<String, dynamic> Data,
    String Key,
  ) {
    if (!Data.containsKey(Key)) {
      return const <Map<String, dynamic>>[];
    }

    return _ReadRecords(Data, Key);
  }

  Map<String, dynamic> _ReadMap(dynamic Value, String FieldName) {
    if (Value is! Map) {
      throw FormatException('The backup field "$FieldName" is invalid.');
    }

    return Map<String, dynamic>.from(Value);
  }

  Map<String, int> _ReadCounts(dynamic Value) {
    final CountsMap = _ReadMap(Value, 'Counts');
    const RequiredKeys = <String>[
      'Products',
      'ProductVariants',
      'Transactions',
      'TransactionItems',
      'TransactionSyncBatches',
      'StoreSettings',
    ];

    final Result = <String, int>{
      for (final Key in RequiredKeys) Key: _ReadInt(CountsMap, Key, 'Counts'),
    };

    Result['TransactionPrintJobs'] =
        CountsMap.containsKey('TransactionPrintJobs')
        ? _ReadInt(CountsMap, 'TransactionPrintJobs', 'Counts')
        : 0;
    Result['EodSummaries'] = CountsMap.containsKey('EodSummaries')
        ? _ReadInt(CountsMap, 'EodSummaries', 'Counts')
        : 0;
    Result['EodSummaryItems'] = CountsMap.containsKey('EodSummaryItems')
        ? _ReadInt(CountsMap, 'EodSummaryItems', 'Counts')
        : 0;
    Result['CloudSyncSettings'] = CountsMap.containsKey('CloudSyncSettings')
        ? _ReadInt(CountsMap, 'CloudSyncSettings', 'Counts')
        : 0;

    return Result;
  }

  void _ValidateDocumentData(UpdateAppProtocolImportDocument Document) {
    final ProductIDs = <int>{};
    for (final Row in Document.Products) {
      final ID = _ReadID(Row, 'Products');
      _EnsureUnique(ProductIDs, ID, 'Products');
      _ReadString(Row, 'ProductName', 'Products');
      _ReadNullableString(Row, 'Brand', 'Products');
      _ReadBool(Row, 'IsActive', 'Products');
      _ReadDateTime(Row, 'CreatedAt', 'Products');
    }

    final ProductVariantIDs = <int>{};
    for (final Row in Document.ProductVariants) {
      final ID = _ReadID(Row, 'ProductVariants');
      _EnsureUnique(ProductVariantIDs, ID, 'ProductVariants');
      final ProductID = _ReadInt(Row, 'ProductID', 'ProductVariants');
      if (!ProductIDs.contains(ProductID)) {
        throw FormatException(
          'Product variant $ID references missing product $ProductID.',
        );
      }
      _ReadNullableString(Row, 'Color', 'ProductVariants');
      _ReadNullableString(Row, 'Size', 'ProductVariants');
      _ReadString(Row, 'Unit', 'ProductVariants');
      _ReadInt(Row, 'PriceInCents', 'ProductVariants');
      _ReadBool(Row, 'IsActive', 'ProductVariants');
    }

    final EodSummaryIDs = <int>{};
    final EodBusinessDates = <String>{};
    for (final Row in Document.EodSummaries) {
      final ID = _ReadID(Row, 'EodSummaries');
      _EnsureUnique(EodSummaryIDs, ID, 'EodSummaries');
      final BusinessDate = _ReadString(Row, 'BusinessDate', 'EodSummaries');
      _EnsureUnique(EodBusinessDates, BusinessDate, 'EodSummaries');
      if (DateTime.tryParse(BusinessDate) == null) {
        throw FormatException(
          'Invalid business date "$BusinessDate" in EodSummaries.',
        );
      }
      final TransactionCount = _ReadInt(
        Row,
        'TransactionCount',
        'EodSummaries',
      );
      final SoldUnitCount = _ReadInt(Row, 'SoldUnitCount', 'EodSummaries');
      final TotalSalesInCents = _ReadInt(
        Row,
        'TotalSalesInCents',
        'EodSummaries',
      );
      if (TransactionCount < 0 || SoldUnitCount < 0 || TotalSalesInCents < 0) {
        throw FormatException('Negative totals are not valid in EodSummaries.');
      }
      _ReadDateTime(Row, 'CreatedAt', 'EodSummaries');
      _ReadDateTime(Row, 'UpdatedAt', 'EodSummaries');
    }

    final EodSummaryItemIDs = <int>{};
    for (final Row in Document.EodSummaryItems) {
      final ID = _ReadID(Row, 'EodSummaryItems');
      _EnsureUnique(EodSummaryItemIDs, ID, 'EodSummaryItems');
      final EodSummaryID = _ReadInt(Row, 'EodSummaryID', 'EodSummaryItems');
      if (!EodSummaryIDs.contains(EodSummaryID)) {
        throw FormatException(
          'EOD item $ID references missing EOD summary $EodSummaryID.',
        );
      }
      final ProductVariantID = _ReadInt(
        Row,
        'ProductVariantID',
        'EodSummaryItems',
      );
      if (!ProductVariantIDs.contains(ProductVariantID)) {
        throw FormatException(
          'EOD item $ID references missing product variant $ProductVariantID.',
        );
      }
      _ReadString(Row, 'ProductNameSnapshot', 'EodSummaryItems');
      _ReadString(Row, 'UnitSnapshot', 'EodSummaryItems');
      final UnitPriceInCents = _ReadInt(
        Row,
        'UnitPriceInCents',
        'EodSummaryItems',
      );
      final SoldUnits = _ReadInt(Row, 'SoldUnits', 'EodSummaryItems');
      final SoldTotalInCents = _ReadInt(
        Row,
        'SoldTotalInCents',
        'EodSummaryItems',
      );
      if (UnitPriceInCents < 0 || SoldUnits < 0 || SoldTotalInCents < 0) {
        throw FormatException(
          'Negative values are not valid in EodSummaryItems.',
        );
      }
    }

    final TransactionSyncBatchIDs = <int>{};
    final BusinessDates = <String>{};
    for (final Row in Document.TransactionSyncBatches) {
      final ID = _ReadID(Row, 'TransactionSyncBatches');
      _EnsureUnique(TransactionSyncBatchIDs, ID, 'TransactionSyncBatches');
      final BusinessDate = _ReadString(
        Row,
        'BusinessDate',
        'TransactionSyncBatches',
      );
      _EnsureUnique(BusinessDates, BusinessDate, 'TransactionSyncBatches');
      _ReadString(Row, 'FileName', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'TextFileName', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'RemoteFileID', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'RemoteTextFileID', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'Checksum', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'TextChecksum', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodFileName', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodTextFileName', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodRemoteFileID', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodRemoteTextFileID', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodChecksum', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'EodTextChecksum', 'TransactionSyncBatches');
      _ReadNullableString(
        Row,
        'TransactionLogsFolderID',
        'TransactionSyncBatches',
      );
      _ReadNullableString(Row, 'EodLogsFolderID', 'TransactionSyncBatches');
      _ReadInt(Row, 'RecordCount', 'TransactionSyncBatches');
      _ValidateSyncStatus(
        _ReadString(Row, 'Status', 'TransactionSyncBatches'),
        'TransactionSyncBatches',
      );
      _ReadInt(Row, 'AttemptCount', 'TransactionSyncBatches');
      _ReadNullableDateTime(Row, 'LastAttemptAt', 'TransactionSyncBatches');
      _ReadNullableString(Row, 'LastError', 'TransactionSyncBatches');
      _ReadNullableDateTime(Row, 'UploadedAt', 'TransactionSyncBatches');
      _ReadDateTime(Row, 'CreatedAt', 'TransactionSyncBatches');
    }

    final TransactionIDs = <int>{};
    final ReceiptNumbers = <String>{};
    for (final Row in Document.Transactions) {
      final ID = _ReadID(Row, 'Transactions');
      _EnsureUnique(TransactionIDs, ID, 'Transactions');
      final ReceiptNumber = _ReadString(Row, 'ReceiptNumber', 'Transactions');
      _EnsureUnique(ReceiptNumbers, ReceiptNumber, 'Transactions');
      _ReadString(Row, 'CashierName', 'Transactions');
      _ReadInt(Row, 'TotalInCents', 'Transactions');
      _ReadString(Row, 'Status', 'Transactions');
      _ReadString(Row, 'PaymentMethod', 'Transactions');
      _ValidateSyncStatus(
        _ReadString(Row, 'SyncStatus', 'Transactions'),
        'Transactions',
      );
      _ReadInt(Row, 'SyncAttemptCount', 'Transactions');
      _ReadNullableDateTime(Row, 'LastSyncAttemptAt', 'Transactions');
      _ReadNullableDateTime(Row, 'SyncedAt', 'Transactions');
      _ReadNullableString(Row, 'LastSyncError', 'Transactions');
      final SyncBatchID = _ReadNullableString(
        Row,
        'SyncBatchID',
        'Transactions',
      );
      if (SyncBatchID != null) {
        final ParsedSyncBatchID = int.tryParse(SyncBatchID);
        if (ParsedSyncBatchID == null ||
            !TransactionSyncBatchIDs.contains(ParsedSyncBatchID)) {
          throw FormatException(
            'Transaction $ID references missing sync batch $SyncBatchID.',
          );
        }
      }
      _ReadDateTime(Row, 'CreatedAt', 'Transactions');
    }

    final TransactionPrintJobIDs = <int>{};
    final TransactionPrintJobTransactionIDs = <int>{};
    for (final Row in Document.TransactionPrintJobs) {
      final ID = _ReadID(Row, 'TransactionPrintJobs');
      _EnsureUnique(TransactionPrintJobIDs, ID, 'TransactionPrintJobs');
      final TransactionID = _ReadInt(
        Row,
        'TransactionID',
        'TransactionPrintJobs',
      );
      _EnsureUnique(
        TransactionPrintJobTransactionIDs,
        TransactionID,
        'TransactionPrintJobs',
      );
      if (!TransactionIDs.contains(TransactionID)) {
        throw FormatException(
          'Print job $ID references missing transaction $TransactionID.',
        );
      }
      _ValidatePrintStatus(_ReadString(Row, 'Status', 'TransactionPrintJobs'));
      _ReadInt(Row, 'AttemptCount', 'TransactionPrintJobs');
      _ReadNullableDateTime(Row, 'LastAttemptAt', 'TransactionPrintJobs');
      _ReadNullableDateTime(Row, 'PrintedAt', 'TransactionPrintJobs');
      _ReadNullableString(Row, 'LastError', 'TransactionPrintJobs');
      _ReadDateTime(Row, 'CreatedAt', 'TransactionPrintJobs');
    }

    final TransactionItemIDs = <int>{};
    for (final Row in Document.TransactionItems) {
      final ID = _ReadID(Row, 'TransactionItems');
      _EnsureUnique(TransactionItemIDs, ID, 'TransactionItems');
      final TransactionID = _ReadInt(Row, 'TransactionID', 'TransactionItems');
      if (!TransactionIDs.contains(TransactionID)) {
        throw FormatException(
          'Transaction item $ID references missing transaction $TransactionID.',
        );
      }
      final ProductVariantID = _ReadInt(
        Row,
        'ProductVariantID',
        'TransactionItems',
      );
      if (!ProductVariantIDs.contains(ProductVariantID)) {
        throw FormatException(
          'Transaction item $ID references missing product variant $ProductVariantID.',
        );
      }
      _ReadString(Row, 'ProductNameSnapshot', 'TransactionItems');
      _ReadString(Row, 'UnitSnapshot', 'TransactionItems');
      _ReadInt(Row, 'UnitPriceInCents', 'TransactionItems');
      _ReadInt(Row, 'Quantity', 'TransactionItems');
      _ReadInt(Row, 'LineTotalInCents', 'TransactionItems');
    }

    final StoreSettingIDs = <int>{};
    for (final Row in Document.StoreSettings) {
      final ID = _ReadID(Row, 'StoreSettings');
      _EnsureUnique(StoreSettingIDs, ID, 'StoreSettings');
      _ReadString(Row, 'StoreName', 'StoreSettings');
      _ReadString(Row, 'Address', 'StoreSettings');
      _ReadNullableString(Row, 'ContactNumber', 'StoreSettings');
      _ReadNullableString(Row, 'ReceiptFooter', 'StoreSettings');
    }

    final CloudSyncSettingIDs = <int>{};
    for (final Row in Document.CloudSyncSettings) {
      final ID = _ReadID(Row, 'CloudSyncSettings');
      _EnsureUnique(CloudSyncSettingIDs, ID, 'CloudSyncSettings');
      _ReadString(Row, 'TransactionLogsFolderID', 'CloudSyncSettings');
      _ReadString(Row, 'EodLogsFolderID', 'CloudSyncSettings');
      _ReadNullableString(Row, 'RootFolderID', 'CloudSyncSettings');
      _ReadNullableString(Row, 'InstallationID', 'CloudSyncSettings');
      _ReadNullableString(Row, 'FolderOwnerEmail', 'CloudSyncSettings');
      _ReadNullableString(Row, 'ProvisioningStatus', 'CloudSyncSettings');
      _ReadNullableBool(Row, 'IsAppOwned', 'CloudSyncSettings');
      _ReadNullableDateTime(Row, 'LastValidatedAt', 'CloudSyncSettings');
      _ReadDateTime(Row, 'UpdatedAt', 'CloudSyncSettings');
    }

    final IncomingCounts = _GetIncomingCounts(Document);
    for (final Entry in IncomingCounts.entries) {
      if (Document.Counts[Entry.key] != Entry.value) {
        throw FormatException(
          'The manifest count for ${Entry.key} does not match its data.',
        );
      }
    }
  }

  void _ValidateSyncStatus(String Status, String CollectionName) {
    if (!SupportedTransactionSyncStatuses.contains(Status)) {
      throw FormatException(
        'Unsupported sync status "$Status" in $CollectionName.',
      );
    }
  }

  void _ValidatePrintStatus(String Status) {
    const SupportedStatuses = <String>{
      'pending',
      'printing',
      'printed',
      'failed',
    };

    if (!SupportedStatuses.contains(Status)) {
      throw FormatException('Unsupported print status "$Status".');
    }
  }

  void _EnsureUnique<T>(Set<T> Values, T Value, String CollectionName) {
    if (!Values.add(Value)) {
      throw FormatException('Duplicate ID or key found in $CollectionName.');
    }
  }

  int _ReadID(Map<String, dynamic> Row, String CollectionName) {
    final ID = _ReadInt(Row, 'ID', CollectionName);
    if (ID <= 0) {
      throw FormatException('Invalid ID $ID found in $CollectionName.');
    }
    return ID;
  }

  int _ReadInt(Map<String, dynamic> Row, String Key, String CollectionName) {
    final Value = Row[Key];
    if (Value is int) {
      return Value;
    }

    if (Value is num && Value == Value.toInt()) {
      return Value.toInt();
    }

    throw FormatException(
      'Field "$Key" in $CollectionName must be an integer.',
    );
  }

  bool _ReadBool(Map<String, dynamic> Row, String Key, String CollectionName) {
    final Value = Row[Key];
    if (Value is bool) {
      return Value;
    }

    throw FormatException('Field "$Key" in $CollectionName must be a boolean.');
  }

  bool _ReadBoolOrDefault(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
    bool DefaultValue,
  ) {
    if (!Row.containsKey(Key) || Row[Key] == null) {
      return DefaultValue;
    }

    return _ReadBool(Row, Key, CollectionName);
  }

  bool? _ReadNullableBool(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
  ) {
    if (!Row.containsKey(Key) || Row[Key] == null) {
      return null;
    }

    return _ReadBool(Row, Key, CollectionName);
  }

  String _ReadString(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
  ) {
    final Value = Row[Key];
    if (Value is String && Value.isNotEmpty) {
      return Value;
    }

    throw FormatException('Field "$Key" in $CollectionName must be text.');
  }

  String? _ReadNullableString(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
  ) {
    final Value = Row[Key];
    if (Value == null) {
      return null;
    }

    if (Value is String) {
      return Value;
    }

    throw FormatException(
      'Field "$Key" in $CollectionName must be text or null.',
    );
  }

  DateTime _ReadDateTime(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
  ) {
    final Value = _ReadNullableDateTime(Row, Key, CollectionName);
    if (Value == null) {
      throw FormatException('Field "$Key" in $CollectionName must be a date.');
    }
    return Value;
  }

  DateTime? _ReadNullableDateTime(
    Map<String, dynamic> Row,
    String Key,
    String CollectionName,
  ) {
    final Value = Row[Key];
    if (Value == null) {
      return null;
    }

    if (Value is String) {
      final ParsedDateTime = DateTime.tryParse(Value);
      if (ParsedDateTime != null) {
        return ParsedDateTime;
      }
    }

    throw FormatException(
      'Field "$Key" in $CollectionName must be a date or null.',
    );
  }
}

class _ImportRestorePlan {
  final Set<int> InsertProductIDs;
  final Set<int> InsertProductVariantIDs;
  final Map<int, int> EodSummaryTargetIDs;
  final Set<int> InsertEodSummaryIDs;
  final Set<int> InsertEodSummaryItemIDs;
  final Map<int, int> BatchTargetIDs;
  final Set<int> InsertTransactionSyncBatchIDs;
  final Set<int> InsertTransactionIDs;
  final Set<int> InsertTransactionItemIDs;
  final Set<int> InsertTransactionPrintJobIDs;
  final Set<int> InsertStoreSettingIDs;
  final Set<int> InsertCloudSyncSettingIDs;

  const _ImportRestorePlan({
    required this.InsertProductIDs,
    required this.InsertProductVariantIDs,
    required this.EodSummaryTargetIDs,
    required this.InsertEodSummaryIDs,
    required this.InsertEodSummaryItemIDs,
    required this.BatchTargetIDs,
    required this.InsertTransactionSyncBatchIDs,
    required this.InsertTransactionIDs,
    required this.InsertTransactionItemIDs,
    required this.InsertTransactionPrintJobIDs,
    required this.InsertStoreSettingIDs,
    required this.InsertCloudSyncSettingIDs,
  });

  Map<String, int> GetInsertedCounts(UpdateAppProtocolImportDocument Document) {
    return <String, int>{
      'Products': InsertProductIDs.length,
      'ProductVariants': InsertProductVariantIDs.length,
      'EodSummaries': InsertEodSummaryIDs.length,
      'EodSummaryItems': InsertEodSummaryItemIDs.length,
      'Transactions': InsertTransactionIDs.length,
      'TransactionItems': InsertTransactionItemIDs.length,
      'TransactionPrintJobs': InsertTransactionPrintJobIDs.length,
      'TransactionSyncBatches': InsertTransactionSyncBatchIDs.length,
      'StoreSettings': InsertStoreSettingIDs.length,
      'CloudSyncSettings': InsertCloudSyncSettingIDs.length,
    };
  }

  Map<String, int> GetSkippedCounts(UpdateAppProtocolImportDocument Document) {
    return <String, int>{
      'Products': Document.Products.length - InsertProductIDs.length,
      'ProductVariants':
          Document.ProductVariants.length - InsertProductVariantIDs.length,
      'EodSummaries': Document.EodSummaries.length - InsertEodSummaryIDs.length,
      'EodSummaryItems':
          Document.EodSummaryItems.length - InsertEodSummaryItemIDs.length,
      'Transactions':
          Document.Transactions.length - InsertTransactionIDs.length,
      'TransactionItems':
          Document.TransactionItems.length - InsertTransactionItemIDs.length,
      'TransactionPrintJobs':
          Document.TransactionPrintJobs.length -
          InsertTransactionPrintJobIDs.length,
      'TransactionSyncBatches':
          Document.TransactionSyncBatches.length -
          InsertTransactionSyncBatchIDs.length,
      'StoreSettings':
          Document.StoreSettings.length - InsertStoreSettingIDs.length,
      'CloudSyncSettings':
          Document.CloudSyncSettings.length - InsertCloudSyncSettingIDs.length,
    };
  }
}
