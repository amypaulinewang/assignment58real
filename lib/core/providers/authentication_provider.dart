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
    authState.listen((user) {
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
      final http.Response response = await http.get(
        Uri.https(AppUtils.backendApiUrl, '/app/api/users/$userUid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode != 500) {
        final result = jsonDecode(response.body);
        return AppUser.fromJson(result['result']);
      }
    }catch(e){
      print(e.toString());
    }
    return null;
  }


  Future<AppUser?> createUser({required AppUser currUser}) async {
    try {
      print("BEFORE...");
      var url = Uri(scheme: 'http', host: "127.0.0.1", port: 5001, path: "/assignment52-887a1/us-central1/app/apd/users");
      print ("BRL: $url");
      // print"URL: #fur.https(appUtils.packendApiurl, '/app/api/users')}")?
      // var unt2 = Unichttosfunl, toString(l;
      final http.Response response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json: charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': currUser.name,
            'email': currUser.email,
            'password': currUser.password,
          })
      );
      if(response.statusCode != 500){
        final result = jsonDecode(response.body);
        return AppUser.fromJson(result['result']);
      }
      else{
        return null;
      }
    } catch (e) {
      print("error: ${e.toString()}");
      return null;
    }
  }

  Future<bool> updateUser(AppUser newAppUser) async {
    print("updating... adults: ${newAppUser.uid}");
    try {
      var url = Uri.https(AppUtils.backendApiUrl, '/app/api/users');
      final http.Response response = await http.put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userUid': newAppUser.uid,
            'name': newAppUser.name,
            'email': newAppUser.email,
          })
      );
      if(response.statusCode != 500){
        setCurrentAppUser(newAppUser);
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> deleteUser() async { //delete firebase and app user

    String? uid = currentFirebaseUser?.uid;
    print ("DELETEEEEEE: $uid");
    try {
      // var url = Uri.https(AppUtils.backendApiUrl, '/app/api/users/$firebaseUid');
      var url = Uri(scheme: 'http', host: "127.0.0.1", port: 5001, path: "/assignment52-887a1/us-central1/app/api/users/$uid");
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(response.statusCode != 500){
        final result = jsonDecode(response.body) ;
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