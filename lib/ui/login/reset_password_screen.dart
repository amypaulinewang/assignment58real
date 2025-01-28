import 'package:flutter/material.dart';
import 'package:assignment58real/core/constants/app_utils.dart';
import 'package:assignment58real/ui/login/login_screen.dart';
import 'package:provider/provider.dart';
import '../../core/viewmodels/authentication_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late String email = "";
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    // Simple email regex validation
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const double logoHeight = 300;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomSectionHeight = screenHeight - logoHeight;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: bottomSectionHeight,
                  padding: EdgeInsets.only(
                      left: 30, top: 60, right: 30, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Email"),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: _validateEmail, // Email validation
                        decoration: AppUtils.textFieldDecoration.copyWith(
                          hintText: "Enter your email",
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent, // Remove shadow
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                showSpinner = true;
                              });

                              AuthenticationViewModel authAccess =
                              Provider.of<AuthenticationViewModel>(context,
                                  listen: false);
                              bool passwordReset = await authAccess
                                  .resetPassword(email);

                              setState(() {
                                showSpinner = false;
                              });

                              if (passwordReset) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "If your account exists, an email has been sent with instructions."),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                // After password reset, navigate back to the login screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Error: Email field is empty or incorrect - try again."),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          child: showSpinner
                              ? const CircularProgressIndicator()
                              : const Text('Send Reset Email'),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Added 'Back to Login' button
                      TextButton(
                        onPressed: () {
                          // Navigate back to the login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text("Back to Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
