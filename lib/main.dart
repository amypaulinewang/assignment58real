import 'package:assignment58real/ui/home_screen.dart';
import 'package:assignment58real/ui/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/authentication_provider.dart';
import 'core/viewmodels/authentication_view_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance),
          ), // Provider
          StreamProvider(
            create: (context) => context.read<AuthenticationProvider>().authState, initialData: null,
          ), // Stream Provider
          ChangeNotifierProvider<AuthenticationViewModel>(
            create: (context) => AuthenticationViewModel(context: context),
          ),
        ],
        child: MaterialApp(
            title: 'Authentication Practice',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent)
            ),
            debugShowCheckedModeBanner: false,
            home: Authenticate()
        )
    );

  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      //means that the user is logged in already and hence navigate to HomePage
      return HomeScreen();
    }
    // the user isn't logged in and hence navigate to SignInPage
    return LoginScreen();
  }
}
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     return CreateAccountScreen();
//   }
// }