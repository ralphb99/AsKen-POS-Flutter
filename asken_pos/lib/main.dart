import 'package:flutter/material.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database = AppDatabase();

  await Database.SeedProducts();

  final ProdService = ProductsService(
    Database: Database,
  );

  runApp(
    AsKenPOS(
      ProdService: ProdService,
    ),
  );
}

class AsKenPOS extends StatelessWidget {
  final ProductsService ProdService;

  const AsKenPOS({
    super.key,
    required this.ProdService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AsKen POS',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        return AppRoutes.generateRoute(
          settings,
          ProdService,
        );
      },
    );
  }
}