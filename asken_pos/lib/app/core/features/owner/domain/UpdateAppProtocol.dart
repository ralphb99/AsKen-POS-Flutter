class UpdateAppProtocolSnapshot {
  final List<Map<String, dynamic>> Products;
  final List<Map<String, dynamic>> ProductVariants;
  final List<Map<String, dynamic>> Transactions;
  final List<Map<String, dynamic>> TransactionItems;
  final List<Map<String, dynamic>> TransactionSyncBatches;
  final List<Map<String, dynamic>> StoreSettings;

  const UpdateAppProtocolSnapshot({
    required this.Products,
    required this.ProductVariants,
    required this.Transactions,
    required this.TransactionItems,
    required this.TransactionSyncBatches,
    required this.StoreSettings,
  });

  Map<String, dynamic> ToDataPayload() {
    return <String, dynamic>{
      'Products': Products,
      'ProductVariants': ProductVariants,
      'Transactions': Transactions,
      'TransactionItems': TransactionItems,
      'TransactionSyncBatches': TransactionSyncBatches,
      'StoreSettings': StoreSettings,
    };
  }

  Map<String, int> GetCounts() {
    return <String, int>{
      'Products': Products.length,
      'ProductVariants': ProductVariants.length,
      'Transactions': Transactions.length,
      'TransactionItems': TransactionItems.length,
      'TransactionSyncBatches': TransactionSyncBatches.length,
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
