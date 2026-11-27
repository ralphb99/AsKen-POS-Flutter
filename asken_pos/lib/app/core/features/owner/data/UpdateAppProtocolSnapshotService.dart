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
      final TransactionPrintJobRows = await Database.select(
        Database.transactionPrintJobs,
      ).get();
      final TransactionSyncBatchRows = await Database.select(
        Database.transactionSyncBatches,
      ).get();
      final EodSummaryRows = await Database.select(Database.eodSummaries).get();
      final EodSummaryItemRows = await Database.select(
        Database.eodSummaryItems,
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
        TransactionPrintJobs: TransactionPrintJobRows.map(
          _MapTransactionPrintJob,
        ).toList(growable: false),
        TransactionSyncBatches: TransactionSyncBatchRows.map(
          _MapTransactionSyncBatch,
        ).toList(growable: false),
        EodSummaries: EodSummaryRows.map(
          _MapEodSummary,
        ).toList(growable: false),
        EodSummaryItems: EodSummaryItemRows.map(
          _MapEodSummaryItem,
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

  Map<String, dynamic> _MapTransactionPrintJob(
    TransactionPrintJob TransactionPrintJobRow,
  ) {
    return <String, dynamic>{
      'ID': TransactionPrintJobRow.ID,
      'TransactionID': TransactionPrintJobRow.TransactionID,
      'Status': TransactionPrintJobRow.Status,
      'AttemptCount': TransactionPrintJobRow.AttemptCount,
      'LastAttemptAt': _FormatDateTime(TransactionPrintJobRow.LastAttemptAt),
      'PrintedAt': _FormatDateTime(TransactionPrintJobRow.PrintedAt),
      'LastError': TransactionPrintJobRow.LastError,
      'CreatedAt': _FormatDateTime(TransactionPrintJobRow.CreatedAt),
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
      'EodFileName': TransactionSyncBatchRow.EodFileName,
      'EodTextFileName': TransactionSyncBatchRow.EodTextFileName,
      'EodRemoteFileID': TransactionSyncBatchRow.EodRemoteFileID,
      'EodRemoteTextFileID': TransactionSyncBatchRow.EodRemoteTextFileID,
      'EodChecksum': TransactionSyncBatchRow.EodChecksum,
      'EodTextChecksum': TransactionSyncBatchRow.EodTextChecksum,
      'RecordCount': TransactionSyncBatchRow.RecordCount,
      'Status': TransactionSyncBatchRow.Status,
      'AttemptCount': TransactionSyncBatchRow.AttemptCount,
      'LastAttemptAt': _FormatDateTime(TransactionSyncBatchRow.LastAttemptAt),
      'LastError': TransactionSyncBatchRow.LastError,
      'UploadedAt': _FormatDateTime(TransactionSyncBatchRow.UploadedAt),
      'CreatedAt': _FormatDateTime(TransactionSyncBatchRow.CreatedAt),
    };
  }

  Map<String, dynamic> _MapEodSummary(EodSummary EodSummaryRow) {
    return <String, dynamic>{
      'ID': EodSummaryRow.ID,
      'BusinessDate': EodSummaryRow.BusinessDate,
      'TransactionCount': EodSummaryRow.TransactionCount,
      'SoldUnitCount': EodSummaryRow.SoldUnitCount,
      'TotalSalesInCents': EodSummaryRow.TotalSalesInCents,
      'CreatedAt': _FormatDateTime(EodSummaryRow.CreatedAt),
      'UpdatedAt': _FormatDateTime(EodSummaryRow.UpdatedAt),
    };
  }

  Map<String, dynamic> _MapEodSummaryItem(EodSummaryItem EodSummaryItemRow) {
    return <String, dynamic>{
      'ID': EodSummaryItemRow.ID,
      'EodSummaryID': EodSummaryItemRow.EodSummaryID,
      'ProductVariantID': EodSummaryItemRow.ProductVariantID,
      'ProductNameSnapshot': EodSummaryItemRow.ProductNameSnapshot,
      'UnitSnapshot': EodSummaryItemRow.UnitSnapshot,
      'UnitPriceInCents': EodSummaryItemRow.UnitPriceInCents,
      'SoldUnits': EodSummaryItemRow.SoldUnits,
      'SoldTotalInCents': EodSummaryItemRow.SoldTotalInCents,
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
