import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/admin_provider.dart';
import 'package:hotel/presentation/authentication/widgets/logo.dart';
import 'package:hotel/domain/models/admin_model.dart';

class AdminScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AdminProvider adminProvider = Provider.of<AdminProvider>(context);

    // Initialize the dummyUser
    final dummyUser = AdminModel(
      id: '18',
      email: 'admin@gmail.com',
      name: 'Admin',
      password: 'admin123',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.purple[700],
      ),
      backgroundColor: Colors.purple[100],
      body: Center(
        child: Container(
          width: 450,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // Rounded corners for the container
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWidget(),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    try {
                      await adminProvider.setAdmin(dummyUser); // Add admin details to Firestore
                      await adminProvider.signInWithEmailAndPassword(context, email, password);
                    } catch (error) {
                      print('Error: $error');
                    }
                  },
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700], // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
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
