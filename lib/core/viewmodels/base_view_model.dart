import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class BaseViewModel extends ChangeNotifier {
  late BuildContext context;

  late AuthenticationProvider authenticationProvider;

  BaseViewModel({required this.context}) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
  }
}