import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment58real/core/viewmodels/authentication_view_model.dart';
import 'package:assignment58real/core/models/app_user.dart';

class EditUserScreen extends StatefulWidget {
  final AppUser? currentUser;

  const EditUserScreen({super.key, required this.currentUser});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentUser == null) {
      // You can show an error or navigate back to the previous screen if no user is provided.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user data available to edit")),
        );
        Navigator.pop(context);  // Go back to the previous screen
      });
      return;
    }
    // Initialize the controllers with the current user data
    _nameController = TextEditingController(text: widget.currentUser?.name);
    _emailController = TextEditingController(text: widget.currentUser?.email);
    _locationController = TextEditingController(text: widget.currentUser?.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUser() async {
    setState(() {
      isLoading = true;
    });

    // Create an updated user object
    AppUser updatedUser = AppUser(
      uid: widget.currentUser!.uid,
      name: _nameController.text,
      email: _emailController.text,
      location: _locationController.text,
      password: widget.currentUser!.password, // You may want to handle password differently
    );

    // Call the update method from the view model
    AuthenticationViewModel authViewModel = Provider.of<AuthenticationViewModel>(context, listen: false);
    bool success = await authViewModel.updateUser(updatedUser);

    setState(() {
      isLoading = false;
    });

    // Display a success or error message
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User updated successfully")),
      );
      // After successful update, you can refresh the data from the server
      await authViewModel.fetchCurrentAppUser();
      Navigator.pop(context); // Go back to Home screen after successful update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update user")),
      );
    }
  }

}