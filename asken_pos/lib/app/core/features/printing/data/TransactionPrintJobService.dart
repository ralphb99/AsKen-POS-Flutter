import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';

class TransactionPrintJobService {
  static const Set<String> RetryableStatuses = <String>{
    'pending',
    'failed',
    'printed',
  };

  final AppDatabase Database;

  const TransactionPrintJobService({required this.Database});

  Future<void> CreatePendingJob({required int TransactionID}) async {
    final ExistingJob = await GetJob(TransactionID: TransactionID);
    if (ExistingJob != null) {
      return;
    }

    await Database.into(Database.transactionPrintJobs).insert(
      TransactionPrintJobsCompanion.insert(TransactionID: TransactionID),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<TransactionPrintJob?> GetJob({required int TransactionID}) {
    return (Database.select(Database.transactionPrintJobs)
          ..where((Job) => Job.TransactionID.equals(TransactionID)))
        .getSingleOrNull();
  }

  Stream<List<PendingPrintJob>> WatchActionableJobs() {
    final Query =
        Database.select(Database.transactionPrintJobs).join([
            innerJoin(
              Database.transactions,
              Database.transactions.ID.equalsExp(
                Database.transactionPrintJobs.TransactionID,
              ),
            ),
          ])
          ..where(
            Database.transactionPrintJobs.Status.isIn(['pending', 'failed']),
          )
          ..orderBy([
            OrderingTerm(
              expression: Database.transactionPrintJobs.CreatedAt,
              mode: OrderingMode.asc,
            ),
          ]);

    return Query.map((Row) {
      final Job = Row.readTable(Database.transactionPrintJobs);
      final TransactionData = Row.readTable(Database.transactions);

      return PendingPrintJob(
        TransactionID: Job.TransactionID,
        ReceiptNumber: TransactionData.ReceiptNumber,
        Status: Job.Status,
        AttemptCount: Job.AttemptCount,
        LastAttemptAt: Job.LastAttemptAt,
        LastError: Job.LastError,
      );
    }).watch();
  }

  Future<TransactionPrintJob?> ClaimJob({required int TransactionID}) async {
    return Database.transaction(() async {
      var Job = await GetJob(TransactionID: TransactionID);
      if (Job == null) {
        await CreatePendingJob(TransactionID: TransactionID);
        Job = await GetJob(TransactionID: TransactionID);
      }

      if (Job == null || !RetryableStatuses.contains(Job.Status)) {
        return null;
      }

      final AttemptTime = DateTime.now();
      final ClaimedRows =
          await (Database.update(Database.transactionPrintJobs)..where(
                (Candidate) =>
                    Candidate.ID.equals(Job!.ID) &
                    Candidate.Status.isIn(RetryableStatuses.toList()),
              ))
              .write(
                TransactionPrintJobsCompanion(
                  Status: const Value('printing'),
                  LastAttemptAt: Value(AttemptTime),
                  LastError: const Value(null),
                ),
              );

      if (ClaimedRows == 0) {
        return null;
      }

      await (Database.update(
        Database.transactionPrintJobs,
      )..where((Candidate) => Candidate.ID.equals(Job!.ID))).write(
        TransactionPrintJobsCompanion.custom(
          AttemptCount:
              Database.transactionPrintJobs.AttemptCount + const Constant(1),
        ),
      );

      return GetJob(TransactionID: TransactionID);
    });
  }

  Future<void> MarkPrinted({required int JobID, DateTime? PrintedAt}) async {
    final PrintedTime = PrintedAt ?? DateTime.now();

    await (Database.update(
      Database.transactionPrintJobs,
    )..where((Job) => Job.ID.equals(JobID))).write(
      TransactionPrintJobsCompanion(
        Status: const Value('printed'),
        PrintedAt: Value(PrintedTime),
        LastError: const Value(null),
      ),
    );
  }

  Future<void> MarkFailed({
    required int JobID,
    required String ErrorMessage,
    DateTime? AttemptedAt,
  }) async {
    await (Database.update(
      Database.transactionPrintJobs,
    )..where((Job) => Job.ID.equals(JobID))).write(
      TransactionPrintJobsCompanion(
        Status: const Value('failed'),
        LastAttemptAt: Value(AttemptedAt ?? DateTime.now()),
        LastError: Value(ErrorMessage),
      ),
    );
  }

  Future<void> RecoverInterruptedJobs() async {
    await (Database.update(
      Database.transactionPrintJobs,
    )..where((Job) => Job.Status.equals('printing'))).write(
      const TransactionPrintJobsCompanion(
        Status: Value('failed'),
        LastError: Value('Printing was interrupted before completion.'),
      ),
    );
  }
}
