import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16), // Added some spacing
            const Text('Hotel Booking Card'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signUp');
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
