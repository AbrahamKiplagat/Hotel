import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import './checkout_view.dart';
import './no_bookings.dart';
import 'package:url_launcher/url_launcher.dart';
import './sendemail.dart';

// Import the NoBookingsScreen widget
// import 'no_bookings_screen.dart';

class BookingDisplayScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent, Colors.yellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
          future: fetchBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                (snapshot.data!['hotelBookings']!.isEmpty &&
                    snapshot.data!['roomBookings']!.isEmpty)) {
              // Display NoBookingsScreen when no bookings are found
              return NoBookingsScreen();
            } else {
              List<QueryDocumentSnapshot> hotelBookings = snapshot.data!['hotelBookings']!;
              List<QueryDocumentSnapshot> roomBookings = snapshot.data!['roomBookings']!;
              double totalAmount = calculateTotalAmount(hotelBookings, roomBookings);
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: hotelBookings.length + roomBookings.length,
                      itemBuilder: (context, index) {
                        if (index < hotelBookings.length) {
                          var booking = hotelBookings[index].data() as Map<String, dynamic>;
                          return BookingCard(
                            booking: booking,
                            bookingId: hotelBookings[index].id,
                            collection: 'hotelBookings',
                            onDelete: () => _deleteBooking(hotelBookings[index].id, 'hotelBookings'),
                          );
                        } else {
                          var booking = roomBookings[index - hotelBookings.length].data() as Map<String, dynamic>;
                          return RoomBookingCard(
                            booking: booking,
                            bookingId: roomBookings[index - hotelBookings.length].id,
                            collection: 'roomBookings',
                            onDelete: () => _deleteBooking(roomBookings[index - hotelBookings.length].id, 'roomBookings'),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Total Amount: KSH ${totalAmount.toInt()}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Enter Phone Number',
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            String phoneNumber = _phoneNumberController.text.trim();
                            if (phoneNumber.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter a phone number')));
                              return;
                            }

                            // Remove any non-digit characters from the phone number
                            phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

                            // Check if the phone number starts with '0', prepend '+254'
                            if (phoneNumber.startsWith('0')) {
                              phoneNumber = '+254${phoneNumber.substring(1)}';
                            }

                            // Start Paystack transaction
                            await startPaystackPayment(context, totalAmount, phoneNumber);
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
      ),
    );
  }

  double calculateTotalAmount(List<QueryDocumentSnapshot> hotelBookings, List<QueryDocumentSnapshot> roomBookings) {
    double totalAmount = 0;

    for (var booking in hotelBookings) {
      var data = booking.data() as Map<String, dynamic>;
      if (data.containsKey('amount')) {
        totalAmount += data['amount'] ?? 0;
      }
    }

    for (var booking in roomBookings) {
      var data = booking.data() as Map<String, dynamic>;
      if (data.containsKey('amount')) {
        totalAmount += data['amount'] ?? 0;
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

Future<void> startPaystackPayment(BuildContext context, double totalAmount, String phoneNumber) async {
  int amountInKobo = (totalAmount * 100).toInt();  // Convert to kobo

  try {
    var requestBody = json.encode({
      'amount': amountInKobo,
      'email': FirebaseAuth.instance.currentUser!.email!,
      'metadata': {
        'phoneNumber': phoneNumber,
      },
    });

    var headers = {
      'Authorization': 'Bearer sk_test_48e846f7f8dc3a8a2bba852a4b1c8c3ab1cb20d5',
      'Content-Type': 'application/json',
    };

    var response = await http.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var authorizationUrl = responseData['data']['authorization_url'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment initiated')));

      await launch(authorizationUrl);

      // Save payment details to Firestore after the payment is successful
      await savePaymentDetails(totalAmount, phoneNumber);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaystackPaymentWebView(authorizationUrl: authorizationUrl)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to initiate payment')));
    }
  } catch (e) {
    print('Payment Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Error: $e')));
  }
}

Future<void> savePaymentDetails(double totalAmount, String phoneNumber) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('No user logged in');
  }

  await FirebaseFirestore.instance.collection('payments').add({
    'userId': user.uid,
    'email': user.email,
    'phoneNumber': phoneNumber,
    'amount': totalAmount,
    'timestamp': FieldValue.serverTimestamp(),
  });
  /***
   * 
   * 
   * 
   */
   await sendPaymentNotificationEmail(user.email!, totalAmount, phoneNumber);
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
