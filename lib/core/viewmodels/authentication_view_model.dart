import "../models/app_user.dart";
import 'base_view_model.dart';

class AuthenticationViewModel extends BaseViewModel {
  AuthenticationViewModel({required super.context});

  bool isLoading = false;

  AppUser? getCurrentAppUser() {
    print("GET CURRENT APP USER: ${authenticationProvider.currentAppUser}");
    return authenticationProvider.currentAppUser;
  }

  Future<AppUser?> fetchCurrentAppUser() {
    return authenticationProvider.fetchCurrentAppUser();
  }

  Future<bool> createUser(AppUser currUser) async {
    isLoading = true;
    notifyListeners();

    // Call createUser, which now returns a boolean (true or false)
    bool accountCreated =
    await authenticationProvider.createUser(currUser: currUser);

    if (accountCreated) {
      // If the account is created, sign in the user
      await signInUser(currUser.email, currUser.password);
    }

    isLoading = false;
    notifyListeners();

    return accountCreated;
  }

  //PUT
  Future<bool> updateUser(AppUser newAppUser) async {
    isLoading = true;
    notifyListeners();

    // Update user data in backend
    bool success = await authenticationProvider.updateUser(newAppUser);

    if (success) {
      // Update the local currentAppUser after successful backend update
      authenticationProvider.setCurrentAppUser(newAppUser);
    }

    isLoading = false;
    notifyListeners();

    return success;
  }

  //DELETE
  Future<bool> deleteUser() async {
    return await authenticationProvider.deleteUser();
  }


  Future<bool> signInUser(String email, String password) async {
    isLoading = true;
    notifyListeners();

    AppUser? loggedInAppUser = await authenticationProvider.signIn(
        email: email, password: password);

    isLoading = false;
    notifyListeners();
    return (loggedInAppUser != null);
  }

  Future<bool> signOutUser() async {
    return await authenticationProvider.signOut();
  }

  Future<bool> resetPassword(String email) async{
    return await authenticationProvider.resetPassword(email);
  }
}