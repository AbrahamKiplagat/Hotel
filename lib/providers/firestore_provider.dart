import 'package:flutter/material.dart';
import 'package:hotel/domain/models/admin_models.dart'; // Update import
import 'package:hotel/domain/models/user_model.dart';
import 'package:hotel/domain/services/firestore_service.dart';

class FirestoreProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  Future<void> fetchBookings() async {
    _bookings = await _firestoreService.getBookings();
    notifyListeners();
  }

  Future<UserModel?> fetchUserDetails(String email) async {
    return await _firestoreService.getUserByEmail(email);
  }
}
