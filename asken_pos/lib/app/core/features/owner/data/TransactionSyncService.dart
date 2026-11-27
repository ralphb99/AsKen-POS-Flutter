import 'package:googleapis/drive/v3.dart' as Drive;
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveFileUploadService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncOrchestrator.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncBatchService.dart';
import 'package:asken_pos/app/core/features/owner/data/CloudSyncSettingsService.dart';

class TransactionSyncResult {
  final int SyncedBatchCount;
  final int FailedBatchCount;
  final String? LastError;

  const TransactionSyncResult({
    required this.SyncedBatchCount,
    required this.FailedBatchCount,
    this.LastError,
  });

  bool get HasFailures => FailedBatchCount > 0;

  bool get HasPendingWork => SyncedBatchCount > 0 || HasFailures;
}

class TransactionSyncService {
  final TransactionSyncBatchService BatchService;
  final TransactionSyncOrchestrator Orchestrator;
  final GoogleDriveFileUploadService UploadService;
  final CloudSyncSettingsService CloudSettingsService;

  const TransactionSyncService({
    required this.BatchService,
    required this.Orchestrator,
    required this.UploadService,
    required this.CloudSettingsService,
  });

  Future<TransactionSyncResult> SyncPendingBatches() async {
    final PreparedBatches = await Orchestrator.PreparePendingBatches();
    var SyncedBatchCount = 0;
    var FailedBatchCount = 0;
    String? LastError;

    for (final PreparedBatch in PreparedBatches) {
      final BatchResult = await _SyncPreparedBatch(PreparedBatch);
      if (BatchResult.HasFailures) {
        FailedBatchCount++;
        LastError = BatchResult.LastError;
      } else if (BatchResult.SyncedBatchCount > 0) {
        SyncedBatchCount++;
      }
    }

    return TransactionSyncResult(
      SyncedBatchCount: SyncedBatchCount,
      FailedBatchCount: FailedBatchCount,
      LastError: LastError,
    );
  }

  Future<TransactionSyncResult> SyncBatch({required int BatchID}) async {
    final PreparedBatch = await Orchestrator.PrepareBatchByID(BatchID: BatchID);
    if (PreparedBatch == null) {
      return const TransactionSyncResult(
        SyncedBatchCount: 0,
        FailedBatchCount: 0,
      );
    }

    return _SyncPreparedBatch(PreparedBatch);
  }

  Future<TransactionSyncResult> _SyncPreparedBatch(
    PreparedTransactionBatch PreparedBatch,
  ) async {
    final IsClaimed = await BatchService.ClaimBatch(
      BatchID: PreparedBatch.Batch.ID,
    );
    if (!IsClaimed) {
      return const TransactionSyncResult(
        SyncedBatchCount: 0,
        FailedBatchCount: 0,
      );
    }

    try {
      final CloudSettings = await CloudSettingsService.GetSettings();
      final TransactionLogsFolderID =
          PreparedBatch.Batch.TransactionLogsFolderID ??
          CloudSettings.TransactionLogsFolderID;
      final EodLogsFolderID =
          PreparedBatch.Batch.EodLogsFolderID ?? CloudSettings.EodLogsFolderID;

      final UploadedCsv = await UploadService.UploadOrUpdate(
        LocalFile: PreparedBatch.CsvFile,
        FileName: PreparedBatch.Batch.FileName,
        ContentType: 'text/csv',
        ParentFolderID: TransactionLogsFolderID,
        RemoteFileID: PreparedBatch.Batch.RemoteFileID,
      );
      final CsvFileID = _RequireFileID(UploadedCsv);
      await BatchService.SaveRemoteFileID(
        BatchID: PreparedBatch.Batch.ID,
        RemoteFileID: CsvFileID,
      );

      final TextFileName = PreparedBatch.Batch.TextFileName;
      if (TextFileName == null || TextFileName.isEmpty) {
        throw StateError('The selected sync batch has no TXT file name.');
      }

      final UploadedText = await UploadService.UploadOrUpdate(
        LocalFile: PreparedBatch.TextFile,
        FileName: TextFileName,
        ContentType: 'text/plain',
        ParentFolderID: TransactionLogsFolderID,
        RemoteFileID: PreparedBatch.Batch.RemoteTextFileID,
      );
      final TextFileID = _RequireFileID(UploadedText);
      await BatchService.SaveRemoteFileID(
        BatchID: PreparedBatch.Batch.ID,
        RemoteTextFileID: TextFileID,
      );

      final EodFileName = PreparedBatch.Batch.EodFileName;
      final EodTextFileName = PreparedBatch.Batch.EodTextFileName;
      if (EodFileName == null || EodFileName.isEmpty) {
        throw StateError('The selected sync batch has no EOD CSV file name.');
      }
      if (EodTextFileName == null || EodTextFileName.isEmpty) {
        throw StateError('The selected sync batch has no EOD TXT file name.');
      }

      final UploadedEod = await UploadService.UploadOrUpdate(
        LocalFile: PreparedBatch.EodCsvFile,
        FileName: EodFileName,
        ContentType: 'text/csv',
        ParentFolderID: EodLogsFolderID,
        RemoteFileID: PreparedBatch.Batch.EodRemoteFileID,
      );
      final EodFileID = _RequireFileID(UploadedEod);
      await BatchService.SaveRemoteFileID(
        BatchID: PreparedBatch.Batch.ID,
        EodRemoteFileID: EodFileID,
      );

      final UploadedEodText = await UploadService.UploadOrUpdate(
        LocalFile: PreparedBatch.EodTextFile,
        FileName: EodTextFileName,
        ContentType: 'text/plain',
        ParentFolderID: EodLogsFolderID,
        RemoteFileID: PreparedBatch.Batch.EodRemoteTextFileID,
      );
      final EodTextFileID = _RequireFileID(UploadedEodText);
      await BatchService.SaveRemoteFileID(
        BatchID: PreparedBatch.Batch.ID,
        EodRemoteTextFileID: EodTextFileID,
      );

      await BatchService.MarkBatchUploaded(
        BatchID: PreparedBatch.Batch.ID,
        Checksum: PreparedBatch.CsvChecksum,
        TextChecksum: PreparedBatch.TextChecksum,
        EodChecksum: PreparedBatch.EodChecksum,
        EodTextChecksum: PreparedBatch.EodTextChecksum,
        RemoteFileID: CsvFileID,
        RemoteTextFileID: TextFileID,
        EodRemoteFileID: EodFileID,
        EodRemoteTextFileID: EodTextFileID,
      );

      return const TransactionSyncResult(
        SyncedBatchCount: 1,
        FailedBatchCount: 0,
      );
    } catch (CaughtError) {
      final FailureMessage = _FormatError(CaughtError);
      await BatchService.MarkBatchFailed(
        BatchID: PreparedBatch.Batch.ID,
        ErrorMessage: FailureMessage,
      );

      return TransactionSyncResult(
        SyncedBatchCount: 0,
        FailedBatchCount: 1,
        LastError: FailureMessage,
      );
    }
  }

  String _RequireFileID(Drive.File UploadedFile) {
    final String? FileID = UploadedFile.id;
    if (FileID == null || FileID.isEmpty) {
      throw StateError('Google Drive returned an uploaded file without an ID.');
    }

    return FileID;
  }

  String _FormatError(Object Error) {
    return Error.toString().replaceFirst('Exception: ', '').trim();
  }
}
