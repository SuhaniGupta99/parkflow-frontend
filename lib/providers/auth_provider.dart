import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? role;

  bool get isLoggedIn => token != null;

  Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "token",
      value,
    );

    token = value;

    notifyListeners();
  }

  Future<void> saveRole(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "role",
      value,
    );

    role = value;

    notifyListeners();
  }

  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    role = prefs.getString("role");

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    token = null;
    role = null;

    notifyListeners();
  }
}