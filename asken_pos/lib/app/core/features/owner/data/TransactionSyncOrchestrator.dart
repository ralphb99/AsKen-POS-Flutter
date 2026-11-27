import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionRecordsService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncBatchService.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryExportService.dart';
import 'package:asken_pos/app/core/features/owner/data/EodSummaryService.dart';
import 'package:asken_pos/app/core/features/owner/data/CloudSyncSettingsService.dart';

class PreparedTransactionBatch {
  final TransactionSyncBatche Batch;
  final List<TransactionRecord> Records;
  final File CsvFile;
  final File TextFile;
  final File EodCsvFile;
  final File EodTextFile;
  final String CsvChecksum;
  final String TextChecksum;
  final String EodChecksum;
  final String EodTextChecksum;

  const PreparedTransactionBatch({
    required this.Batch,
    required this.Records,
    required this.CsvFile,
    required this.TextFile,
    required this.EodCsvFile,
    required this.EodTextFile,
    required this.CsvChecksum,
    required this.TextChecksum,
    required this.EodChecksum,
    required this.EodTextChecksum,
  });
}

class TransactionSyncOrchestrator {
  final TransactionSyncBatchService BatchService;
  final TransactionRecordsService RecordsService;
  final TransactionExportService ExportService;
  final EodSummaryService EodService;
  final EodSummaryExportService EodExportService;
  final CloudSyncSettingsService CloudSettingsService;

  const TransactionSyncOrchestrator({
    required this.BatchService,
    required this.RecordsService,
    required this.ExportService,
    required this.EodService,
    required this.EodExportService,
    required this.CloudSettingsService,
  });

  Future<List<PreparedTransactionBatch>> PreparePendingBatches() async {
    final BusinessDates =
        await BatchService.GetBusinessDatesWithUnsyncedTransactions();
    final PreparedBatches = <PreparedTransactionBatch>[];

    for (final BusinessDate in BusinessDates) {
      final PreparedBatch = await PrepareDailyBatch(BusinessDate: BusinessDate);
      if (PreparedBatch != null) {
        PreparedBatches.add(PreparedBatch);
      }
    }

    return PreparedBatches;
  }

  Future<PreparedTransactionBatch?> PrepareDailyBatch({
    required DateTime BusinessDate,
  }) async {
    final StartOfDay = DateTime(
      BusinessDate.year,
      BusinessDate.month,
      BusinessDate.day,
    );
    final EndOfDay = StartOfDay.add(const Duration(days: 1));
    final Records = await RecordsService.GetTransactions(
      From: StartOfDay,
      To: EndOfDay,
    );

    if (Records.isEmpty) {
      return null;
    }

    TransactionSyncBatche? Batch;

    try {
      final CloudSettings = await CloudSettingsService.GetSettings();
      Batch = await BatchService.GetOrCreateDailyBatch(
        BusinessDate: StartOfDay,
        TransactionLogsFolderID: CloudSettings.TransactionLogsFolderID,
        EodLogsFolderID: CloudSettings.EodLogsFolderID,
      );
      final EodDetails = await EodService.GetDetails(
        BusinessDate: Batch.BusinessDate,
      );
      if (EodDetails == null) {
        throw StateError(
          'The EOD summary for ${Batch.BusinessDate} could not be loaded.',
        );
      }

      final CsvFile = await ExportService.SaveCsv(
        Records: Records,
        FileName: Batch.FileName,
      );
      final TextFileName = Batch.TextFileName ?? _TextFileName(Batch.FileName);
      final TextFile = await ExportService.SaveText(
        Records: Records,
        FileName: TextFileName,
      );
      final EodFileName = Batch.EodFileName ?? 'Eod_${Batch.BusinessDate}.csv';
      final EodTextFileName =
          Batch.EodTextFileName ?? 'Eod_${Batch.BusinessDate}.txt';
      final EodCsvFile = await EodExportService.SaveCsv(
        Details: EodDetails,
        FileName: EodFileName,
      );
      final EodTextFile = await EodExportService.SaveText(
        Details: EodDetails,
        FileName: EodTextFileName,
      );
      final CsvChecksum = await _Checksum(CsvFile);
      final TextChecksum = await _Checksum(TextFile);
      final EodChecksum = await _Checksum(EodCsvFile);
      final EodTextChecksum = await _Checksum(EodTextFile);

      await BatchService.MarkBatchPrepared(
        BatchID: Batch.ID,
        LocalFilePath: CsvFile.path,
        TextFileName: TextFileName,
        TextLocalFilePath: TextFile.path,
        Checksum: CsvChecksum,
        TextChecksum: TextChecksum,
        EodFileName: EodFileName,
        EodLocalFilePath: EodCsvFile.path,
        EodTextFileName: EodTextFileName,
        EodTextLocalFilePath: EodTextFile.path,
        EodChecksum: EodChecksum,
        EodTextChecksum: EodTextChecksum,
        RecordCount: Records.length,
      );

      final PreparedBatch = await BatchService.GetBatch(BatchID: Batch.ID);
      if (PreparedBatch == null) {
        throw StateError(
          'The prepared transaction batch could not be reloaded.',
        );
      }

      return PreparedTransactionBatch(
        Batch: PreparedBatch,
        Records: Records,
        CsvFile: CsvFile,
        TextFile: TextFile,
        EodCsvFile: EodCsvFile,
        EodTextFile: EodTextFile,
        CsvChecksum: CsvChecksum,
        TextChecksum: TextChecksum,
        EodChecksum: EodChecksum,
        EodTextChecksum: EodTextChecksum,
      );
    } catch (CaughtError, StackTrace) {
      if (Batch != null) {
        await BatchService.MarkBatchFailed(
          BatchID: Batch.ID,
          ErrorMessage: CaughtError.toString(),
        );
      }
      Error.throwWithStackTrace(CaughtError, StackTrace);
    }
  }

  Future<PreparedTransactionBatch?> PrepareBatchByID({
    required int BatchID,
  }) async {
    final Batch = await BatchService.GetBatch(BatchID: BatchID);
    if (Batch == null) {
      throw StateError('The selected sync batch no longer exists.');
    }

    final BusinessDate = DateTime.tryParse(Batch.BusinessDate);
    if (BusinessDate == null) {
      throw StateError('The selected sync batch has an invalid business date.');
    }

    return PrepareDailyBatch(BusinessDate: BusinessDate);
  }

  Future<String> _Checksum(File FileData) async {
    final Bytes = await FileData.readAsBytes();
    return sha256.convert(Bytes).toString();
  }

  String _TextFileName(String CsvFileName) {
    if (CsvFileName.toLowerCase().endsWith('.csv')) {
      return '${CsvFileName.substring(0, CsvFileName.length - 4)}.txt';
    }
    return '$CsvFileName.txt';
  }
}
