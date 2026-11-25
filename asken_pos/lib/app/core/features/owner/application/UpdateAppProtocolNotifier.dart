import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/domain/UpdateAppProtocol.dart';

final UpdateAppProtocolProvider =
    AsyncNotifierProvider.autoDispose<
      UpdateAppProtocolNotifier,
      UpdateAppProtocolExportResult?
    >(UpdateAppProtocolNotifier.new);

class UpdateAppProtocolNotifier
    extends AsyncNotifier<UpdateAppProtocolExportResult?> {
  @override
  Future<UpdateAppProtocolExportResult?> build() async => null;

  Future<UpdateAppProtocolExportResult?> Export() async {
    if (state.isLoading) {
      return state.value;
    }

    state = const AsyncLoading();

    try {
      final Result = await ref
          .read(UpdateAppProtocolExportServiceProvider)
          .Export();
      state = AsyncData(Result);
      return Result;
    } catch (Error, StackTrace) {
      state = AsyncError(Error, StackTrace);
      rethrow;
    }
  }
}
