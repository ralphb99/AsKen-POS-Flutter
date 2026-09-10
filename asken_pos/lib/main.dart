import 'package:flutter/material.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

void main() {
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