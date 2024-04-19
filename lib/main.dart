import 'package:flutter/material.dart';
import 'package:hotel/presentation/authentication/screens/login_screen.dart';
import 'package:hotel/presentation/authentication/screens/profile_screen.dart';
import 'package:hotel/presentation/authentication/screens/signUp_screen.dart';

import 'package:hotel/presentation/authentication/screens/forgot_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hotel/presentation/home/home_screen.dart';
import 'core/theme/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const Hotel(),
    ),
  );
}

class Hotel extends StatelessWidget {
  const Hotel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Card',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Counter App'),
        '/home': (context) => const MyHomePage(title: 'Hotel Page'),
        '/signUp': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
      '/forgotPassword': (context) =>  ForgotPasswordScreen(), // New forgot password route
      },
    );
  }
}
