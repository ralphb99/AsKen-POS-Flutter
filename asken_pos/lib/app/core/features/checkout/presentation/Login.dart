import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/OwnerAccess.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final CashierNameController = TextEditingController();
  final OwnerPinController = TextEditingController();
  final ConfirmOwnerPinController = TextEditingController();
  String CashierName = '';
  bool IsOwnerMode = false;

  @override
  void dispose() {
    CashierNameController.dispose();
    OwnerPinController.dispose();
    ConfirmOwnerPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OwnerPinStatus = ref.watch(OwnerPinConfiguredProvider);
    final IsOwnerPinLoading = OwnerPinStatus.isLoading;
    final IsOwnerPinConfigured = OwnerPinStatus.asData?.value ?? false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              left: 50,
              right: 50,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 80,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'AsKen POS',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),

                    const SizedBox(height: 50),

                    Text(
                      'Enter Cashier Name',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: CashierNameController,
                      onChanged: (Value) {
                        final OwnerMode = OwnerAccess.IsOwnerName(Value);

                        if (OwnerMode != IsOwnerMode) {
                          setState(() {
                            IsOwnerMode = OwnerMode;
                          });
                        }
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Cashier Name',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }

                        return null;
                      },
                    ),

                    if (IsOwnerMode) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: OwnerPinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: IsOwnerPinConfigured
                              ? 'Owner PIN'
                              : 'Create Owner PIN',
                          helperText: IsOwnerPinConfigured
                              ? 'Enter your 4 to 6 digit PIN.'
                              : 'Create initial Secret Owner Pin',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (Value) {
                          if (!IsOwnerMode) {
                            return null;
                          }

                          if (Value == null ||
                              !RegExp(r'^\d{4,6}$').hasMatch(Value)) {
                            return 'Use 4 to 6 digits.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!IsOwnerPinConfigured)
                        TextFormField(
                          controller: ConfirmOwnerPinController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Owner PIN',
                            border: OutlineInputBorder(),
                          ),
                          validator: (Value) {
                            if (Value != OwnerPinController.text) {
                              return 'PIN entries do not match.';
                            }

                            return null;
                          },
                        ),
                    ],

                    const SizedBox(height: 100),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final FormState? CurrentForm = _formKey.currentState;

                          if (CurrentForm == null || !CurrentForm.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //    SnackBar(
                            //     content: Text('No Input'),
                            //   ),
                            // );

                            return;
                          } else {
                            CashierName = CashierNameController.text.trim();

                            if (OwnerAccess.IsOwnerName(CashierName)) {
                              if (OwnerPinStatus.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Unable to load owner security settings.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (IsOwnerPinLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Owner security is still loading.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final OwnerPin = OwnerPinController.text;
                              final OwnerPinService = ref.read(
                                OwnerPinServiceProvider,
                              );

                              if (IsOwnerPinConfigured) {
                                final IsValid = await OwnerPinService.VerifyPin(
                                  OwnerPin,
                                );

                                if (!IsValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Incorrect owner PIN.'),
                                    ),
                                  );
                                  return;
                                }
                              } else {
                                await OwnerPinService.SetPin(OwnerPin);
                                ref.invalidate(OwnerPinConfiguredProvider);
                              }

                              ref
                                  .read(OwnerModeProvider.notifier)
                                  .SetOwnerMode(true);

                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.ownerDashboard,
                              );
                              return;
                            }

                            await ref
                                .read(CashierSessionServiceProvider)
                                .SaveCashierName(CashierName);
                            ref.invalidate(ActiveCashierProvider);

                            if (!mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Success. Welcome $CashierName'),
                              ),
                            );

                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.checkout,
                              arguments: CashierName,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: BeveledRectangleBorder(),
                        ),
                        child: Text('START'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
