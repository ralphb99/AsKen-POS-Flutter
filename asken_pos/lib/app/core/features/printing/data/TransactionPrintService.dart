import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/printing/data/ReceiptDataService.dart';
import 'package:asken_pos/app/core/features/printing/data/ThermalPrinterService.dart';
import 'package:asken_pos/app/core/features/printing/data/TransactionPrintJobService.dart';
import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';

class TransactionPrintService {
  final TransactionPrintJobService JobService;
  final ReceiptDataService ReceiptService;
  final ThermalPrinterService PrinterService;

  const TransactionPrintService({
    required this.JobService,
    required this.ReceiptService,
    required this.PrinterService,
  });

  Future<TransactionPrintResult> PrintTransaction({
    required int TransactionID,
  }) async {
    TransactionPrintJob? Job;

    try {
      Job = await JobService.ClaimJob(TransactionID: TransactionID);
    } catch (Error) {
      return TransactionPrintResult(
        TransactionID: TransactionID,
        IsPrinted: false,
        ErrorMessage: _FormatError(Error),
      );
    }

    if (Job == null) {
      return TransactionPrintResult(
        TransactionID: TransactionID,
        IsPrinted: false,
        ErrorMessage: 'A print attempt is already in progress.',
      );
    }

    try {
      final Receipt = await ReceiptService.GetReceiptData(
        TransactionID: TransactionID,
      );
      await PrinterService.PrintReceipt(
        Receipt: Receipt,
      ).timeout(const Duration(seconds: 8));
      await JobService.MarkPrinted(JobID: Job.ID);

      return TransactionPrintResult(
        TransactionID: TransactionID,
        IsPrinted: true,
      );
    } catch (Error) {
      final ErrorMessage = _FormatError(Error);
      try {
        await JobService.MarkFailed(JobID: Job.ID, ErrorMessage: ErrorMessage);
      } catch (_) {
        // The original transaction remains safe even if print-state recovery fails.
      }

      return TransactionPrintResult(
        TransactionID: TransactionID,
        IsPrinted: false,
        ErrorMessage: ErrorMessage,
      );
    }
  }

  String _FormatError(Object Error) {
    return Error.toString().replaceFirst('Exception: ', '').trim();
  }
}
