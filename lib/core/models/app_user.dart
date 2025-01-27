import 'package:flutter/material.dart';

@immutable
class AppUser {
  late String uid;
  late String name;
  late String email;
  late String password;

  AppUser ({required this.uid, required this.name, required this.email, required this.password});

  AppUser.fromJson(Map<String, dynamic> json) {
    print("JSON: $json");
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    password = "";
  }
}