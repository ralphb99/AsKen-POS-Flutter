import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/application/LoginController.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final FormKey = GlobalKey<FormState>();
  final CashierNameController = TextEditingController();
  final OwnerPinController = TextEditingController();
  final ConfirmOwnerPinController = TextEditingController();
  bool IsOwnerAccessVisible = false;

  @override
  void dispose() {
    CashierNameController.dispose();
    OwnerPinController.dispose();
    ConfirmOwnerPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginState = ref.watch(LoginControllerProvider);
    final OwnerPinState = ref.watch(OwnerPinConfiguredProvider);
    final IsBusy = LoginState.isLoading || OwnerPinState.isLoading;
    final IsOwnerPinConfigured = OwnerPinState.asData?.value ?? false;

    ref.listen(LoginControllerProvider, (Previous, Current) {
      if (!Current.hasError || !context.mounted) {
        return;
      }

      final ErrorMessage = Current.error.toString().replaceFirst(
        'FormatException: ',
        '',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMessage)),
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, Constraints) {
            final MinimumHeight = Constraints.maxHeight > 32
                ? Constraints.maxHeight - 32
                : 0.0;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 320,
                    minHeight: MinimumHeight,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Form(
                      key: FormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                    Text(
                      'AsKen POS',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      IsOwnerAccessVisible
                          ? 'Owner Dashboard'
                          : 'Educational Supply Store',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                        const SizedBox(height: 28),
                        if (!IsOwnerAccessVisible) ...[
                      TextFormField(
                        controller: CashierNameController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Cashier name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (Value) {
                          if (Value == null || Value.trim().isEmpty) {
                            return 'Please input name.';
                          }

                          return null;
                        },
                        onFieldSubmitted: IsBusy ? null : (_) => StartCashier(),
                      ),
                      const SizedBox(height: 30),
                     SizedBox(
                        height: 60,
                        child: FilledButton(
                          onPressed: IsBusy ? null : StartCashier,
                          child: Text(IsBusy ? 'Checking...' : 'Enter Checkout'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 60,
                        child: OutlinedButton.icon(
                          iconAlignment: IconAlignment.end,
                          onPressed: IsBusy ? null : ShowOwnerAccess,
                          icon: const Icon(Icons.admin_panel_settings_outlined),
                          label: const Text('Owner Dashboard'),
                        ),
                      ),
                    ] else ...[
                      TextFormField(
                        controller: OwnerPinController,
                        autofocus: true,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textInputAction: IsOwnerPinConfigured
                            ? TextInputAction.done
                            : TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: IsOwnerPinConfigured
                              ? 'Owner PIN'
                              : 'Create owner PIN',
                          prefixIcon: const Icon(Icons.lock_outline),
                          helperText: IsOwnerPinConfigured
                              ? 'Enter your 4 to 6 digit PIN.'
                              : 'Create a 4 to 6 digit PIN.',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (Value) {
                          if (Value == null ||
                              !RegExp(r'^\d{4,6}$').hasMatch(Value)) {
                            return 'Use 4 to 6 digits.';
                          }

                          return null;
                        },
                        onFieldSubmitted: IsBusy
                            ? null
                            : (_) => EnterOwnerMode(IsOwnerPinConfigured),
                      ),
                      if (!IsOwnerPinConfigured) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: ConfirmOwnerPinController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Confirm owner PIN',
                            prefixIcon: Icon(Icons.lock_reset_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (Value) {
                            if (Value != OwnerPinController.text) {
                              return 'PIN entries do not match.';
                            }

                            return null;
                          },
                          onFieldSubmitted: IsBusy
                              ? null
                              : (_) => EnterOwnerMode(IsOwnerPinConfigured),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        child: FilledButton(
                        onPressed: IsBusy
                            ? null
                            : () => EnterOwnerMode(IsOwnerPinConfigured),
                        child: Text(
                          IsBusy ? 'Checking...' : 'Enter Owner Dashboard',
                        ),
                      ),
                     ),

                     const SizedBox(height: 20),
                      TextButton(
                        onPressed: IsBusy ? null : HideOwnerAccess,
                        child: const Text('Back to Cashier Login'),
                      ),
                        ],
                      ]
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void ShowOwnerAccess() {
    setState(() {
      IsOwnerAccessVisible = true;
    });
  }

  void HideOwnerAccess() {
    OwnerPinController.clear();
    ConfirmOwnerPinController.clear();
    FormKey.currentState?.reset();

    setState(() {
      IsOwnerAccessVisible = false;
    });
  }

  Future<void> StartCashier() async {
    if (!(FormKey.currentState?.validate() ?? false)) {
      return;
    }

    final Result = await ref
        .read(LoginControllerProvider.notifier)
        .AuthenticateCashier(CashierName: CashierNameController.text);

    if (!mounted || Result == null || Result.IsOwner) {
      return;
    }

    ref.invalidate(ActiveCashierProvider);
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.checkout,
      arguments: Result.CashierName,
    );
  }

  Future<void> EnterOwnerMode(bool IsOwnerPinConfigured) async {
    if (!(FormKey.currentState?.validate() ?? false)) {
      return;
    }

    final Result = await ref
        .read(LoginControllerProvider.notifier)
        .AuthenticateOwner(
          OwnerPin: OwnerPinController.text,
          ConfirmOwnerPin: IsOwnerPinConfigured
              ? OwnerPinController.text
              : ConfirmOwnerPinController.text,
        );

    if (!mounted || Result == null || !Result.IsOwner) {
      return;
    }

    ref.read(OwnerModeProvider.notifier).SetOwnerMode(true);
    Navigator.pushReplacementNamed(context, AppRoutes.ownerDashboard);
  }
}
