import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/hotel_model.dart';
import 'package:hotel/domain/models/room_model.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Hotel hotel;
  final Room room;

  const RoomDetailsScreen({Key? key, required this.hotel, required this.room}) : super(key: key);

  Future<void> _saveData(BuildContext context) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference hotels = FirebaseFirestore.instance.collection('hotels');
      
      // Convert hotel ID to String
      String hotelId = hotel.id.toString();

      // Add the hotel data to Firestore
      await hotels.doc(hotelId).set(hotel.toJson());

      // Add the room data to Firestore
      CollectionReference rooms = hotels.doc(hotelId).collection('rooms');
      await rooms.add(room.toJson());

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel and room data saved successfully')),
      );
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save hotel and room data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        actions: [
          IconButton(
            onPressed: () => _saveData(context),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hotel Name: ${hotel.name}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Room Type: ${room.type}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Rate: \$${room.rate.toStringAsFixed(2)}'),
            const SizedBox(height: 8.0),
            Text('Availability: ${room.isAvailable ? 'Available' : 'Not Available'}'),
          ],
        ),
      ),
    );
  }
}
