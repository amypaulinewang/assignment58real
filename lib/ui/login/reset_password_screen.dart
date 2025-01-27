import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment58real/core/constants/app_utils.dart';
import 'package:assignment58real/ui/login/login_screen.dart';
import '../../core/viewmodels/authentication_view_model.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late String email = "";
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const double logoHeight = 300;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomSectionHeight = screenHeight - logoHeight;

    return Scaffold(
      body: Stack(
          children: [
            SingleChildScrollView(
                padding: const EdgeInsets.only(top: 50),
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                                        Center(
                                          child: TextButton(
                                              child: Text('Send Reset Email'),
                                              onPressed: () async {
                                                AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
                                                bool passwordReset = await authAccess.resetPassword(email);
                                                if(passwordReset){
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("If your account exists, an email has been sent with instructions."),
                                                        duration: Duration(seconds: 3),
                                                      )
                                                  );
                                                }
                                                else{
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Error: Email field is empty or incorrect - try again."),
                                                        duration: Duration(seconds: 3),
                                                      )
                                                  );
                                                }

                                              }
                                          ),
                                        )
                                      ]
                                  )
                              )
                            ]
                        )

                    )
                )
            )]
        //
        // child: Column(
        //
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       "Hi, reset password screen is working!",
        //     ),
        //     TextButton(
        //         onPressed: (){
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        //         },
        //         child: Text("Back to Login")
        //     ),
        //   ],
        // ),
      ),
    );
  }
}