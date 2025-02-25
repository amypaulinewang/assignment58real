import 'package:flutter/material.dart';

class AppUtils{
  static const String backendApiUrl = "us-central1-assignment52-887a1.cloudfunctions.net";
  static var textFieldDecoration = const InputDecoration(
      hintText: 'Enter a value',
      hintStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(color: Colors.black),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 3.0),
      )
  );
}