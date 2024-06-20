import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_model.dart';  // Ensure this import is correct based on your directory structure

class Booking {
  final String id; // Add id field
  final String bookedBy;  // Email
  final DateTime timestamp;
  final String hotelName;
  final String phoneNumber;
  final double totalAmount;
  final bool isPaid;
  final Room room;

  Booking({
    required this.id, // Initialize id in constructor
    required this.bookedBy,
    required this.timestamp,
    required this.hotelName,
    required this.phoneNumber,
    required this.totalAmount,
    required this.isPaid,
    required this.room,
  });

  // Deserialize Firestore document snapshot to Booking object
  factory Booking.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Booking(
      id: doc.id, // Assign document id to booking id
      bookedBy: data['bookedBy'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      hotelName: data['hotelName'],
      phoneNumber: data['phoneNumber'],
      totalAmount: data['totalAmount'],
      isPaid: data['isPaid'],
      room: Room.fromJson(data['room']),
    );
  }

  // Serialize Booking object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookedBy': bookedBy,
      'timestamp': timestamp.toIso8601String(),
      'hotelName': hotelName,
      'phoneNumber': phoneNumber,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
      'room': room.toJson(),
    };
  }

  // Deserialize JSON to Booking object
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookedBy: json['bookedBy'],
      timestamp: DateTime.parse(json['timestamp']),
      hotelName: json['hotelName'],
      phoneNumber: json['phoneNumber'],
      totalAmount: json['totalAmount'],
      isPaid: json['isPaid'],
      room: Room.fromJson(json['room']),
    );
  }
}

