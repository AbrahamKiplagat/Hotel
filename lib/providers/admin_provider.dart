import 'package:flutter/material.dart';
import 'package:hotel/domain/services/admin_service.dart';
import '../domain/models/admin_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  AdminModel? _user;
  String? _errorMessage;

  AdminModel? get user => _user;
  String? get errorMessage => _errorMessage;

  Future setAdmin(admin) async {
    await _adminService.setAdmin(admin);
  }

  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      AdminModel? createdUser = await _adminService.signInWithEmailAndPassword(
          context, AdminModel(email: email, password: password));
      if (createdUser != null) {
        _user = createdUser;
        _errorMessage = null;
      } else {
        _errorMessage = "An error occurred while creating the user.";
      }
    } catch (error) {
      // Handle any errors during sign-in
      _errorMessage = "An error occurred during sign-in: $error";
    } finally {
      // Notify listeners regardless of the outcome
      notifyListeners();
    }
  }
}