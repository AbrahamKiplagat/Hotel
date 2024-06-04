import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// BookingsProvider is a ChangeNotifier that handles fetching bookings and managing state
class BookingsProvider extends ChangeNotifier {
  // Private variables to store bookings, loading state, and error message
  List<QueryDocumentSnapshot> _bookings = [];
  bool _isLoading = true;
  String? _error;

  // Public getters to access the private variables
  List<QueryDocumentSnapshot> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Method to fetch bookings from Firestore
  void fetchBookings() async {
    try {
      // Set loading state to true and clear any previous errors
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If user is not logged in, set error message and loading state
        _error = 'User not logged in';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch bookings from Firestore where 'bookedBy' field matches the user's email
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('room_bookings')
          .where('bookedBy', isEqualTo: user.email)
          .get();

      // Update bookings with fetched data
      _bookings = snapshot.docs;
    } catch (e) {
      // Set error message in case of an exception
      _error = 'Error: $e';
    } finally {
      // Set loading state to false and notify listeners
      _isLoading = false;
      notifyListeners();
    }
  }
}
