import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/presentation/dashboard/no_bookings.dart';
import 'package:hotel/providers/bookings_provider.dart';
import 'package:hotel/domain/services/mpesa_service.dart';
import 'package:hotel/domain/models/booking_models.dart';

class BookingDisplayScreen extends StatelessWidget {
  final MpesaService mpesaService = MpesaService();

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

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Amount by Email:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookingsProvider.totalAmountByEmail.length,
                    itemBuilder: (context, index) {
                      var entry = bookingsProvider.totalAmountByEmail.entries.elementAt(index);
                      return TotalAmountCard(
                        email: entry.key,
                        totalAmount: entry.value,
                        bookings: bookingsProvider.bookings
                            .where((booking) => booking.bookedBy == entry.key)
                            .toList(),
                        mpesaService: mpesaService,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TotalAmountCard extends StatelessWidget {
  final String email;
  final double totalAmount;
  final List<Booking> bookings;
  final MpesaService mpesaService;

  const TotalAmountCard({
    required this.email,
    required this.totalAmount,
    required this.bookings,
    required this.mpesaService,
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
            Text(
              'Email: $email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Total Amount: $totalAmount'),
            ...bookings.map((booking) {
              final dateTime = booking.timestamp.toDate();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text('Room Type: ${booking.roomType}'),
                  Text('Rate: ${booking.rate}'),
                  Text('Timestamp: $dateTime'),
                ],
              );
            }).toList(),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () async {
                await _showPaymentDialog(context, totalAmount.toString());
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog(BuildContext context, String amount) async {
    TextEditingController phoneNumberController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16.0),
              Text('Amount: $amount'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = phoneNumberController.text;
                _initiatePayment(context, phoneNumber, double.parse(amount));
              },
              child: Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initiatePayment(BuildContext context, String phoneNumber, double amount) async {
    // Implement your payment initiation logic here
    try {
      // Example code to initiate payment
      // Replace with your actual payment initiation code
      print('Payment initiated for $amount to $phoneNumber');
      Navigator.pop(context); // Close the dialog after successful payment
      // Show success message or navigate to a success screen
    } catch (e) {
      // Handle payment failure
      print('Error initiating payment: $e');
    }
  }
}
