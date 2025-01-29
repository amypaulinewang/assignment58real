import 'package:assignment58real/core/viewmodels/authentication_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment58real/ui/login/edit_screen.dart';

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
    final authAccess = Provider.of<AuthenticationViewModel>(context);
    final currentUser = authAccess.getCurrentAppUser();

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
                // Navigate to EditUserScreen with the current user data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(currentUser: currentUser),
                  ),
                );
              },
              child: const Text("Edit User"),
            ),
            TextButton(
              onPressed: () async {
                bool success = await authAccess.deleteUser();

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User deleted successfully")),
                  );
                  Navigator.pushReplacementNamed(context, '/login');  // Navigate back to login screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete user")),
                  );
                }
              },
              child: const Text("Delete User"),
            ),
          ],
        ),
      ),
    );
  }
}
