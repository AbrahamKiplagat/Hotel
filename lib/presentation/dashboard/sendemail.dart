import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

Future<void> sendPaymentNotificationEmail(String userEmail, double totalAmount, String phoneNumber) async {
  String username = 'kiplaharthotel@gmail.com'; // Your email address
  String password = '@KiplahArt01'; // Your email password

  final smtpServer = gmail(username, password);

  // Path to your receipt PDF file
  String receiptPath = '/path/to/your/receipt.pdf';

  final message = Message()
    ..from = Address(username, 'Your Name')
    ..recipients.add(userEmail) // User's email
    ..subject = 'Payment Notification'
    ..html = '''
      <h3>Your Payment Details</h3>
      <p>Total Amount: KSH ${totalAmount.toInt()}</p>
      <p>Phone Number: $phoneNumber</p>
      <p>Thank you for your payment.</p>
      <p><a href="https://example.com/download/receipt">Download Receipt</a></p>
    '''
    ..attachments.add(FileAttachment(File(receiptPath)));

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}