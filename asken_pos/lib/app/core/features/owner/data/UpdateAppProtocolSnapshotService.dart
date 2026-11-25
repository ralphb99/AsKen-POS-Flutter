import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/owner/domain/UpdateAppProtocol.dart';

class UpdateAppProtocolSnapshotService {
  final AppDatabase Database;

  const UpdateAppProtocolSnapshotService({required this.Database});

  Future<UpdateAppProtocolSnapshot> CreateSnapshot() {
    return Database.transaction(() async {
      final ProductRows = await Database.select(Database.products).get();
      final ProductVariantRows = await Database.select(
        Database.productVariants,
      ).get();
      final TransactionRows = await Database.select(
        Database.transactions,
      ).get();
      final TransactionItemRows = await Database.select(
        Database.transactionItems,
      ).get();
      final TransactionSyncBatchRows = await Database.select(
        Database.transactionSyncBatches,
      ).get();
      final StoreSettingRows = await Database.select(
        Database.storeSettings,
      ).get();

      return UpdateAppProtocolSnapshot(
        Products: ProductRows.map(_MapProduct).toList(growable: false),
        ProductVariants: ProductVariantRows.map(
          _MapProductVariant,
        ).toList(growable: false),
        Transactions: TransactionRows.map(
          _MapTransaction,
        ).toList(growable: false),
        TransactionItems: TransactionItemRows.map(
          _MapTransactionItem,
        ).toList(growable: false),
        TransactionSyncBatches: TransactionSyncBatchRows.map(
          _MapTransactionSyncBatch,
        ).toList(growable: false),
        StoreSettings: StoreSettingRows.map(
          _MapStoreSetting,
        ).toList(growable: false),
      );
    });
  }

  Map<String, dynamic> _MapProduct(Product ProductRow) {
    return <String, dynamic>{
      'ID': ProductRow.ID,
      'ProductName': ProductRow.ProductName,
      'Brand': ProductRow.Brand,
      'IsActive': ProductRow.IsActive,
      'CreatedAt': _FormatDateTime(ProductRow.CreatedAt),
    };
  }

  Map<String, dynamic> _MapProductVariant(ProductVariant ProductVariantRow) {
    return <String, dynamic>{
      'ID': ProductVariantRow.ID,
      'ProductID': ProductVariantRow.ProductID,
      'Color': ProductVariantRow.Color,
      'Size': ProductVariantRow.Size,
      'Unit': ProductVariantRow.Unit,
      'PriceInCents': ProductVariantRow.PriceInCents,
      'IsActive': ProductVariantRow.IsActive,
    };
  }

  Map<String, dynamic> _MapTransaction(Transaction TransactionRow) {
    return <String, dynamic>{
      'ID': TransactionRow.ID,
      'ReceiptNumber': TransactionRow.ReceiptNumber,
      'CashierName': TransactionRow.CashierName,
      'TotalInCents': TransactionRow.TotalInCents,
      'Status': TransactionRow.Status,
      'PaymentMethod': TransactionRow.PaymentMethod,
      'SyncStatus': TransactionRow.SyncStatus,
      'SyncAttemptCount': TransactionRow.SyncAttemptCount,
      'LastSyncAttemptAt': _FormatDateTime(TransactionRow.LastSyncAttemptAt),
      'SyncedAt': _FormatDateTime(TransactionRow.SyncedAt),
      'LastSyncError': TransactionRow.LastSyncError,
      'SyncBatchID': TransactionRow.SyncBatchID,
      'CreatedAt': _FormatDateTime(TransactionRow.CreatedAt),
    };
  }

  Map<String, dynamic> _MapTransactionItem(TransactionItem TransactionItemRow) {
    return <String, dynamic>{
      'ID': TransactionItemRow.ID,
      'TransactionID': TransactionItemRow.TransactionID,
      'ProductVariantID': TransactionItemRow.ProductVariantID,
      'ProductNameSnapshot': TransactionItemRow.ProductNameSnapshot,
      'UnitSnapshot': TransactionItemRow.UnitSnapshot,
      'UnitPriceInCents': TransactionItemRow.UnitPriceInCents,
      'Quantity': TransactionItemRow.Quantity,
      'LineTotalInCents': TransactionItemRow.LineTotalInCents,
    };
  }

  Map<String, dynamic> _MapTransactionSyncBatch(
    TransactionSyncBatche TransactionSyncBatchRow,
  ) {
    return <String, dynamic>{
      'ID': TransactionSyncBatchRow.ID,
      'BusinessDate': TransactionSyncBatchRow.BusinessDate,
      'FileName': TransactionSyncBatchRow.FileName,
      'TextFileName': TransactionSyncBatchRow.TextFileName,
      'RemoteFileID': TransactionSyncBatchRow.RemoteFileID,
      'RemoteTextFileID': TransactionSyncBatchRow.RemoteTextFileID,
      'Checksum': TransactionSyncBatchRow.Checksum,
      'TextChecksum': TransactionSyncBatchRow.TextChecksum,
      'RecordCount': TransactionSyncBatchRow.RecordCount,
      'Status': TransactionSyncBatchRow.Status,
      'AttemptCount': TransactionSyncBatchRow.AttemptCount,
      'LastAttemptAt': _FormatDateTime(TransactionSyncBatchRow.LastAttemptAt),
      'LastError': TransactionSyncBatchRow.LastError,
      'UploadedAt': _FormatDateTime(TransactionSyncBatchRow.UploadedAt),
      'CreatedAt': _FormatDateTime(TransactionSyncBatchRow.CreatedAt),
    };
  }

  Map<String, dynamic> _MapStoreSetting(StoreSetting StoreSettingRow) {
    return <String, dynamic>{
      'ID': StoreSettingRow.ID,
      'StoreName': StoreSettingRow.StoreName,
      'Address': StoreSettingRow.Address,
      'ContactNumber': StoreSettingRow.ContactNumber,
      'ReceiptFooter': StoreSettingRow.ReceiptFooter,
    };
  }

  String? _FormatDateTime(DateTime? DateTimeValue) {
    return DateTimeValue?.toUtc().toIso8601String();
  }
}
