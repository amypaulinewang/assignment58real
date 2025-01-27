import 'package:assignment58real/core/viewmodels/authentication_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Ensuring that the code is executed after the widget has been fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Using the provider here is safe
      AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
      authAccess.fetchCurrentAppUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
              authAccess.signOutUser();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                AuthenticationViewModel authAccess = Provider.of<AuthenticationViewModel>(context, listen: false);
                authAccess.deleteUser();
              },
              child: Text("Delete User"),
            ),
          ],
        ),
      ),
    );
  }
}
