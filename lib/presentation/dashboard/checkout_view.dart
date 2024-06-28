
import 'package:flutter/material.dart';
import 'package:webview_universal/webview_controller/webview_controller.dart';
import 'package:webview_universal/webview_universal.dart';

class PaystackPaymentWebView extends StatefulWidget {
  final String authorizationUrl;

  PaystackPaymentWebView({required this.authorizationUrl});

  @override
  _PaystackPaymentWebViewState createState() => _PaystackPaymentWebViewState();
}

class _PaystackPaymentWebViewState extends State<PaystackPaymentWebView> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController(); // Initialize here
    _loadUrl();
  }

  void _loadUrl() async {
    try {
      await _webViewController.init(
        context: context,
        setState: setState,
        uri: Uri.parse(widget.authorizationUrl),
      );
    } catch (e) {
      print('Error loading URL: $e');
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Payment'),
      ),
      body: Stack(
        children: [
          if (!_isError)
            WebView(
              controller: _webViewController,
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isError)
            Center(
              child: Text('Error loading page. Please try again later.'),
            ),
        ],
      ),
    );
  }
}
