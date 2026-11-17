import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';

final LoginControllerProvider = AsyncNotifierProvider.autoDispose<
  LoginController,
  LoginResult?
>(LoginController.new);

class LoginController extends AsyncNotifier<LoginResult?> {
  @override
  Future<LoginResult?> build() async => null;

  Future<LoginResult?> AuthenticateCashier({
    required String CashierName,
  }) async {
    if (state.isLoading) {
      return null;
    }

    state = const AsyncLoading();
    final Result = await AsyncValue.guard(() async {
      final NormalizedCashierName = CashierName.trim();
      if (NormalizedCashierName.isEmpty) {
        throw const FormatException('Please enter your name.');
      }

      await ref
          .read(CashierSessionServiceProvider)
          .SaveCashierName(NormalizedCashierName);

      return LoginResult.Cashier(CashierName: NormalizedCashierName);
    });
    state = Result;
    return Result.value;
  }

  Future<LoginResult?> AuthenticateOwner({
    required String OwnerPin,
    required String ConfirmOwnerPin,
  }) async {
    if (state.isLoading) {
      return null;
    }

    state = const AsyncLoading();
    final Result = await AsyncValue.guard(() async {
      if (!RegExp(r'^\d{4,6}$').hasMatch(OwnerPin)) {
        throw const FormatException('Use a 4 to 6 digit owner PIN.');
      }

      final OwnerPinService = ref.read(OwnerPinServiceProvider);
      final IsConfigured = await OwnerPinService.HasConfiguredPin();

      if (!IsConfigured) {
        if (OwnerPin != ConfirmOwnerPin) {
          throw const FormatException('PIN entries do not match.');
        }

        await OwnerPinService.SetPin(OwnerPin);
        ref.invalidate(OwnerPinConfiguredProvider);
      } else if (!await OwnerPinService.VerifyPin(OwnerPin)) {
        throw const FormatException('Incorrect owner PIN.');
      }

      return const LoginResult.Owner();
    });
    state = Result;
    return Result.value;
  }
}

class LoginResult {
  final bool IsOwner;
  final String? CashierName;

  const LoginResult._({required this.IsOwner, this.CashierName});

  const LoginResult.Owner() : this._(IsOwner: true);

  const LoginResult.Cashier({required String CashierName})
    : this._(IsOwner: false, CashierName: CashierName);
}
