import 'package:flutter/material.dart';
import 'package:hotel/presentation/authentication/widgets/logo.dart';
import 'package:hotel/providers/admin_provider.dart';
import 'package:provider/provider.dart';

// import '../../providers/admin_provider.dart';

class AdminScreen extends StatelessWidget {
  // ignore: use_super_parameters
  AdminScreen({Key? key}) : super(key: key); // Fix the constructor syntax

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: Center( // Center the form horizontally and vertically
        child: Container(
          width: 450, // Set the width of the container
          decoration: BoxDecoration(
            color: Colors.white, // Set purple color as the background
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the form vertically
              children: [
                const LogoWidget(),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    try {
                      // SignInWithEmailAndPassword should return a Future
                      await context
                          .read<AdminProvider>()
                          .signInWithEmailAndPassword(context, email, password); // Remove context parameter
                      // Navigate only if the sign-in is successful
                      Navigator.pushNamed(context, '/addHotels');
                    } catch (error) {
                      // Handle sign-in errors here
                      print('Sign-in error: $error');
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}