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
      ),
      body: Center(
        child: Container(
          width: 450,
          decoration: BoxDecoration(
            color: Colors.white,
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
                      await adminProvider.setAdmin(dummyUser); // Add admin details to Firestore
                      await adminProvider.signInWithEmailAndPassword(context, email, password);
                    } catch (error) {
                      print('Error: $error');
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
