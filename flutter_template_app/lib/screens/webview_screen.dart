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
              // Ensure URL has a scheme for iOS
              initialUrlRequest: URLRequest(
                url: WebUri(_ensureUrlHasScheme(widget.url)),
                headers: {
                  // Add headers to help with potential CORS issues
                  'Accept':
                      'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                  'User-Agent':
                      'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1'
                },
              ),
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
                allowsLinkPreview: true,
                // Additional iOS-specific settings
                limitsNavigationsToAppBoundDomains: false,
                allowsBackForwardNavigationGestures: true,
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
              onReceivedError: (controller, request, error) {
                debugPrint(
                    "WebView Error: ${error.description} (${error.type}) - URL: ${request.url}");
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Error loading page: ${error.description}')),
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
