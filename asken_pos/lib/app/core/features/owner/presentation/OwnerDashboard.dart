import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/OwnerAccess.dart';
import 'package:asken_pos/app/core/features/owner/presentation/OwnerSettings.dart';
import 'package:asken_pos/app/core/features/owner/presentation/ProductManagement.dart';
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

    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
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
                const SizedBox(height: 8),
                Text(
                  'Product management tools will be available here.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
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
                        builder: (_) => const OwnerSettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Owner Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
