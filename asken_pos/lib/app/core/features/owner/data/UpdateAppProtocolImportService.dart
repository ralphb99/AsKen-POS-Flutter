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
      TransactionSyncBatches: _ReadRecords(Data, 'TransactionSyncBatches'),
      StoreSettings: _ReadRecords(Data, 'StoreSettings'),
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
    final ExistingTransactionSyncBatches = await Database.select(
      Database.transactionSyncBatches,
    ).get();
    final ExistingStoreSettings = await Database.select(
      Database.storeSettings,
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
    final ExistingTransactionSyncBatchIDs = ExistingTransactionSyncBatches.map(
      (Row) => Row.ID,
    ).toSet();
    final ExistingBusinessDates = <String, int>{
      for (final Row in ExistingTransactionSyncBatches)
        Row.BusinessDate: Row.ID,
    };
    final ExistingStoreSettingIDs = ExistingStoreSettings.map(
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

    final InsertStoreSettingIDs = <int>{};
    for (final Row in Document.StoreSettings) {
      final ID = _ReadID(Row, 'StoreSettings');
      if (!ExistingStoreSettingIDs.contains(ID)) {
        InsertStoreSettingIDs.add(ID);
      }
    }

    return _ImportRestorePlan(
      InsertProductIDs: InsertProductIDs,
      InsertProductVariantIDs: InsertProductVariantIDs,
      BatchTargetIDs: BatchTargetIDs,
      InsertTransactionSyncBatchIDs: InsertTransactionSyncBatchIDs,
      InsertTransactionIDs: InsertTransactionIDs,
      InsertTransactionItemIDs: InsertTransactionItemIDs,
      InsertStoreSettingIDs: InsertStoreSettingIDs,
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
      'TransactionSyncBatches': Document.TransactionSyncBatches.length,
      'StoreSettings': Document.StoreSettings.length,
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

    return <String, int>{
      for (final Key in RequiredKeys) Key: _ReadInt(CountsMap, Key, 'Counts'),
    };
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
  final Map<int, int> BatchTargetIDs;
  final Set<int> InsertTransactionSyncBatchIDs;
  final Set<int> InsertTransactionIDs;
  final Set<int> InsertTransactionItemIDs;
  final Set<int> InsertStoreSettingIDs;

  const _ImportRestorePlan({
    required this.InsertProductIDs,
    required this.InsertProductVariantIDs,
    required this.BatchTargetIDs,
    required this.InsertTransactionSyncBatchIDs,
    required this.InsertTransactionIDs,
    required this.InsertTransactionItemIDs,
    required this.InsertStoreSettingIDs,
  });

  Map<String, int> GetInsertedCounts(UpdateAppProtocolImportDocument Document) {
    return <String, int>{
      'Products': InsertProductIDs.length,
      'ProductVariants': InsertProductVariantIDs.length,
      'Transactions': InsertTransactionIDs.length,
      'TransactionItems': InsertTransactionItemIDs.length,
      'TransactionSyncBatches': InsertTransactionSyncBatchIDs.length,
      'StoreSettings': InsertStoreSettingIDs.length,
    };
  }

  Map<String, int> GetSkippedCounts(UpdateAppProtocolImportDocument Document) {
    return <String, int>{
      'Products': Document.Products.length - InsertProductIDs.length,
      'ProductVariants':
          Document.ProductVariants.length - InsertProductVariantIDs.length,
      'Transactions':
          Document.Transactions.length - InsertTransactionIDs.length,
      'TransactionItems':
          Document.TransactionItems.length - InsertTransactionItemIDs.length,
      'TransactionSyncBatches':
          Document.TransactionSyncBatches.length -
          InsertTransactionSyncBatchIDs.length,
      'StoreSettings':
          Document.StoreSettings.length - InsertStoreSettingIDs.length,
    };
  }
}
