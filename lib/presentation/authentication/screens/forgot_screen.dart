import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A screen that provides users the ability to reset their password.
/// Users can enter their email address to receive a password reset link.
class ForgotPasswordScreen extends StatelessWidget {
  // Initialize a TextEditingController to handle the input for email address.
  final TextEditingController _emailController = TextEditingController();

  // Constructor for ForgotPasswordScreen.
  ForgotPasswordScreen({Key? key}) : super(key: key);  // Standard constructor for a StatelessWidget.

  /// Sends a password reset email to the provided email address.
  /// Shows a success message upon successful sending or an error message on failure.
  Future<void> _resetPassword(BuildContext context) async {
    try {
      // Attempt to send the password reset email using Firebase Auth.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      // Show a success snack bar if the email is sent successfully.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent.")),
      );
    } catch (e) {
      // Catch any errors and display an error snack bar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send password reset email: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for the forgot password screen.
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),  // Title of the AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding for all sides set to 16.0.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center the column in the middle of the screen.
          children: [
            // Text field for user to enter their email address.
            TextField(
              controller: _emailController,  // Connects the text field to the email controller.
              decoration: const InputDecoration(
                labelText: "Email",  // Label text that appears above the TextField when it is in focus.
              ),
            ),
            const SizedBox(height: 20),  // Provides vertical spacing between the email field and the button.
            // Button that triggers the password reset process when pressed.
            ElevatedButton(
              onPressed: () => _resetPassword(context),  // Calls the _resetPassword method when tapped.
              child: const Text("Send Password Reset Email"),  // Text displayed inside the button.
            ),
          ],
        ),
      ),
    );
  }
}
