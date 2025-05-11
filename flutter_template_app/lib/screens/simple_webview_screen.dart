import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A simplified WebView screen for testing purposes
class SimpleWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const SimpleWebViewScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<SimpleWebViewScreen> createState() => _SimpleWebViewScreenState();
}

class _SimpleWebViewScreenState extends State<SimpleWebViewScreen> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double progress = 0;
  
  // Log all lifecycle events
  @override
  void initState() {
    super.initState();
    debugPrint('SimpleWebViewScreen - initState with URL: ${widget.url}');
  }
  
  @override
  void dispose() {
    debugPrint('SimpleWebViewScreen - dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SimpleWebViewScreen - building with URL: ${widget.url}');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          if (isLoading)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          // WebView
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.url),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
                debugPrint('SimpleWebViewScreen - WebView created');
              },
              onLoadStart: (controller, url) {
                debugPrint('SimpleWebViewScreen - onLoadStart: $url');
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                debugPrint('SimpleWebViewScreen - onLoadStop: $url');
                setState(() {
                  isLoading = false;
                });
              },
              onProgressChanged: (controller, progress) {
                debugPrint('SimpleWebViewScreen - onProgressChanged: $progress%');
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onReceivedError: (controller, request, error) {
                debugPrint('SimpleWebViewScreen - onReceivedError: ${error.description} (${error.type}) - URL: ${request.url}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
