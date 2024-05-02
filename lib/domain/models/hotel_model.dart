import 'package:hotel/domain/models/room_model.dart';

class Hotel {
  final int id;
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final List<Room> rooms;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.rooms,
  });

  //serialize data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  //deserialize JSON to data
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      rating: json['rating'],
      imageUrl: json['imageUrl'],
      rooms: List<Room>.from(json['rooms'].map((room) => Room.fromJson(room))),
    );
  }
}
