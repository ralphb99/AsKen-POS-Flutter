import 'package:flutter/material.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/Login.dart';
import 'package:asken_pos/app/core/features/checkout/presentation/Checkout.dart';


class AppRoutes {
  AppRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String checkout = '/checkout';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case checkout:
        final CashierName = settings.arguments as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => CheckoutPage(
            CashierName: CashierName,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}
