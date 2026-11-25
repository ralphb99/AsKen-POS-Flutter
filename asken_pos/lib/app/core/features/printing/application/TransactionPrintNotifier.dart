import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';

final TransactionPrintProvider =
    AsyncNotifierProvider.autoDispose<
      TransactionPrintNotifier,
      TransactionPrintResult?
    >(TransactionPrintNotifier.new);

class TransactionPrintNotifier extends AsyncNotifier<TransactionPrintResult?> {
  @override
  Future<TransactionPrintResult?> build() async => null;

  Future<TransactionPrintResult?> PrintTransaction({
    required int TransactionID,
  }) async {
    if (state.isLoading) {
      return state.value;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(TransactionPrintServiceProvider)
          .PrintTransaction(TransactionID: TransactionID),
    );
    return state.value;
  }
}
