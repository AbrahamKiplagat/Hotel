import 'package:flutter/material.dart';

class HotelRoomsScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;

  HotelRoomsScreen({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel['name']),
      ),
      body: ListView(
        children: [
          _buildHotelCard(),
          SizedBox(height: 16),
          ..._buildRoomCards(),
        ],
      ),
    );
  }

  Widget _buildHotelCard() {
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
            Text(
              'Rating: ${hotel['rating']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Amount: ${hotel['amount']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRoomCards() {
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
                Text(
                  'Rate: ${room['rate']}',
                  style: TextStyle(fontSize: 16),
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
              ],
            ),
          ),
        ),
      );
    }
    return roomCards;
  }
}
