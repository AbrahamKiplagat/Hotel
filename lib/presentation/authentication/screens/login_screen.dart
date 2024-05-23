import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/auth_provider.dart';
import 'package:hotel/presentation/home/widgets/bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                await context.read<AuthProvider>().signInWithEmailAndPassword(context, email, password);
                if (context.read<AuthProvider>().isLoggedIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomBar()),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotPassword');
              },
              child: const Text('Forgot password?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: const Text('Login as admin'),
            ),
          ],
        ),
      ),
    );
  }
}
