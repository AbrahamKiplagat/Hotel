import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/room_model.dart'; // Update import as per your directory structure

class Booking {
  final String id; // Assuming you have an id for each booking
  final String bookedBy;
  final String roomType;
  final double rate;
  final DateTime timestamp; // Assuming timestamp is stored as DateTime
  // Add other necessary fields such as hotelName, phoneNumber, totalAmount, isPaid if needed

  Booking({
    required this.id,
    required this.bookedBy,
    required this.roomType,
    required this.rate,
    required this.timestamp,
    // Add other necessary parameters in the constructor
  });

  factory Booking.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Booking(
      id: doc.id,
      bookedBy: data['bookedBy'],
      roomType: data['roomType'],
      rate: data['rate'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      // Initialize other fields from data
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookedBy': bookedBy,
      'roomType': roomType,
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
      // Convert other fields to JSON format
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookedBy: json['bookedBy'],
      roomType: json['roomType'],
      rate: json['rate'],
      timestamp: DateTime.parse(json['timestamp']),
      // Initialize other fields from JSON data
    );
  }
}
