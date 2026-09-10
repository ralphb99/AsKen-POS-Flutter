import 'package:flutter/material.dart';
import 'package:asken_pos/app/routes/AppRoutes.dart';

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
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(50),
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

                    const SizedBox(height: 60),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                             if(!_formKey.currentState!.validate()) {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //    SnackBar(
                                //     content: Text('No Input'),
                                //   ),
                                // );

                                return;
                               
                              } else {

                                 CashierName = CashierNameController.text.trim();
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
                        style:ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          
                        ),
                        child: const Text('START'),
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