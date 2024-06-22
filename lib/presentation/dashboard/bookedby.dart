import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookings'),
      ),
      body: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
        future: fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data!['hotelBookings']!.isEmpty &&
                  snapshot.data!['roomBookings']!.isEmpty)) {
            return Center(child: Text('No bookings found.'));
          } else {
            List<QueryDocumentSnapshot> hotelBookings =
                snapshot.data!['hotelBookings']!;
            List<QueryDocumentSnapshot> roomBookings =
                snapshot.data!['roomBookings']!;
            double totalAmount =
                calculateTotalAmount(hotelBookings, roomBookings);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: hotelBookings.length + roomBookings.length,
                    itemBuilder: (context, index) {
                      if (index < hotelBookings.length) {
                        var booking =
                            hotelBookings[index].data() as Map<String, dynamic>;
                        return BookingCard(
                          booking: booking,
                          bookingId: hotelBookings[index].id,
                          collection: 'hotelBookings',
                          onDelete: () => _deleteBooking(
                              hotelBookings[index].id, 'hotelBookings'),
                        );
                      } else {
                        var booking = roomBookings[index - hotelBookings.length]
                            .data() as Map<String, dynamic>;
                        return RoomBookingCard(
                          booking: booking,
                          bookingId: roomBookings[index - hotelBookings.length].id,
                          collection: 'roomBookings',
                          onDelete: () => _deleteBooking(
                              roomBookings[index - hotelBookings.length].id, 'roomBookings'),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Total Amount: KSH ${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle pay now action
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Pay Now button pressed')));
                        },
                        child: Text('Pay Now'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  double calculateTotalAmount(
      List<QueryDocumentSnapshot> hotelBookings,
      List<QueryDocumentSnapshot> roomBookings) {
    double totalAmount = 0.0;

    for (var booking in hotelBookings) {
      var data = booking.data() as Map<String, dynamic>;
      if (data.containsKey('amount')) {
        totalAmount += data['amount'] ?? 0.0;
      }
    }

    for (var booking in roomBookings) {
      var data = booking.data() as Map<String, dynamic>;
      if (data.containsKey('amount')) {
        totalAmount += data['amount'] ?? 0.0;
      }
    }

    return totalAmount;
  }

  Future<Map<String, List<QueryDocumentSnapshot>>> fetchBookings() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    QuerySnapshot hotelBookingsSnapshot = await FirebaseFirestore.instance
        .collection('hotelBookings')
        .where('userId', isEqualTo: user.uid)
        .get();

    QuerySnapshot roomBookingsSnapshot = await FirebaseFirestore.instance
        .collection('roomBookings')
        .where('userId', isEqualTo: user.uid)
        .get();

    return {
      'hotelBookings': hotelBookingsSnapshot.docs,
      'roomBookings': roomBookingsSnapshot.docs,
    };
  }

  Future<void> _deleteBooking(String bookingId, String collection) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(bookingId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic>? booking;
  final String bookingId;
  final String collection;
  final VoidCallback onDelete;

  BookingCard({
    required this.booking,
    required this.bookingId,
    required this.collection,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hotel: ${booking?['hotelName'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Amount: KSH ${booking?['amount'] ?? 'Unknown'}'),
            Text('Display Name: ${booking?['displayName'] ?? 'Unknown'}'),
            Text('Email: ${booking?['email'] ?? 'Unknown'}'),
            Text('Phone: ${booking?['phoneNumber'] ?? 'Unknown'}'),
            Text('Timestamp: ${booking?['timestamp']?.toDate() ?? 'Unknown'}'),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomBookingCard extends StatelessWidget {
  final Map<String, dynamic>? booking;
  final String bookingId;
  final String collection;
  final VoidCallback onDelete;

  RoomBookingCard({
    required this.booking,
    required this.bookingId,
    required this.collection,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hotel: ${booking?['hotelName'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Room: ${booking?['roomName'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Text('Amount: KSH ${booking?['amount'] ?? 'Unknown'}'),
            Text('Display Name: ${booking?['displayName'] ?? 'Unknown'}'),
            Text('Email: ${booking?['email'] ?? 'Unknown'}'),
            Text('Phone: ${booking?['phoneNumber'] ?? 'Unknown'}'),
            Text('Timestamp: ${booking?['timestamp']?.toDate() ?? 'Unknown'}'),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
