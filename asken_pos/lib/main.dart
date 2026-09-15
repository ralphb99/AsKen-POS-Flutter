import 'package:flutter/material.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await database.close();

  runApp(const AsKenPOS());
}

class AsKenPOS extends StatelessWidget {
  const AsKenPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AsKen POS',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}