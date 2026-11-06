// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:asken_pos/app/core/database/AppDatabase.dart';
// import 'package:asken_pos/app/core/features/checkout/data/ProductsService.dart';
// import 'package:asken_pos/app/core/features/checkout/data/session/CheckoutSessionService.dart';

// final AppDatabaseProvider = Provider<AppDatabase>((ref) {
//   final Database = AppDatabase();

//   ref.onDispose(() {
//     unawaited(Database.close());
//   });

//   return Database;
// });

// final ProductsServiceProvider = Provider<ProductsService>((ref) {
//   return ProductsService(
//     Database: ref.watch(AppDatabaseProvider),
//   );
// });

// final CheckoutSessionServiceProvider =
//     Provider<CheckoutSessionService>((ref) {
//   return const CheckoutSessionService();
// });