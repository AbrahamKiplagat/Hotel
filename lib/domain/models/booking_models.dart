import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookedBy;
  final double rate;
  final String roomType;
  final Timestamp timestamp;

  Booking({
    required this.bookedBy,
    required this.rate,
    required this.roomType,
    required this.timestamp,
  });

  factory Booking.fromDocument(DocumentSnapshot doc) {
    return Booking(
      bookedBy: doc['bookedBy'],
      rate: doc['rate'],
      roomType: doc['roomType'],
      timestamp: doc['timestamp'],
    );
  }
}
