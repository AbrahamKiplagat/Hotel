import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel/home.dart';
import 'package:hotel/presentation/authentication/screens/login_screen.dart';
import 'package:hotel/presentation/authentication/screens/profile_screen.dart';
import 'package:hotel/presentation/authentication/screens/signUp_screen.dart';
import 'package:hotel/presentation/authentication/screens/booking_screen.dart';
import 'package:hotel/presentation/authentication/screens/forgot_screen.dart';
import 'package:hotel/presentation/dashboard/bookedby.dart';
import 'package:hotel/presentation/home/home_screen.dart';
import 'core/theme/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/auth_provider.dart';
import 'presentation/home/add_hotels_screen.dart';
import 'presentation/authentication/screens/admin_screen.dart';
import 'providers/admin_provider.dart';
import 'providers/hotel_provider.dart'; // Import the HotelProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      // MultiProvider allows us to combine multiple providers into a single widget tree.
      providers: [
        // Provider for managing authentication-related state.
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // Provider for managing admin-related state.
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        // Provider for managing hotel-related state.
        ChangeNotifierProvider(create: (context) => HotelProvider()), // Provide the HotelProvider
      ],
      // Hotel is the root widget of our application.
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
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        // '/': (context) => WelcomeScreen(), // Home page route
        '/': (context) => MyHomePage(title: 'Hotel Page'), // Home page route
        '/bookedby': (context) =>BookingDisplayScreen (), // Home page route
        '/home': (context) =>  MyHomePage(title: 'Hotel Page'), // Home page route
        // '/homebar': (context) =>  MyHomePage1(title: 'Hotel Page'), // Home page route
        '/signUp': (context) => const SignUpScreen(), // SignUp screen route
        '/login': (context) => const LoginScreen(), // Login screen route
        // '/booking': (context) => const BookingScreen(), // Booking screen route
        // '/profile': (context) => const ProfileScreen(), // Profile screen route
        '/forgotPassword': (context) => ForgotPasswordScreen(), // Forgot password screen route
        '/admin': (context) => AdminScreen(), // Admin screen route
        '/addHotels': (context) => const AddHotelScreen(), // Add hotels screen route
      },
    );
  }
}