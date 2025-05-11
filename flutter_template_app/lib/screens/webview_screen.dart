import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// WebView screen for displaying web content within the app
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
  void initState() {
    super.initState();
    debugPrint('WebViewScreen - initState with URL: ${widget.url}');

    // Validate URL format
    try {
      final uri = Uri.parse(widget.url);
      debugPrint(
          'Parsed URI - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}');
      if (uri.scheme.isEmpty) {
        debugPrint('WARNING: URL has no scheme, this may cause issues on iOS');
      }
    } catch (e) {
      debugPrint('ERROR parsing URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WebViewScreen - building with URL: ${widget.url}');

    // Determine if we're on a tablet/desktop
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            fontSize: isLargeScreen ? 36 : 20, // Much larger font for tablet
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true, // Center the title
        toolbarHeight: isLargeScreen ? 90 : 56, // Much taller AppBar for tablet
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: isLargeScreen ? 40 : 24, // Much larger icon for tablet
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Open in browser button
          IconButton(
            icon: Icon(
              Icons.open_in_browser,
              size: isLargeScreen ? 40 : 24, // Much larger icon for tablet
            ),
            onPressed: () async {
              final Uri uri = Uri.parse(widget.url);
              launchUrl(uri, mode: LaunchMode.externalApplication);
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
              // Simple URL initialization that works on both iOS and Android
              initialUrlRequest: URLRequest(
                url: WebUri(_ensureUrlHasScheme(widget.url)),
              ),
              // Minimal settings that work on both platforms
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                // iOS-specific settings
                allowsInlineMediaPlayback: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
                debugPrint('WebViewScreen - WebView created');
              },
              onLoadStart: (controller, url) {
                debugPrint('WebViewScreen - onLoadStart: $url');
                setState(() {
                  isLoading = true;
                  currentUrl = url.toString();
                });
              },
              onLoadStop: (controller, url) {
                debugPrint('WebViewScreen - onLoadStop: $url');
                setState(() {
                  isLoading = false;
                  currentUrl = url.toString();
                });
              },
              onProgressChanged: (controller, progress) {
                debugPrint('WebViewScreen - onProgressChanged: $progress%');
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onReceivedError: (controller, request, error) {
                debugPrint(
                    'WebViewScreen - onReceivedError: ${error.description} (${error.type}) - URL: ${request.url}');

                // Show error message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading page: ${error.description}'),
                    ),
                  );
                }
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

  // Helper method to ensure URL has a scheme (http:// or https://)
  String _ensureUrlHasScheme(String url) {
    debugPrint('Checking URL scheme: $url');
    if (url.isEmpty) {
      debugPrint('Empty URL, returning default https://example.com');
      return 'https://example.com';
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      final newUrl = 'https://$url';
      debugPrint('Added https:// scheme to URL: $newUrl');
      return newUrl;
    }

    debugPrint('URL already has scheme: $url');
    return url;
  }
}
