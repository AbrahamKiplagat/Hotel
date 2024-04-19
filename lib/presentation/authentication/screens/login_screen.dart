import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:hotel/presentation/authentication/widgets/logo.dart';
import 'package:hotel/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers to manage the inputs of email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Form key to manage form state for validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // State variables to manage loading status and password visibility.
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validates the email format using a regular expression.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  // Function to handle login when the login button is pressed.
  void _login() async {
    // Validate the form before proceeding.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading.
      });
      var email = _emailController.text.trim();
      var password = _passwordController.text.trim();

      try {
        // Attempt to sign in using Firebase Authentication.
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Navigate to profile page upon successful login.
        Navigator.pushReplacementNamed(context, '/profile');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false; // Stop loading on error.
        });
        // Handle specific Firebase Authentication errors.
        String errorMessage = "An unexpected error occurred.";
        if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Invalid password provided for that user.";
        } else {
          errorMessage = e.message ?? errorMessage;
        }
        _showErrorDialog("Login Failed", errorMessage);
      }
    }
  }

  // Displays an error dialog with a custom message.
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const LogoWidget(), // Custom logo widget.
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) { // Validate the email input.
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Manage password visibility.
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle visibility state.
                      });
                    },
                  ),
                ),
                validator: (value) { // Validate the password input.
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while processing.
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
