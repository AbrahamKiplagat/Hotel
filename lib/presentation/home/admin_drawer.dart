import 'package:flutter/material.dart';

import './payment_graph_screen.dart';
class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text(
              'Admin Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('User Bookings'),
            onTap: () {
              Navigator.pushNamed(context, '/userdetails');
            },
          ),
          ListTile(
            leading: Icon(Icons.hotel),
            title: Text('Add Hotels'),
            onTap: () {
              Navigator.pushNamed(context, '/addHotels');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment), // Icon for the payment graph
            title: Text('Payment Graph'), // Title for the payment graph
            onTap: () {
              
               Navigator.pushNamed(context, '/payment-graph'); // Navigate to PaymentGraphScreen
              
            },
          ),
        ],
      ),
    );
  }
}
