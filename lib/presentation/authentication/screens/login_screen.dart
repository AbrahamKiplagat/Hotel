import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/auth_provider.dart';
import 'package:hotel/providers/admin_provider.dart';
import 'package:hotel/presentation/home/widgets/bottom_nav.dart';
import 'package:hotel/presentation/authentication/widgets/logo.dart';
import 'package:hotel/domain/models/admin_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isAdmin = false; // Flag to check if admin login

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void toggleRole() {
    setState(() {
      isAdmin = !isAdmin;
    });
  }

  Future<void> handleLogin(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (isAdmin) {
      // Admin login logic
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final dummyUser = AdminModel(
        id: '18',
        email: 'admin@gmail.com',
        name: 'Admin',
        password: 'admin123',
      );

      try {
        await adminProvider.setAdmin(dummyUser);
        await adminProvider.signInWithEmailAndPassword(context, email, password);
        // Navigate to admin screen or admin-specific functionality
      } catch (error) {
        print('Error: $error');
      }
    } else {
      // User login logic
      await context.read<AuthProvider>().signInWithEmailAndPassword(context, email, password);
      if (context.read<AuthProvider>().isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Admin Login' : 'User Login'),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/hotel.png"), // Make sure the path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Slightly transparent background
                    borderRadius: BorderRadius.circular(12),
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
                        if (isAdmin) LogoWidget(),
                        Text(
                          isAdmin ? 'Admin Portal' : 'Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            backgroundColor: Colors.purple[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                        TextButton(
                          onPressed: toggleRole,
                          child: Text(
                            isAdmin ? 'Login as user' : 'Login as admin',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
