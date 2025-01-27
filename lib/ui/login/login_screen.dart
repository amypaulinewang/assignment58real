import 'package:assignment58real/core/constants/app_utils.dart';
import 'package:assignment58real/ui/login/create_account_screen.dart';
import 'package:assignment58real/ui/login/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/viewmodels/authentication_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String fullName = "";
  late String email = "";
  late String password = "";
  late bool _passwordVisible = false;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //
    AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50),
              child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text("Email"),
                            const SizedBox(height: 8),
                            TextField(
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  email = value;
                                },
                                decoration: AppUtils.textFieldDecoration.copyWith(
                                    hintText: ""
                                )
                            ),
                            const SizedBox(height: 20.0),
                            const Text("Password"),
                            SizedBox(height: 8),
                            TextField(
                                autofillHints: const [AutofillHints.password],
                                obscureText: !_passwordVisible,
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  password = value;
                                },
                                decoration: AppUtils.textFieldDecoration.copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisibile variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    // fillColor: lightBrown,
                                    hintText: ""
                                )
                            ),
                            const SizedBox(height: 24.0,),
                            Center(
                              child: TextButton(
                                  child: Text('Log In'),
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()) {


                                      AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
                                      bool loggedIn = await authAccess.signInUser(email, password);
                                      print("LOGGED IN: $bool");
                                      if(!loggedIn){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Try a different email and/or password."),
                                              duration: Duration(seconds: 3),
                                            )
                                        );
                                      }
                                    }
                                  }

                              ),
                            ),
                            const SizedBox(height: 24.0,),
                            Center(child: Text("Don't have an account?")),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 30),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerLeft),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountScreen()));
                                },
                                child: Center(
                                    child: Text("Create Account")
                                )
                            ),
                            TextButton(onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
                            }, child: Center(child: Text("Reset Password"))
                            )
                          ]
                      )
                  )
              )
          ),
          if(authAccess.isLoading)
            const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}