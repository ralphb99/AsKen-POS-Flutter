import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';

class OwnerSettingsPage extends ConsumerStatefulWidget {
  const OwnerSettingsPage({super.key});

  @override
  ConsumerState<OwnerSettingsPage> createState() => _OwnerSettingsPageState();
}

class _OwnerSettingsPageState extends ConsumerState<OwnerSettingsPage> {
  final CurrentPinController = TextEditingController();
  final NewPinController = TextEditingController();
  final ConfirmPinController = TextEditingController();
  final FormKey = GlobalKey<FormState>();
  bool IsSaving = false;

  @override
  void dispose() {
    CurrentPinController.dispose();
    NewPinController.dispose();
    ConfirmPinController.dispose();
    super.dispose();
  }

  Future<void> ChangePin() async {
    if (IsSaving || !(FormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      IsSaving = true;
    });

    try {
      final PinService = ref.read(OwnerPinServiceProvider);
      final IsCurrentPinValid = await PinService.VerifyPin(
        CurrentPinController.text,
      );

      if (!IsCurrentPinValid) {
        throw const FormatException('The current PIN is incorrect.');
      }

      await PinService.SetPin(NewPinController.text);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Owner PIN updated successfully.')),
      );
      Navigator.pop(context);
    } catch (Error) {
      if (!mounted) {
        return;
      }

      setState(() {
        IsSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Error.toString().replaceFirst('FormatException: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: FormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Change owner PIN',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Use a 4 to 6 digit PIN.'),
                  const SizedBox(height: 24),
                  _PinField(
                    Controller: CurrentPinController,
                    Label: 'Current PIN',
                  ),
                  const SizedBox(height: 16),
                  _PinField(Controller: NewPinController, Label: 'New PIN'),
                  const SizedBox(height: 16),
                  _PinField(
                    Controller: ConfirmPinController,
                    Label: 'Confirm new PIN',
                    Validator: (Value) {
                      if (Value != NewPinController.text) {
                        return 'PIN entries do not match.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: IsSaving ? null : ChangePin,
                    child: Text(IsSaving ? 'Saving...' : 'Save PIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  final TextEditingController Controller;
  final String Label;
  final String? Function(String?)? Validator;

  const _PinField({
    required this.Controller,
    required this.Label,
    this.Validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      decoration: InputDecoration(
        labelText: Label,
        border: const OutlineInputBorder(),
      ),
      validator: (Value) {
        if (Value == null || !RegExp(r'^\d{4,6}$').hasMatch(Value)) {
          return 'Use 4 to 6 digits.';
        }

        return Validator?.call(Value);
      },
    );
  }
}
