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

  Future<UserModel?> createUserWithEmailAndPassword(BuildContext context, String email, String password, String displayName,String phoneNumber) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userCredential = await _authService.createUserWithEmailAndPassword(context, email, hashedPassword, displayName, phoneNumber);
      if (userCredential != null) {
        _user = userCredential;
        _errorMessage = null;
        _isLoggedIn = true;
        notifyListeners();
        return _user;
      } else {
        _errorMessage = "An error occurred while creating the user.";
        notifyListeners();
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    UserModel? signedInUser = await _authService.signInWithEmailAndPassword(context, email, password);
    if (signedInUser != null) {
      _user = signedInUser;
      _errorMessage = null;
      _isLoggedIn = true;
      notifyListeners();
    } else {
      _errorMessage = "An error occurred while signing in.";
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _authService.signOut(context);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    _isLoggedIn = false;
    notifyListeners();
  }

  String _hashPassword(String password) {
    // Add your password hashing logic here
    return password; // For demonstration, returning the password as is
  }
}
