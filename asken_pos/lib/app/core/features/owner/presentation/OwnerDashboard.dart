import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/OwnerAccess.dart';
import 'package:asken_pos/app/core/features/owner/application/GoogleDriveConnectionNotifier.dart';
import 'package:asken_pos/app/core/features/owner/application/TransactionSyncNotifier.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionSyncService.dart';
import 'package:asken_pos/app/core/features/owner/data/GoogleDriveService.dart';
import 'package:asken_pos/app/core/features/owner/presentation/OwnerSettings.dart';
import 'package:asken_pos/app/core/features/owner/presentation/ProductManagement.dart';
import 'package:asken_pos/app/core/features/owner/presentation/TransactionRecords.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

class OwnerDashboardPage extends ConsumerWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(OwnerModeProvider)) {
      return const Scaffold(
        body: Center(child: Text('Owner authentication is required.')),
      );
    }

    ref.listen(GoogleDriveConnectionProvider, (Previous, Current) {
      if (!Current.hasError || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Current.error.toString())),
      );
    });

    ref.listen(TransactionSyncProvider, (Previous, Current) {
      if (!context.mounted) {
        return;
      }

      if (Current.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Sync failed. Check your connection and try again.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => ref
                  .read(TransactionSyncProvider.notifier)
                  .SyncNow(),
            ),
          ),
        );
        return;
      }

      final TransactionSyncResult? Result = Current.value;
      if (Result?.HasFailures == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${Result!.FailedBatchCount} batch(es) failed. Please try again.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => ref
                  .read(TransactionSyncProvider.notifier)
                  .SyncNow(),
            ),
          ),
        );
        return;
      }

      if (Result != null) {
        final Message = Result.SyncedBatchCount == 0
            ? 'No pending transactions to sync.'
            : '${Result.SyncedBatchCount} batch(es) synced successfully.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Message)),
        );
      }
    });

    final GoogleDriveState = ref.watch(GoogleDriveConnectionProvider);
    final GoogleDriveConnection? GoogleDriveAccount = GoogleDriveState.value;
    final SyncState = ref.watch(TransactionSyncProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Exit owner mode',
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              ref.read(OwnerModeProvider.notifier).SetOwnerMode(false);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (Route<dynamic> Route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.admin_panel_settings_outlined, size: 56),
                const SizedBox(height: 16),
                Text(
                  'Owner Mode Active',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 16),
                Text(
                  'Access keyword: ${OwnerAccess.AccessName}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductManagementPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Manage Products'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionRecordsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Transaction Records'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OwnerSettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Owner Settings'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: GoogleDriveState.isLoading
                      ? null
                      : GoogleDriveAccount == null
                      ? () => ref
                            .read(GoogleDriveConnectionProvider.notifier)
                            .Connect()
                      : () => ref
                            .read(GoogleDriveConnectionProvider.notifier)
                            .Disconnect(),
                  icon: Icon(
                    GoogleDriveAccount == null
                        ? Icons.cloud_outlined
                        : Icons.cloud_done_outlined,
                  ),
                  label: Text(
                    GoogleDriveState.isLoading
                        ? 'Connecting...'
                        : GoogleDriveAccount == null
                        ? 'Connect Google Drive'
                        : 'Disconnect ${GoogleDriveAccount.Email}',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: GoogleDriveAccount == null || SyncState.isLoading
                      ? null
                      : () => ref
                            .read(TransactionSyncProvider.notifier)
                            .SyncNow(),
                  icon: const Icon(Icons.sync_outlined),
                  label: Text(
                    SyncState.isLoading
                        ? 'Syncing transactions...'
                        : 'Sync Transactions',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.syncCenter,
                  ),
                  icon: const Icon(Icons.sync_alt_outlined),
                  label: const Text('Open Sync Center'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.updateAppProtocol),
                  icon: const Icon(Icons.system_update_alt_outlined),
                  label: const Text('Prepare App Update Backup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
