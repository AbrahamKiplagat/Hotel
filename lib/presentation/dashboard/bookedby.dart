import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/presentation/dashboard/no_bookings.dart';
import 'package:hotel/providers/bookings_provider.dart';
import 'package:hotel/domain/models/booking_models.dart';

class BookingDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingsProvider()..fetchBookings(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
        ),
        backgroundColor: Colors.purple[100],
        body: Consumer<BookingsProvider>(
          builder: (context, bookingsProvider, child) {
            if (bookingsProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (bookingsProvider.error != null) {
              return Center(
                child: Text(bookingsProvider.error!),
              );
            }

            if (bookingsProvider.bookings.isEmpty) {
              return NoBookingsScreen();
            }

            return ListView.builder(
              itemCount: bookingsProvider.bookings.length,
              itemBuilder: (context, index) {
                var booking = bookingsProvider.bookings[index];
                return BookingCard(
                  bookedBy: booking.bookedBy,
                  rate: booking.rate,
                  roomType: booking.roomType,
                  timestamp: booking.timestamp,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String bookedBy;
  final double rate;
  final String roomType;
  final Timestamp timestamp;

  const BookingCard({
    required this.bookedBy,
    required this.rate,
    required this.roomType,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = timestamp.toDate();

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
  }
}
