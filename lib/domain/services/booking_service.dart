import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel/domain/models/booking_models.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Booking>> fetchBookingsForUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      QuerySnapshot snapshot = await _firestore
          .collection('room_bookings')
          .where('bookedBy', isEqualTo: user.email)
          .get();

      List<Booking> bookings = snapshot.docs
          .map((doc) => Booking.fromDocument(doc))
          .toList();

      return bookings;
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}
