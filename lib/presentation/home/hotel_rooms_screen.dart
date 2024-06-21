import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hotel/providers/auth_provider.dart';

class HotelRoomsScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;

  HotelRoomsScreen({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel['name']),
      ),
      body: ListView(
        children: [
          _buildHotelCard(context, user?.uid),
          SizedBox(height: 16),
          ..._buildRoomCards(context, user?.uid),
        ],
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, String? userId) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hotel Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${hotel['location']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Rating: ',
                  style: TextStyle(fontSize: 16),
                ),
                _buildStarRating(hotel['rating']),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Amount: ${hotel['amount']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: userId != null ? () => _bookHotel(context, userId) : null,
              child: Text('Book Hotel'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRoomCards(BuildContext context, String? userId) {
    List<Widget> roomCards = [];
    for (int i = 0; i < hotel['rooms'].length; i++) {
      var room = hotel['rooms'][i];
      roomCards.add(
        Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room ${i + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Type: ${room['type']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Rating: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    _buildStarRating(room['rate']),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Amount: ${room['amount']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Available: ${room['isAvailable'] ? 'Yes' : 'No'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: userId != null ? () => _bookRoom(context, room, userId) : null,
                  child: Text('Book Room'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return roomCards;
  }

  Widget _buildStarRating(dynamic rating) {
    if (rating == null) {
      return Text('N/A');
    }

    double ratingValue = double.tryParse(rating.toString()) ?? 0.0;

    int fullStars = ratingValue.floor();
    int halfStars = (ratingValue - fullStars >= 0.5) ? 1 : 0;
    int emptyStars = 5 - fullStars - halfStars;

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber));
    }
    if (halfStars == 1) {
      stars.add(Icon(Icons.star_half, color: Colors.amber));
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.amber));
    }

    return Row(children: stars);
  }

  void _bookHotel(BuildContext context, String userId) async {
    final bookingData = {
      'hotelId': hotel['id'],
      'hotelName': hotel['name'],
      'userId': userId,
      'amount': hotel['amount'],
      'timestamp': FieldValue.serverTimestamp(),
      'userDetails': {
        'displayName': Provider.of<AuthProvider>(context, listen: false).user?.displayName,
        'email': Provider.of<AuthProvider>(context, listen: false).user?.email,
        'phoneNumber': Provider.of<AuthProvider>(context, listen: false).user?.phoneNumber,
      },
    };

    try {
      await FirebaseFirestore.instance.collection('hotelBookings').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel booked successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book hotel: $e')),
      );
    }
  }

  void _bookRoom(BuildContext context, Map<String, dynamic> room, String userId) async {
    final bookingData = {
      'roomId': room['id'],
      'roomName': room['type'], // Assuming the room type is used as the room name
      'hotelName': hotel['name'],
      'userId': userId,
      'amount': room['amount'],
      'timestamp': FieldValue.serverTimestamp(),
      'userDetails': {
        'displayName': Provider.of<AuthProvider>(context, listen: false).user?.displayName,
        'email': Provider.of<AuthProvider>(context, listen: false).user?.email,
        'phoneNumber': Provider.of<AuthProvider>(context, listen: false).user?.phoneNumber,
      },
    };

    try {
      await FirebaseFirestore.instance.collection('roomBookings').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room booked successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book room: $e')),
      );
    }
  }
}
