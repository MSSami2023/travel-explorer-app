import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  // Password ko SHA-256 se hash karta hai
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Signup: naya user save karta hai
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = usersJson != null
        ? Map<String, dynamic>.from(jsonDecode(usersJson))
        : {};

    if (users.containsKey(email.toLowerCase())) {
      throw Exception('Email already registered');
    }

    users[email.toLowerCase()] = {
      'name': name,
      'email': email.toLowerCase(),
      'password': _hashPassword(password),
      'created_at': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_currentUserKey, email.toLowerCase());
    return true;
  }

  // Login: credentials verify karta hai
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) {
      throw Exception('No account found. Please sign up first.');
    }

    final Map<String, dynamic> users =
    Map<String, dynamic>.from(jsonDecode(usersJson));
    final user = users[email.toLowerCase()];

    if (user == null) {
      throw Exception('No account found with this email');
    }

    if (user['password'] != _hashPassword(password)) {
      throw Exception('Incorrect password');
    }

    await prefs.setString(_currentUserKey, email.toLowerCase());
    return true;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Current logged-in user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);
    if (email == null) return null;

    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    final Map<String, dynamic> users =
    Map<String, dynamic>.from(jsonDecode(usersJson));
    return users[email];
  }

  // Already logged in hai?
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey) != null;
  }

  // Onboarding dekh chuka hai?
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }
}