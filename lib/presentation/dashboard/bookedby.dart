import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel/presentation/dashboard/no_bookings.dart';
// Import the NoBookingsScreen class

class BookingDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: Text('Your Bookings'),
      ),
      backgroundColor: Colors.purple[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('room_bookings')
            .where('bookedBy', isEqualTo: user.email) // Change this to 'uid' if using UID
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
            return NoBookingsScreen(); // Display NoBookingsScreen if no bookings available
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking = snapshot.data!.docs[index];
              var bookedBy = booking['bookedBy'];
              var rate = booking['rate'];
              var roomType = booking['roomType'];
              var timestamp = booking['timestamp'];

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
                      Text('Rate: $rate'),
                      SizedBox(height: 8.0),
                      Text('Room Type: $roomType'),
                      SizedBox(height: 8.0),
                      Text('Timestamp: $dateTime'),
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
