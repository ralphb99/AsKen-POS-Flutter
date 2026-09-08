import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final CashierNameController = TextEditingController();
  String CashierName = '';

  @override
  void dispose() {
    CashierNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter Cashier Name',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      controller: CashierNameController,
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

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                             if(!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                    content: Text('No Input'),
                                  ),
                                );
                               
                              } else {
                                 CashierName = CashierNameController.text.trim();
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                    content: Text('Success. Welcome $CashierName'),
                                  ),
                                );
                              }
                        },
                        child: const Text('Start'),
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