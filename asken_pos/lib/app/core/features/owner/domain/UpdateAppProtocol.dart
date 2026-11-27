class UpdateAppProtocolSnapshot {
  final List<Map<String, dynamic>> Products;
  final List<Map<String, dynamic>> ProductVariants;
  final List<Map<String, dynamic>> Transactions;
  final List<Map<String, dynamic>> TransactionItems;
  final List<Map<String, dynamic>> TransactionPrintJobs;
  final List<Map<String, dynamic>> TransactionSyncBatches;
  final List<Map<String, dynamic>> EodSummaries;
  final List<Map<String, dynamic>> EodSummaryItems;
  final List<Map<String, dynamic>> StoreSettings;

  const UpdateAppProtocolSnapshot({
    required this.Products,
    required this.ProductVariants,
    required this.Transactions,
    required this.TransactionItems,
    required this.TransactionPrintJobs,
    required this.TransactionSyncBatches,
    required this.EodSummaries,
    required this.EodSummaryItems,
    required this.StoreSettings,
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
    };
  }

  Map<String, int> GetCounts() {
    return <String, int>{
      'Products': Products.length,
      'ProductVariants': ProductVariants.length,
      'Transactions': Transactions.length,
      'TransactionItems': TransactionItems.length,
      'TransactionPrintJobs': TransactionPrintJobs.length,
      'TransactionSyncBatches': TransactionSyncBatches.length,
      'EodSummaries': EodSummaries.length,
      'EodSummaryItems': EodSummaryItems.length,
      'StoreSettings': StoreSettings.length,
    };
  }
}

class UpdateAppProtocolExportResult {
  final String FileName;
  final String SavedLocation;
  final int FileSizeInBytes;
  final String DataChecksumSHA256;
  final DateTime CreatedAtUtc;
  final Map<String, int> Counts;

  const UpdateAppProtocolExportResult({
    required this.FileName,
    required this.SavedLocation,
    required this.FileSizeInBytes,
    required this.DataChecksumSHA256,
    required this.CreatedAtUtc,
    required this.Counts,
  });
}
