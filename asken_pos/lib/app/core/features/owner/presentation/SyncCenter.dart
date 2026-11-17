import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/TransactionSyncNotifier.dart';

class SyncCenterPage extends ConsumerWidget {
  const SyncCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(OwnerModeProvider)) {
      return const Scaffold(
        body: Center(child: Text('Owner authentication is required.')),
      );
    }

    final Batches = ref.watch(TransactionSyncBatchesProvider);
    final SyncState = ref.watch(TransactionSyncProvider);
    final IsSyncing = SyncState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Sync Center')),
      body: Batches.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Error, StackTrace) => Center(
          child: Text('Unable to load sync batches: $Error'),
        ),
        data: (Rows) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(TransactionSyncBatchesProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SummaryCard(Rows: Rows),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: IsSyncing
                    ? null
                    : () => ref
                          .read(TransactionSyncProvider.notifier)
                          .SyncNow(),
                icon: const Icon(Icons.sync),
                label: Text(IsSyncing ? 'Syncing...' : 'Sync All Pending'),
              ),
              const SizedBox(height: 20),
              if (Rows.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No transaction sync batches yet.'),
                  ),
                )
              else
                ...Rows.map(
                  (Batch) => _SyncBatchTile(
                    Batch: Batch,
                    IsSyncing: IsSyncing,
                    OnRetry: () => ref
                        .read(TransactionSyncProvider.notifier)
                        .SyncBatch(Batch.ID),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<TransactionSyncBatche> Rows;

  const _SummaryCard({required this.Rows});

  @override
  Widget build(BuildContext context) {
    final PendingCount = Rows.where(
      (Batch) => Batch.Status == 'pending',
    ).length;
    final FailedCount = Rows.where((Batch) => Batch.Status == 'failed').length;
    final SyncedCount = Rows.where((Batch) => Batch.Status == 'synced').length;
    final UploadingCount = Rows.where(
      (Batch) => Batch.Status == 'uploading',
    ).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _SummaryValue(Label: 'Pending', Value: PendingCount),
            _SummaryValue(Label: 'Uploading', Value: UploadingCount),
            _SummaryValue(Label: 'Failed', Value: FailedCount),
            _SummaryValue(Label: 'Synced', Value: SyncedCount),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String Label;
  final int Value;

  const _SummaryValue({required this.Label, required this.Value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Label, style: Theme.of(context).textTheme.labelMedium),
        Text(
          '$Value',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _SyncBatchTile extends StatelessWidget {
  final TransactionSyncBatche Batch;
  final bool IsSyncing;
  final VoidCallback OnRetry;

  const _SyncBatchTile({
    required this.Batch,
    required this.IsSyncing,
    required this.OnRetry,
  });

  @override
  Widget build(BuildContext context) {
    final Status = Batch.Status.toLowerCase();
    final StatusColor = _StatusColor(context, Status);
    final CanRetry = !IsSyncing && (Status == 'pending' || Status == 'failed');
    final LastAttempt = Batch.LastAttemptAt;

    return Card(
      child: ListTile(
        leading: Icon(_StatusIcon(Status), color: StatusColor),
        title: Text(Batch.BusinessDate),
        subtitle: Text(
          '${Batch.FileName} / ${Batch.TextFileName ?? 'TXT unavailable'}\n'
          'Attempts: ${Batch.AttemptCount}'
          '${LastAttempt == null ? '' : '\nLast attempt: ${DateFormat('MMM d, yyyy h:mm a').format(LastAttempt)}'}'
          '${Batch.LastError == null ? '' : '\nError: ${Batch.LastError}'}',
        ),
        isThreeLine: true,
        trailing: CanRetry
            ? IconButton(
                tooltip: 'Retry this batch',
                onPressed: OnRetry,
                icon: const Icon(Icons.refresh),
              )
            : Text(
                Status.toUpperCase(),
                style: TextStyle(
                  color: StatusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  IconData _StatusIcon(String Status) {
    switch (Status) {
      case 'synced':
        return Icons.cloud_done_outlined;
      case 'uploading':
        return Icons.cloud_upload_outlined;
      case 'failed':
        return Icons.error_outline;
      default:
        return Icons.cloud_queue_outlined;
    }
  }

  Color _StatusColor(BuildContext context, String Status) {
    switch (Status) {
      case 'synced':
        return Colors.green;
      case 'failed':
        return Theme.of(context).colorScheme.error;
      case 'uploading':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
