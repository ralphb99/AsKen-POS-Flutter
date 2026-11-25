import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/UpdateAppProtocolImportNotifier.dart';
import 'package:asken_pos/app/core/features/owner/application/UpdateAppProtocolNotifier.dart';

class UpdateAppProtocolPage extends ConsumerWidget {
  const UpdateAppProtocolPage({super.key});

  @override
  Widget build(BuildContext Context, WidgetRef Ref) {
    if (!Ref.watch(OwnerModeProvider)) {
      return const Scaffold(
        body: Center(child: Text('Owner authentication is required.')),
      );
    }

    Ref.listen(UpdateAppProtocolProvider, (Previous, Current) {
      if (!Current.hasError || !Context.mounted) {
        return;
      }

      ScaffoldMessenger.of(Context).showSnackBar(
        SnackBar(content: Text('Backup failed: ${Current.error}')),
      );
    });

    Ref.listen(UpdateAppProtocolImportProvider, (Previous, Current) {
      if (!Current.hasError || !Context.mounted) {
        return;
      }

      ScaffoldMessenger.of(Context).showSnackBar(
        SnackBar(content: Text('Backup restore failed: ${Current.error}')),
      );
    });

    final ExportState = Ref.watch(UpdateAppProtocolProvider);
    final ExportResult = ExportState.value;
    final ImportState = Ref.watch(UpdateAppProtocolImportProvider);
    final ImportSession = ImportState.value;

    return Scaffold(
      appBar: AppBar(title: const Text('App Update')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.system_update_alt_outlined, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'Export and Protect the current app data before installing a new APK.',
                    textAlign: TextAlign.center,
                    style: Theme.of(Context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The backup contains your products, variants, transactions, transaction items, sync records, and store settings. The next app version can validate this file before restoring it.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Procedure:',
                            style: Theme.of(Context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Export the backup file.\n2. Confirm it exists in the selected location.\n3. Keep it safe until the updated app confirms the import.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: ExportState.isLoading
                        ? null
                        : () async {
                            try {
                              final Result = await Ref.read(
                                UpdateAppProtocolProvider.notifier,
                              ).Export();

                              if (!Context.mounted) {
                                return;
                              }

                              if (Result == null) {
                                ScaffoldMessenger.of(Context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Backup export cancelled.'),
                                  ),
                                );
                                return;
                              }

                              ScaffoldMessenger.of(Context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Backup saved: ${Result.FileName}',
                                  ),
                                ),
                              );
                            } catch (_) {
                              // The provider state displays the detailed error.
                            }
                          },
                    icon: ExportState.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_alt_outlined),
                    label: Text(
                      ExportState.isLoading
                          ? 'Creating backup...'
                          : 'Export Backup',
                    ),
                  ),
                  if (ExportResult != null) ...[
                    const SizedBox(height: 20),
                    Card(
                      color: Theme.of(Context).colorScheme.surfaceContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last export',
                              style: Theme.of(Context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(ExportResult.FileName),
                            const SizedBox(height: 4),
                            Text(
                              '${_FormatBytes(ExportResult.FileSizeInBytes)} • ${ExportResult.Counts['Transactions'] ?? 0} transaction(s)',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SHA-256: ${ExportResult.DataChecksumSHA256}',
                              style: Theme.of(Context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restore an update backup',
                            style: Theme.of(Context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select a previously exported .askenbackup file. It will be validated before anything is written to the database.',
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: ImportState.isLoading
                                ? null
                                : () => Ref.read(
                                    UpdateAppProtocolImportProvider.notifier,
                                  ).PickAndPreview(),
                            icon: ImportState.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.folder_open_outlined),
                            label: Text(
                              ImportState.isLoading
                                  ? 'Validating backup...'
                                  : 'Select Backup File',
                            ),
                          ),
                          if (ImportSession != null) ...[
                            const Divider(height: 28),
                            Text(
                              'Backup ready for review',
                              style: Theme.of(Context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(ImportSession.Document.SourceFileName),
                            const SizedBox(height: 4),
                            Text(
                              'Created: ${ImportSession.Preview.CreatedAtUtc.toLocal()}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${ImportSession.Preview.GetIncomingRecordCount()} incoming record(s) • ${ImportSession.Preview.UnsyncedTransactionCount} unsynced transaction(s)',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${ImportSession.Preview.GetNewRecordCount()} new record(s) will be restored • ${ImportSession.Preview.GetConflictRecordCount()} existing/conflicting record(s) will be skipped',
                            ),
                            const SizedBox(height: 12),
                            if (ImportSession.Result == null)
                              FilledButton.icon(
                                onPressed:
                                    ImportState.isLoading ||
                                        ImportSession
                                                .Preview.GetNewRecordCount() ==
                                            0
                                    ? null
                                    : () async {
                                        try {
                                          await Ref.read(
                                            UpdateAppProtocolImportProvider
                                                .notifier,
                                          ).Restore();
                                        } catch (_) {
                                          // The provider state displays the detailed error.
                                        }
                                      },
                                icon: const Icon(Icons.restore_outlined),
                                label: const Text(
                                  'Restore Non-conflicting Records',
                                ),
                              )
                            else ...[
                              Text(
                                'Restore completed: ${ImportSession.Result!.GetInsertedRecordCount()} record(s) added and ${ImportSession.Result!.GetSkippedRecordCount()} skipped.',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${ImportSession.Result!.UnsyncedTransactionsRestored} unsynced transaction(s) restored.',
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Existing records are never overwritten or deleted by this restore. Password-protected encryption remains a separate checkpoint.',
                    textAlign: TextAlign.center,
                    style: Theme.of(Context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _FormatBytes(int Bytes) {
    if (Bytes < 1024) {
      return '$Bytes B';
    }

    if (Bytes < 1024 * 1024) {
      return '${(Bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(Bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
