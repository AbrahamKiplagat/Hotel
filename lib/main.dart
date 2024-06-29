import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
// import 'package:hotel/domain/services/firestore_service.dart';
import 'package:hotel/home.dart';
import 'package:hotel/presentation/authentication/screens/login_screen.dart';
import 'package:hotel/presentation/authentication/screens/signUp_screen.dart';
import 'package:hotel/presentation/authentication/screens/forgot_screen.dart';
import 'package:hotel/presentation/dashboard/AdminBookingDisplayScreen';
import 'package:pay_with_paystack/pay_with_paystack.dart';
// import 'package:hotel/presentation/dashboard/admin_booking_display_screen.dart';
import 'package:hotel/presentation/dashboard/bookedby.dart';
import 'package:hotel/presentation/home/home_screen.dart';
import 'package:hotel/presentation/home/payment_graph_screen.dart';
import 'core/theme/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:hotel/providers/auth_provider.dart';
import 'presentation/home/add_hotels_screen.dart';
import 'presentation/authentication/screens/admin_screen.dart';
import 'providers/admin_provider.dart';
import 'providers/hotel_provider.dart'; // Import the HotelProvider

import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:send_mail_flutter/mail_page.dart';
Future<void> main() async {
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize webview_flutter
  // WebView.platform = SurfaceAndroidWebView();

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
          // Provider<FirestoreService>(create: (_) => FirestoreService()),
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
        '/': (context) => WelcomeScreen(), // Home page route
        '/userdetails': (context) => AdminBookingDisplayScreen(), // Home page route
        '/bookedby': (context) =>BookingDisplayScreen (), // Home page route
        '/home': (context) =>  MyHomePage(title: 'Hotel Page'), // Home page route
        // '/homebar': (context) =>  MyHomePage1(title: 'Hotel Page'), // Home page route
        '/signUp': (context) => const SignUpScreen(), // SignUp screen route
        '/login': (context) => const LoginScreen(), // Login screen route
        // '/booking': (context) => const BookingScreen(), // Booking screen route
        // '/profile': (context) => const ProfileScreen(), // Profile screen route
        '/forgotPassword': (context) => ForgotPasswordScreen(), // Forgot password screen route
        // '/admin': (context) => AdminScreen(), // Admin screen route
        '/addHotels': (context) => const AddHotelScreen(), // Add hotels screen route
        '/payment-graph': (context) => PaymentGraphScreen(), // Add hotels screen route
      },
    );
  }
}
/*** 
 * store payements on collections 
 * display user payements details on admin.
 * add 0.50ksh deduction  on a payed amount to your account
 * add a tests to your project to display if your project can complete all the transaction.  
*/