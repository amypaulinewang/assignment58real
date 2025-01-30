import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_utils.dart';
import '../models/app_user.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider{
  final FirebaseAuth firebaseAuth;

  User? currentFirebaseUser;
  AppUser? currentAppUser;

  AuthenticationProvider(this.firebaseAuth){
    firebaseAuth.authStateChanges().listen((user) {
      currentFirebaseUser = user;
    });
  }
  Stream<User?> get authState => firebaseAuth.authStateChanges();


  AppUser getCurrentAppUser(){
    return currentAppUser!;
  }
  void setCurrentAppUser(AppUser? appUser){
    currentAppUser = appUser;
  }

  Future<AppUser?> fetchCurrentAppUser() async {
    if(firebaseAuth.currentUser == null){
      return null;
    }
    String? userUid = firebaseAuth.currentUser?.uid;
    print("USER UID: $userUid");
    try {
      // final url = Uri.https(AppUtils.backendApiUrl, '/app/api/users/$userUid');
      final http.Response response = await http.get(
      Uri.https(AppUtils.backendApiUrl, '/app/api/users/$userUid'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        AppUser appUser = AppUser.fromJson(result['result']);
        setCurrentAppUser(appUser); // Update the currentAppUser
        return appUser;
      } else {
        print(
            "Failed to fetch user details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    return null;
  }


  Future<bool> createUser({required AppUser currUser}) async {
    try {
      print("BEFORE...");
      var url = Uri.https("us-central1-assignment52-887a1.cloudfunctions.net", "app/api/users");
      print ("BRL: $url");
      final http.Response response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': currUser.name,
            'email': currUser.email,
            'location': currUser.location,
            'password': currUser.password,
          }),
      );
      if(response.statusCode == 200){
        final result = jsonDecode(response.body);
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print("error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateUser(AppUser newAppUser) async {
    print("Updating user... UID: ${newAppUser.uid}");

    try {
      var url = Uri.https(AppUtils.backendApiUrl, '/app/api/users/user');

      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userUid': newAppUser.uid,
          'name': newAppUser.name,
          'email': newAppUser.email,
          'location': newAppUser.location,
        }),
      );

      // Debugging: Log the response body
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check if the update was successful (HTTP 200 OK)
      if (response.statusCode == 200) {
        // If the backend update is successful, update local state
        setCurrentAppUser(newAppUser);
        print("User updated successfully!");
        return true;
      } else {
        // If not successful, print an error message with the response
        print("Failed to update user. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Log any errors that occur during the request
      print("Error occurred during user update: $e");
      return false;
    }
  }



  Future<bool> deleteUser() async { //delete firebase and app user

    String? uid = currentFirebaseUser?.uid;
    print ("DELETEEEEEE: $uid");
    try {
      // var url = Uri.https(AppUtils.backendApiUrl, '/app/api/users/$firebaseUid');
      var url = Uri.https("us-central1-assignment52-887a1.cloudfunctions.net", "/app/api/users/$uid");
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(response.statusCode != 500){
        await FirebaseAuth.instance.signOut();
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }



  Future<AppUser?> signIn({required String email, required String password}) async {
    print("email：$email");
    print("password: $password");
    try {
      //call firebase directly to sign in
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user; //get firebase user
      if(user != null){
        print("after logging in - firebase user: ${user.uid}");
        setCurrentAppUser(await fetchCurrentAppUser()); //get + set app user
        return currentAppUser;
      }
      return null;
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }

  Future<bool> resetPassword(String email) async{
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(err){
      print("ERROR: $err");
      return false;
    }
    return true;
  }

  //SIGN OUT METHOD
  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      setCurrentAppUser (null);
      return true;
    } catch (e) {
      print("ERROR: $e");
    }
    return false;
  }
}