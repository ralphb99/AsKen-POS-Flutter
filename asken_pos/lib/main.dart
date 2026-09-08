import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/Login.dart';
void main() {
  runApp(const AsKenPOS());
}

class AsKenPOS extends StatelessWidget {
  const AsKenPOS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AsKen POS',
      home: const LoginPage(),
    );
  }
}

