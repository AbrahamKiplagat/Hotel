import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel/presentation/dashboard/no_bookings.dart';
import 'package:hotel/presentation/dashboard/bookings_provider.dart'; // Import the BookingsProvider class

class BookingDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Initialize the BookingsProvider and fetch bookings when the widget is built
      create: (context) => BookingsProvider()..fetchBookings(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
        ),
        backgroundColor: Colors.purple[100],
        body: Consumer<BookingsProvider>(
          // Consumer listens to BookingsProvider and rebuilds the UI when there are changes
          builder: (context, bookingsProvider, child) {
            if (bookingsProvider.isLoading) {
              // Show a loading indicator while bookings are being fetched
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (bookingsProvider.error != null) {
              // Show an error message if there's an error fetching bookings
              return Center(
                child: Text(bookingsProvider.error!),
              );
            }

            if (bookingsProvider.bookings.isEmpty) {
              // Show the NoBookingsScreen if there are no bookings available
              return NoBookingsScreen();
            }

            // Show the list of bookings
            return ListView.builder(
              itemCount: bookingsProvider.bookings.length,
              itemBuilder: (context, index) {
                var booking = bookingsProvider.bookings[index];
                return BookingCard(
                  bookedBy: booking['bookedBy'],
                  rate: booking['rate'].toString(), // Convert rate to String
                  roomType: booking['roomType'],
                  timestamp: booking['timestamp'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// BookingCard is a stateless widget that displays individual booking details
class BookingCard extends StatelessWidget {
  final String bookedBy;
  final String rate;
  final String roomType;
  final Timestamp timestamp;

  // Constructor to initialize the BookingCard with booking details
  const BookingCard({
    required this.bookedBy,
    required this.rate,
    required this.roomType,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Convert timestamp to DateTime
    final dateTime = timestamp.toDate();

    // Card widget to display booking details
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display booked by information
            Text(
              'Booked by: $bookedBy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Display rate information
            Text('Rate: $rate'),
            SizedBox(height: 8.0),
            // Display room type information
            Text('Room Type: $roomType'),
            SizedBox(height: 8.0),
            // Display timestamp information
            Text('Timestamp: $dateTime'),
          ],
        ),
      ),
    );
  }
}
