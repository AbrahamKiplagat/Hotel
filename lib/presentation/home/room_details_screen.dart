import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/room_model.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  const RoomDetailsScreen({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Room Type: ${room.type}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text('Rate: \$${room.rate.toStringAsFixed(2)}'),
                  const SizedBox(height: 8.0),
                  Text(
                    'Availability: ${room.isAvailable ? 'Available' : 'Not Available'}',
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: room.isAvailable
                        ? () {
                            // Handle "Book Now" button press
                            _bookRoom(context);
                          }
                        : null,
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _bookRoom(BuildContext context) async {
    try {
      // Add the room booking to Firestore
      await FirebaseFirestore.instance.collection('room_bookings').add({
        'roomType': room.type,
        'rate': room.rate,
        'timestamp': DateTime.now(), // Optional: add a timestamp for the booking
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room booked successfully!'),
        ),
      );
    } catch (error) {
      // Show an error message if booking fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book room: $error'),
        ),
      );
    }
  }
}
