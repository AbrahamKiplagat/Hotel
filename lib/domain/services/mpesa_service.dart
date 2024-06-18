import 'package:http/http.dart' as http;
import 'dart:convert';

class MpesaService {
  final String consumerKey = 'CGQThG0NffJzBDIRqxfLYpFWaS0FkqNbSN8CYlPyshEnQBO6';
  final String consumerSecret = 'dftK65sJvLT6XfXOxeZkAYKME79ycyWVT3U2srnXXsNODEAm7JeYyL9dlRujdwNA';
  final String shortCode = '174379'; // Replace with actual short code if available
  final String lipaNaMpesaOnlineUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
  final String tokenUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
  final String passKey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';

  Future<String> getAccessToken() async {
    String credentials = base64.encode(utf8.encode('$consumerKey:$consumerSecret'));
    final response = await http.get(
      Uri.parse(tokenUrl),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<void> initiateSTKPush({required String phoneNumber, required double amount}) async {
    String accessToken = await getAccessToken();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String password = base64.encode(utf8.encode('$shortCode$consumerKey$timestamp'));

    final response = await http.post(
      Uri.parse(lipaNaMpesaOnlineUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount,
        'PartyA': phoneNumber,
        'PartyB': shortCode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': 'https://your-callback-url.com/callback',
        'AccountReference': 'HotelBooking123',
        'TransactionDesc': 'Hotel Room Payment'
      }),
    );

    if (response.statusCode == 200) {
      print('STK Push initiated successfully');
    } else {
      print('Failed to initiate STK Push');
    }
  }
}
