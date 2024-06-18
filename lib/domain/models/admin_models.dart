// booking_models.dart
import 'room_model.dart';  // Ensure this is correct based on your directory structure

class Booking {
  final String bookedBy;  // Email
  final DateTime timestamp;
  final String hotelName;
  final String phoneNumber;
  final double totalAmount;
  final bool isPaid;
  final Room room;

  Booking({
    required this.bookedBy,
    required this.timestamp,
    required this.hotelName,
    required this.phoneNumber,
    required this.totalAmount,
    required this.isPaid,
    required this.room,
  });

  //serialize data to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookedBy': bookedBy,
      'timestamp': timestamp.toIso8601String(),
      'hotelName': hotelName,
      'phoneNumber': phoneNumber,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
      'room': room.toJson(),
    };
  }

  //deserialize JSON to data
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
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
