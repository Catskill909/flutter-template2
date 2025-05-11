import 'dart:io';
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

    // Configure WebView for iOS
    if (Platform.isIOS) {
      debugPrint('Configuring WebView for iOS');
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
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
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
          // Open in browser button
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              // Try to get current URL first
              final url = await webViewController?.getUrl();
              if (url != null) {
                final Uri uri = Uri.parse(url.toString());
                await launchExternalBrowser(uri);
              } else {
                // Fallback to original URL
                final Uri uri = Uri.parse(widget.url);
                await launchExternalBrowser(uri);
              }
            },
          ),
          // Safari button (specifically for iOS)
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Open in Safari',
            onPressed: () {
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
              // Use a simpler URL initialization for iOS
              initialUrlRequest: URLRequest(
                url: WebUri(_ensureUrlHasScheme(widget.url)),
              ),
              initialSettings: InAppWebViewSettings(
                // Basic settings that should work on iOS
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,

                // iOS-specific settings
                allowsInlineMediaPlayback: true,

                // Disable settings that might cause issues on iOS
                useOnLoadResource: false,
                useShouldOverrideUrlLoading: false,
                mediaPlaybackRequiresUserGesture: false,

                // Add iOS-specific settings
                transparentBackground: true,
                disableVerticalScroll: false,
                disableHorizontalScroll: false,
                disableContextMenu: false,
                supportZoom: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;

                // Try loading the URL directly after WebView is created
                // This can help on iOS where the initialUrlRequest might not work properly
                debugPrint(
                    "WebView created, loading URL directly: ${widget.url}");

                // Try direct loading with a different approach for iOS
                if (Platform.isIOS) {
                  debugPrint("Using iOS-specific loading approach");

                  // First load a blank page to ensure WebView is initialized properly
                  controller.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri("about:blank"),
                    ),
                  );

                  // Then load the actual URL after a short delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    debugPrint(
                        "Now loading the actual URL after delay: ${widget.url}");
                    controller.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(_ensureUrlHasScheme(widget.url)),
                        headers: {
                          "Accept":
                              "text/html,application/xhtml+xml,application/xml",
                          "Cache-Control": "no-cache",
                        },
                      ),
                    );
                  });
                } else {
                  // For Android, load directly
                  controller.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(_ensureUrlHasScheme(widget.url)),
                    ),
                  );
                }
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
