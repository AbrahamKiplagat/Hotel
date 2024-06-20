// hotel_model.dart

import 'room_model.dart'; // Ensure Room import is correct

class Hotel {
  final int id;
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final List<Room> rooms;
  final double amount;  // Add amount field for the hotel

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.rooms,
    required this.amount,  // Include amount in the constructor
  });

  // Serialize data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
      'amount': amount,  // Include amount in serialization
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  // Deserialize JSON to data
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      rating: json['rating'] ?? 0.0,
      imageUrl: json['imageUrl'],
      amount: json['amount'],  // Deserialize amount
      rooms: List<Room>.from(json['rooms'].map((room) => Room.fromJson(room))),
    );
  }
}
