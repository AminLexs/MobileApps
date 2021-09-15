import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  bool isLoggedIn = false;

  void toggleIsLoggedIn() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }
}