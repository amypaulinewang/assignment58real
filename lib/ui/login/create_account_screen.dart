import 'package:assignment58real/ui/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_utils.dart';
import '../../core/models/app_user.dart';
import '../../core/viewmodels/authentication_view_model.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late String name = "";
  late String email = "";
  late String password = "";
  late String location = "";

  bool _passwordVisible = false; // Password visibility flag
  final _formKey = GlobalKey<FormState>();

  // Password validation logic
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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
                  padding: EdgeInsets.only(left: 30, top: 60, right: 30, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Name"),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.name],
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: AppUtils.textFieldDecoration.copyWith(
                          hintText: "",
                        ),
                      ),
                      const Text("Email"),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: AppUtils.textFieldDecoration.copyWith(
                          hintText: "",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          return null;
                        },
                      ),
                      const Text("Password"),
                      const SizedBox(height: 8),
                      TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.password],
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          decoration: AppUtils.textFieldDecoration
                              .copyWith(hintText: "")
                      ),
                      const Text("Location"),
                      const SizedBox(height: 5),
                      TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          autofillHints: const [AutofillHints.location],
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            location = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                          decoration: AppUtils.textFieldDecoration
                              .copyWith(hintText: "")
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: TextButton(
                          child: Text('Create Account'),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Only proceed if the form is valid
                              AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
                              AppUser newUser = AppUser(
                                name: name,
                                email: email,
                                password: password,
                                location: location,
                                uid: '',
                              );
                              // Call a method to create an account (assuming createAccount is the method)
                              bool accountCreated = await authAccess.createUser(newUser);

                              if (accountCreated) {
                                // Navigate to the login screen and replace the current screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                                // Show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Account created successfully!"),
                                    duration: Duration(seconds: 3),
                                  ),
                                );

                              } else {
                                // If account creation fails
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to create account. Please try again."),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              // Handle invalid form state
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fix the errors in the form."),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Added 'Return to Login' button
                      TextButton(
                        onPressed: () {
                          // Navigate back to the login screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text("Return to Login"),
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
