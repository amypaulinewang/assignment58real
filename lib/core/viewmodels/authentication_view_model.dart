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
    AppUser? loggedInAppUser = await authenticationProvider.createUser(
        currUser: currUser);
    if (loggedInAppUser == null) {
      return false;
    }
    signInUser(loggedInAppUser.email, currUser.password);
    isLoading = false;
    notifyListeners();
    return true;
  }

  //PUT
  Future<bool> updateUser(AppUser newAppUser) async {
    return await authenticationProvider.updateUser(newAppUser);
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

  Future<bool> createAccount(String name, String email, String password) async {
    try {
    return true;
    } catch (e) {
      return false;
    }
  }

}