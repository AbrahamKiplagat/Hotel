import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Bookings'),
        ),
        body: Center(
          child: Text('You need to be logged in to view bookings.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      backgroundColor: Colors.purple[100], // Set the background color here
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('room_bookings')
            .where('bookedBy', isEqualTo: user.email) // Filter by current user's email
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No bookings available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              var bookedBy = booking['bookedBy'];
              var rate = booking['rate'];
              var roomType = booking['roomType'];
              var timestamp = booking['timestamp'];

              // Convert timestamp to DateTime object
              var dateTime = (timestamp as Timestamp).toDate();

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booked by: $bookedBy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Rate: $rate',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Room Type: $roomType',
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Timestamp: $dateTime',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
