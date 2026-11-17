import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class TransactionSyncBatchService {
  final AppDatabase Database;

  const TransactionSyncBatchService({required this.Database});

  Future<TransactionSyncBatche> GetOrCreateDailyBatch({
    required DateTime BusinessDate,
  }) async {
    final StartOfDay = _StartOfDay(BusinessDate);
    final EndOfDay = StartOfDay.add(const Duration(days: 1));
    final BusinessDateKey = _BusinessDateKey(StartOfDay);
    final FileName = 'Transactions_$BusinessDateKey.csv';

    return Database.transaction(() async {
      var Batch =
          await (Database.select(Database.transactionSyncBatches)..where(
                (Candidate) => Candidate.BusinessDate.equals(BusinessDateKey),
              ))
              .getSingleOrNull();

      if (Batch == null) {
        final BatchID = await Database.into(Database.transactionSyncBatches)
            .insert(
              TransactionSyncBatchesCompanion.insert(
                BusinessDate: BusinessDateKey,
                FileName: FileName,
                TextFileName: Value('Transactions_$BusinessDateKey.txt'),
              ),
            );

        Batch = await (Database.select(
          Database.transactionSyncBatches,
        )..where((Candidate) => Candidate.ID.equals(BatchID))).getSingle();
      }

      final AssignedTransactions =
          await (Database.update(Database.transactions)..where((Transaction) {
                return Transaction.CreatedAt.isBiggerOrEqualValue(StartOfDay) &
                    Transaction.CreatedAt.isSmallerThanValue(EndOfDay) &
                    Transaction.SyncStatus.equals('synced').not();
              }))
              .write(
                TransactionsCompanion(
                  SyncBatchID: Value(Batch.ID.toString()),
                  SyncStatus: const Value('pending'),
                  LastSyncError: const Value(null),
                ),
              );

      if (AssignedTransactions > 0 && Batch.Status == 'synced') {
        await (Database.update(
          Database.transactionSyncBatches,
        )..where((Candidate) => Candidate.ID.equals(Batch!.ID))).write(
          const TransactionSyncBatchesCompanion(
            Status: Value('pending'),
            LastError: Value(null),
          ),
        );
      }

      return (await (Database.select(
        Database.transactionSyncBatches,
      )..where((Candidate) => Candidate.ID.equals(Batch!.ID))).getSingle());
    });
  }

  Future<TransactionSyncBatche?> GetBatch({required int BatchID}) {
    return (Database.select(
      Database.transactionSyncBatches,
    )..where((Batch) => Batch.ID.equals(BatchID))).getSingleOrNull();
  }

  Future<void> MarkBatchPrepared({
    required int BatchID,
    required String LocalFilePath,
    required String TextFileName,
    required String TextLocalFilePath,
    required String Checksum,
    required String TextChecksum,
    required int RecordCount,
  }) async {
    await (Database.update(
      Database.transactionSyncBatches,
    )..where((Batch) => Batch.ID.equals(BatchID))).write(
      TransactionSyncBatchesCompanion(
        LocalFilePath: Value(LocalFilePath),
        TextFileName: Value(TextFileName),
        TextLocalFilePath: Value(TextLocalFilePath),
        Checksum: Value(Checksum),
        TextChecksum: Value(TextChecksum),
        RecordCount: Value(RecordCount),
      ),
    );
  }

  Future<List<TransactionSyncBatche>> GetPendingBatches() {
    return (Database.select(Database.transactionSyncBatches)
          ..where((Batch) => Batch.Status.isIn(['pending', 'failed']))
          ..orderBy([(Batch) => OrderingTerm(expression: Batch.BusinessDate)]))
        .get();
  }

  Stream<List<TransactionSyncBatche>> WatchRecentBatches({int Limit = 30}) {
    return (Database.select(Database.transactionSyncBatches)
          ..orderBy([
            (Batch) => OrderingTerm(
              expression: Batch.BusinessDate,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(Limit))
        .watch();
  }

  Future<List<DateTime>> GetBusinessDatesWithUnsyncedTransactions() async {
    final UnsyncedTransactions =
        await (Database.select(Database.transactions)..where(
              (Transaction) => Transaction.SyncStatus.equals('synced').not(),
            ))
            .get();
    final BusinessDateKeys = <String>{};

    for (final Transaction in UnsyncedTransactions) {
      BusinessDateKeys.add(
        _BusinessDateKey(_StartOfDay(Transaction.CreatedAt)),
      );
    }

    final BusinessDates = BusinessDateKeys.map(
      _ParseBusinessDateKey,
    ).toList(growable: false);
    BusinessDates.sort();
    return BusinessDates;
  }

  Future<void> RecoverInterruptedBatches() async {
    const ErrorMessage = 'Upload interrupted before completion.';

    await Database.transaction(() async {
      await (Database.update(
        Database.transactionSyncBatches,
      )..where((Batch) => Batch.Status.equals('uploading'))).write(
        const TransactionSyncBatchesCompanion(
          Status: Value('failed'),
          LastError: Value(ErrorMessage),
        ),
      );

      await (Database.update(
            Database.transactions,
          )..where((Transaction) => Transaction.SyncStatus.equals('uploading')))
          .write(
            const TransactionsCompanion(
              SyncStatus: Value('failed'),
              LastSyncError: Value(ErrorMessage),
            ),
          );
    });
  }

  Future<bool> ClaimBatch({required int BatchID, DateTime? AttemptedAt}) async {
    final AttemptTime = AttemptedAt ?? DateTime.now();
    final UpdatedRows =
        await (Database.update(Database.transactionSyncBatches)..where(
              (Batch) =>
                  Batch.ID.equals(BatchID) &
                  Batch.Status.isIn(['pending', 'failed']),
            ))
            .write(
              TransactionSyncBatchesCompanion(
                Status: const Value('uploading'),
                AttemptCount: const Value.absent(),
                LastAttemptAt: Value(AttemptTime),
                LastError: const Value(null),
              ),
            );

    if (UpdatedRows == 0) {
      return false;
    }

    await (Database.update(
      Database.transactionSyncBatches,
    )..where((Batch) => Batch.ID.equals(BatchID))).write(
      TransactionSyncBatchesCompanion.custom(
        AttemptCount:
            Database.transactionSyncBatches.AttemptCount + const Constant(1),
      ),
    );

    await (Database.update(Database.transactions)..where(
          (Transaction) => Transaction.SyncBatchID.equals(BatchID.toString()),
        ))
        .write(
          TransactionsCompanion(
            SyncStatus: const Value('uploading'),
            LastSyncAttemptAt: Value(AttemptTime),
            LastSyncError: const Value(null),
          ),
        );

    return true;
  }

  Future<void> MarkBatchUploaded({
    required int BatchID,
    required String Checksum,
    String? TextChecksum,
    String? RemoteFileID,
    String? RemoteTextFileID,
    DateTime? UploadedAt,
  }) async {
    final UploadTime = UploadedAt ?? DateTime.now();

    await Database.transaction(() async {
      await (Database.update(
        Database.transactionSyncBatches,
      )..where((Batch) => Batch.ID.equals(BatchID))).write(
        TransactionSyncBatchesCompanion(
          Status: const Value('synced'),
          Checksum: Value(Checksum),
          TextChecksum: TextChecksum == null
              ? const Value.absent()
              : Value(TextChecksum),
          RemoteFileID: RemoteFileID == null
              ? const Value.absent()
              : Value(RemoteFileID),
          RemoteTextFileID: RemoteTextFileID == null
              ? const Value.absent()
              : Value(RemoteTextFileID),
          UploadedAt: Value(UploadTime),
          LastError: const Value(null),
        ),
      );

      await (Database.update(Database.transactions)..where(
            (Transaction) => Transaction.SyncBatchID.equals(BatchID.toString()),
          ))
          .write(
            TransactionsCompanion(
              SyncStatus: const Value('synced'),
              SyncedAt: Value(UploadTime),
              LastSyncAttemptAt: Value(UploadTime),
              LastSyncError: const Value(null),
            ),
          );
    });
  }

  Future<void> SaveRemoteFileID({
    required int BatchID,
    String? RemoteFileID,
    String? RemoteTextFileID,
  }) async {
    await (Database.update(
      Database.transactionSyncBatches,
    )..where((Batch) => Batch.ID.equals(BatchID))).write(
      TransactionSyncBatchesCompanion(
        RemoteFileID: RemoteFileID == null
            ? const Value.absent()
            : Value(RemoteFileID),
        RemoteTextFileID: RemoteTextFileID == null
            ? const Value.absent()
            : Value(RemoteTextFileID),
      ),
    );
  }

  Future<void> MarkBatchFailed({
    required int BatchID,
    required String ErrorMessage,
    DateTime? AttemptedAt,
  }) async {
    final FailureTime = AttemptedAt ?? DateTime.now();

    await Database.transaction(() async {
      await (Database.update(
        Database.transactionSyncBatches,
      )..where((Batch) => Batch.ID.equals(BatchID))).write(
        TransactionSyncBatchesCompanion(
          Status: const Value('failed'),
          LastAttemptAt: Value(FailureTime),
          LastError: Value(ErrorMessage),
        ),
      );

      await (Database.update(Database.transactions)..where(
            (Transaction) => Transaction.SyncBatchID.equals(BatchID.toString()),
          ))
          .write(
            TransactionsCompanion(
              SyncStatus: const Value('failed'),
              LastSyncAttemptAt: Value(FailureTime),
              LastSyncError: Value(ErrorMessage),
            ),
          );
    });
  }

  DateTime _StartOfDay(DateTime Date) =>
      DateTime(Date.year, Date.month, Date.day);

  String _BusinessDateKey(DateTime Date) {
    final Year = Date.year.toString().padLeft(4, '0');
    final Month = Date.month.toString().padLeft(2, '0');
    final Day = Date.day.toString().padLeft(2, '0');
    return '$Year-$Month-$Day';
  }

  DateTime _ParseBusinessDateKey(String BusinessDateKey) {
    final Parts = BusinessDateKey.split('-');
    return DateTime(
      int.parse(Parts[0]),
      int.parse(Parts[1]),
      int.parse(Parts[2]),
    );
  }
}
