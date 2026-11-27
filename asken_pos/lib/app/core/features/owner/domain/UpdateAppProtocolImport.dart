class UpdateAppProtocolImportDocument {
  final String SourceFileName;
  final int ProtocolVersion;
  final int DatabaseSchemaVersion;
  final DateTime CreatedAtUtc;
  final String DataChecksumSHA256;
  final Map<String, int> Counts;
  final List<Map<String, dynamic>> Products;
  final List<Map<String, dynamic>> ProductVariants;
  final List<Map<String, dynamic>> Transactions;
  final List<Map<String, dynamic>> TransactionItems;
  final List<Map<String, dynamic>> TransactionPrintJobs;
  final List<Map<String, dynamic>> TransactionSyncBatches;
  final List<Map<String, dynamic>> EodSummaries;
  final List<Map<String, dynamic>> EodSummaryItems;
  final List<Map<String, dynamic>> StoreSettings;
  final List<Map<String, dynamic>> CloudSyncSettings;

  const UpdateAppProtocolImportDocument({
    required this.SourceFileName,
    required this.ProtocolVersion,
    required this.DatabaseSchemaVersion,
    required this.CreatedAtUtc,
    required this.DataChecksumSHA256,
    required this.Counts,
    required this.Products,
    required this.ProductVariants,
    required this.Transactions,
    required this.TransactionItems,
    required this.TransactionPrintJobs,
    required this.TransactionSyncBatches,
    required this.EodSummaries,
    required this.EodSummaryItems,
    required this.StoreSettings,
    required this.CloudSyncSettings,
  });

  Map<String, dynamic> ToDataPayload() {
    return <String, dynamic>{
      'Products': Products,
      'ProductVariants': ProductVariants,
      'Transactions': Transactions,
      'TransactionItems': TransactionItems,
      'TransactionPrintJobs': TransactionPrintJobs,
      'TransactionSyncBatches': TransactionSyncBatches,
      'EodSummaries': EodSummaries,
      'EodSummaryItems': EodSummaryItems,
      'StoreSettings': StoreSettings,
      'CloudSyncSettings': CloudSyncSettings,
    };
  }

  int GetUnsyncedTransactionCount() {
    return Transactions.where(
      (Transaction) => Transaction['SyncStatus'] != 'synced',
    ).length;
  }
}

class UpdateAppProtocolImportPreview {
  final String SourceFileName;
  final DateTime CreatedAtUtc;
  final Map<String, int> IncomingCounts;
  final Map<String, int> ConflictCounts;
  final int UnsyncedTransactionCount;

  const UpdateAppProtocolImportPreview({
    required this.SourceFileName,
    required this.CreatedAtUtc,
    required this.IncomingCounts,
    required this.ConflictCounts,
    required this.UnsyncedTransactionCount,
  });

  int GetIncomingRecordCount() {
    return IncomingCounts.values.fold(0, (Total, Count) => Total + Count);
  }

  int GetConflictRecordCount() {
    return ConflictCounts.values.fold(0, (Total, Count) => Total + Count);
  }

  int GetNewRecordCount() {
    return GetIncomingRecordCount() - GetConflictRecordCount();
  }
}

class UpdateAppProtocolImportSession {
  final UpdateAppProtocolImportDocument Document;
  final UpdateAppProtocolImportPreview Preview;
  final UpdateAppProtocolImportResult? Result;

  const UpdateAppProtocolImportSession({
    required this.Document,
    required this.Preview,
    this.Result,
  });

  UpdateAppProtocolImportSession WithResult(
    UpdateAppProtocolImportResult ImportResult,
  ) {
    return UpdateAppProtocolImportSession(
      Document: Document,
      Preview: Preview,
      Result: ImportResult,
    );
  }
}

class UpdateAppProtocolImportResult {
  final Map<String, int> InsertedCounts;
  final Map<String, int> SkippedCounts;
  final int UnsyncedTransactionsRestored;

  const UpdateAppProtocolImportResult({
    required this.InsertedCounts,
    required this.SkippedCounts,
    required this.UnsyncedTransactionsRestored,
  });

  int GetInsertedRecordCount() {
    return InsertedCounts.values.fold(0, (Total, Count) => Total + Count);
  }

  int GetSkippedRecordCount() {
    return SkippedCounts.values.fold(0, (Total, Count) => Total + Count);
  }
}
