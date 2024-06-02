import 'package:flutter/material.dart';
import 'package:hotel/domain/services/auth_service.dart';
import 'package:hotel/domain/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> createUserWithEmailAndPassword(BuildContext context, String email, String password, String displayName, String phoneNumber) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userCredential = await _authService.createUserWithEmailAndPassword(context, email, hashedPassword, displayName, phoneNumber);
      if (userCredential != null) {
        _user = userCredential;
        _errorMessage = null;
        _isLoggedIn = true;
        notifyListeners();
      } else {
        _errorMessage = "An error occurred while creating the user.";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      notifyListeners();
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserModel? signedInUser = await _authService.signInWithEmailAndPassword(context, email, password);
      if (signedInUser != null) {
        _user = signedInUser;
        _errorMessage = null;
        _isLoggedIn = true;
        notifyListeners();
      } else {
        _errorMessage = "Invalid email or password.";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut(context);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      _isLoggedIn = false;
      _user = null; // Clear the user object
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      notifyListeners();
    }
  }

  String _hashPassword(String password) {
    // Implement your password hashing algorithm here
    return password; // For demonstration, returning the password as is
  }
}
