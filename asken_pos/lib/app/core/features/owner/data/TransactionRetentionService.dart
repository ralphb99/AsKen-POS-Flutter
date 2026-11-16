import 'package:drift/drift.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

class TransactionRetentionService {
  final AppDatabase Database;

  const TransactionRetentionService({required this.Database});

  /// Deletes only transactions confirmed as uploaded and older than the
  /// retention period. Batch metadata is retained for troubleshooting.
  Future<int> DeleteSyncedTransactionsOlderThan({
    Duration RetentionPeriod = const Duration(days: 30),
    DateTime? Now,
  }) async {
    if (RetentionPeriod.isNegative) {
      throw ArgumentError.value(
        RetentionPeriod,
        'RetentionPeriod',
        'must not be negative',
      );
    }

    final Cutoff = (Now ?? DateTime.now()).subtract(RetentionPeriod);
    final ExpiredTransactions =
        await (Database.select(Database.transactions)..where(
              (Transaction) =>
                  Transaction.SyncStatus.equals('synced') &
                  Transaction.SyncedAt.isNotNull() &
                  Transaction.SyncedAt.isSmallerThanValue(Cutoff),
            ))
            .get();

    if (ExpiredTransactions.isEmpty) {
      return 0;
    }

    final TransactionIDs = ExpiredTransactions.map(
      (Transaction) => Transaction.ID,
    ).toList(growable: false);

    await Database.transaction(() async {
      await (Database.delete(
        Database.transactionItems,
      )..where((Item) => Item.TransactionID.isIn(TransactionIDs))).go();

      await (Database.delete(
        Database.transactions,
      )..where((Transaction) => Transaction.ID.isIn(TransactionIDs))).go();
    });

    return TransactionIDs.length;
  }
}
