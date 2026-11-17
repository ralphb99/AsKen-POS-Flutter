import 'package:googleapis/drive/v3.dart' as Drive;
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveFileUploadService.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncOrchestrator.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncBatchService.dart';

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

  const TransactionSyncService({
    required this.BatchService,
    required this.Orchestrator,
    required this.UploadService,
  });

  Future<TransactionSyncResult> SyncPendingBatches() async {
    final PreparedBatches = await Orchestrator.PreparePendingBatches();
    var SyncedBatchCount = 0;
    var FailedBatchCount = 0;
    String? LastError;

    for (final PreparedBatch in PreparedBatches) {
      final IsClaimed = await BatchService.ClaimBatch(
        BatchID: PreparedBatch.Batch.ID,
      );
      if (!IsClaimed) {
        continue;
      }

      try {
        final UploadedCsv = await UploadService.UploadOrUpdate(
          LocalFile: PreparedBatch.CsvFile,
          FileName: PreparedBatch.Batch.FileName,
          ContentType: 'text/csv',
          RemoteFileID: PreparedBatch.Batch.RemoteFileID,
        );
        final CsvFileID = _RequireFileID(UploadedCsv);
        await BatchService.SaveRemoteFileID(
          BatchID: PreparedBatch.Batch.ID,
          RemoteFileID: CsvFileID,
        );

        final UploadedText = await UploadService.UploadOrUpdate(
          LocalFile: PreparedBatch.TextFile,
          FileName: PreparedBatch.Batch.TextFileName!,
          ContentType: 'text/plain',
          RemoteFileID: PreparedBatch.Batch.RemoteTextFileID,
        );
        final TextFileID = _RequireFileID(UploadedText);
        await BatchService.SaveRemoteFileID(
          BatchID: PreparedBatch.Batch.ID,
          RemoteTextFileID: TextFileID,
        );

        await BatchService.MarkBatchUploaded(
          BatchID: PreparedBatch.Batch.ID,
          Checksum: PreparedBatch.CsvChecksum,
          TextChecksum: PreparedBatch.TextChecksum,
          RemoteFileID: CsvFileID,
          RemoteTextFileID: TextFileID,
        );
        SyncedBatchCount++;
      } catch (CaughtError) {
        FailedBatchCount++;
        final FailureMessage = _FormatError(CaughtError);
        LastError = FailureMessage;
        await BatchService.MarkBatchFailed(
          BatchID: PreparedBatch.Batch.ID,
          ErrorMessage: FailureMessage,
        );
      }
    }

    return TransactionSyncResult(
      SyncedBatchCount: SyncedBatchCount,
      FailedBatchCount: FailedBatchCount,
      LastError: LastError,
    );
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
