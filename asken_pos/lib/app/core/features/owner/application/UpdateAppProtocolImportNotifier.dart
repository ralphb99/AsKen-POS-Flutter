import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/domain/UpdateAppProtocolImport.dart';

final UpdateAppProtocolImportProvider =
    AsyncNotifierProvider.autoDispose<
      UpdateAppProtocolImportNotifier,
      UpdateAppProtocolImportSession?
    >(UpdateAppProtocolImportNotifier.new);

class UpdateAppProtocolImportNotifier
    extends AsyncNotifier<UpdateAppProtocolImportSession?> {
  @override
  Future<UpdateAppProtocolImportSession?> build() async => null;

  Future<void> PickAndPreview() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final Document = await ref
          .read(UpdateAppProtocolImportServiceProvider)
          .PickAndValidate();

      if (Document == null) {
        return null;
      }

      final Preview = await ref
          .read(UpdateAppProtocolImportServiceProvider)
          .BuildPreview(Document);

      return UpdateAppProtocolImportSession(
        Document: Document,
        Preview: Preview,
      );
    });
  }

  Future<UpdateAppProtocolImportResult?> Restore() async {
    final CurrentSession = state.value;
    if (CurrentSession == null || state.isLoading) {
      return null;
    }

    state = const AsyncLoading();

    try {
      final Result = await ref
          .read(UpdateAppProtocolImportServiceProvider)
          .Restore(CurrentSession.Document);
      state = AsyncData(CurrentSession.WithResult(Result));
      return Result;
    } catch (Error, StackTrace) {
      state = AsyncError(Error, StackTrace);
      rethrow;
    }
  }
}
