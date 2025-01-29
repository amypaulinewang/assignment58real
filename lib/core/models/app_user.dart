import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String location;
  final String password;


  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.location,
    required this.password,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    print("JSON: $json");
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      location: json['location'],
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'location': location,
      'password': password,
    };
  }
}