import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/admin_model.dart';

class AdminService {
  final CollectionReference _adminCollection = FirebaseFirestore.instance.collection('admins');

  Future<void> setAdmin(AdminModel admin) async {
    try {
      await _adminCollection.doc(admin.id).set(admin.toJson());
    } catch (error) {
      throw error;
    }
  }

  Future<AdminModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _adminCollection.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        var adminData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (adminData['password'] == password) {
          return AdminModel.fromJson(adminData);
        } else {
          throw 'Invalid password';
        }
      } else {
        throw 'Admin not found';
      }
    } catch (error) {
      throw error;
    }
  }
}

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();
  AdminModel? _user;
  String? _errorMessage;

  AdminModel? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> setAdmin(AdminModel admin) async {
    try {
      await _adminService.setAdmin(admin);
    } catch (error) {
      _errorMessage = "An error occurred while adding admin details: $error";
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      AdminModel? createdUser = await _adminService.signInWithEmailAndPassword(email, password);
      if (createdUser != null) {
        _user = createdUser;
        _errorMessage = null;
        Navigator.pushNamed(context, '/addHotels'); // Navigate to '/addHotels' screen after successful sign-in
      } else {
        _errorMessage = "An error occurred while signing in.";
      }
    } catch (error) {
      _errorMessage = "An error occurred during sign-in: $error";
    } finally {
      notifyListeners();
    }
  }
}
