import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double progress = 0;
  String currentUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final url = await webViewController?.getUrl();
              if (url != null) {
                final Uri uri = Uri.parse(url.toString());
                await launchExternalBrowser(uri);
              }
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
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                supportZoom: true,
                useHybridComposition: true,
                domStorageEnabled: true,
                databaseEnabled: true,
                allowContentAccess: true,
                allowFileAccess: true,
                allowsInlineMediaPlayback: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading = true;
                  currentUrl = url.toString();
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading = false;
                  currentUrl = url.toString();
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                // Using debugPrint instead of print for development logging
                debugPrint("Console Message: ${consoleMessage.message}");
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchExternalBrowser(Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open browser: $e')),
        );
      }
    }
  }
}
