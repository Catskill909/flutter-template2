# Flutter Template App

A modern Flutter application template with a clean architecture, bottom navigation, drawer menu, and WordPress API integration. This template provides a solid foundation for building content-driven mobile applications with a beautiful Material Design 3 interface.

## Features

- **Modern Navigation**: Bottom tab navigation with drawer menu
- **Real-time Data**: Direct integration with WordPress REST API
- **In-App WebView**: View content within the app using modern WebView
- **Material Design 3**: Beautiful UI with dark mode support
- **Responsive Layout**: Optimized for phones, tablets, and desktops with adaptive UI elements
- **Pull to Refresh**: Allows users to refresh content
- **Error Handling**: Graceful error handling and loading states
- **Image Loading**: Efficient image loading with fallback placeholders
- **Google Fonts**: Integration with Oswald font for headings
- **Shimmer Effects**: Elegant loading animations

## Architecture

The app follows a clean architecture pattern with separation of concerns:

- **Models**: Data models representing the domain entities
- **Services**: Services for data fetching and business logic
- **Widgets**: Reusable UI components
- **Screens**: Full app screens composed of widgets

## Packages Used

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | Latest | Core framework |
| http | ^1.1.0 | Network requests |
| shimmer | ^3.0.0 | Loading animations |
| url_launcher | ^6.1.14 | Opening external links |
| html | ^0.15.4 | HTML parsing |
| google_fonts | ^6.1.0 | Custom typography with Google Fonts |
| flutter_inappwebview | ^6.0.0 | In-app web content viewing |
| shared_preferences | ^2.2.2 | Local storage for settings |
| path_provider | ^2.1.1 | File system access |
| sqflite | ^2.3.0 | Local database storage |

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/                    # Data models
│   └── dove_article.dart      # Article model with factory methods
├── screens/                   # App screens
│   ├── home_screen.dart       # Main screen with article list
│   ├── webview_screen.dart    # In-app WebView for content viewing
│   └── settings_screen.dart   # Settings screen (placeholder)
├── services/                  # Business logic and data services
│   └── rss_service.dart       # Service for fetching articles from WordPress API
├── widgets/                   # Reusable UI components
│   ├── dove_card.dart         # Card widget for articles
│   ├── app_drawer.dart        # App drawer with navigation
│   └── bottom_nav_bar.dart    # Bottom navigation bar
└── theme/                     # Theme configuration
    └── app_theme.dart         # App-wide theme settings
```

## WordPress API Integration

The app directly integrates with the WordPress REST API:

```
https://dovetrail.com/wp-json/wp/v2/posts?per_page=100
```

The `RssService` class handles fetching and parsing the WordPress API data:

```dart
Future<List<DoveArticle>> fetchDoveArticles() async {
  try {
    // Direct request to WordPress API
    final response = await http.get(Uri.parse(_wordPressApiUrl));

    if (response.statusCode == 200) {
      // Parse the WordPress API response
      return _parseWordPressResponse(response.body);
    } else {
      throw Exception('Failed to load articles');
    }
  } catch (e) {
    // Error handling
    throw Exception('Failed to load articles: $e');
  }
}
```

## WebView Implementation

The app uses `flutter_inappwebview` to display content within the app with cross-platform compatibility:

```dart
InAppWebView(
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
)
```

### iOS WebView Compatibility

The WebView implementation has been optimized for iOS compatibility:

1. Ensuring all URLs have proper schemes (http:// or https://)
2. Using simplified WebView settings that work on both platforms
3. Removing unsupported features that cause crashes on iOS
4. Using the latest version of flutter_inappwebview (6.0.0+) for iOS 17+ compatibility

```dart
// Helper method to ensure URL has a scheme (http:// or https://)
String _ensureUrlHasScheme(String url) {
  if (url.isEmpty) {
    return 'https://example.com';
  }

  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'https://$url';
  }

  return url;
}
```

## Image Handling

The app handles images with fallback placeholders for empty URLs:

```dart
static String getProxiedImageUrl(String originalUrl) {
  if (originalUrl.isEmpty) {
    debugPrint('Empty image URL, using placeholder');
    return 'https://via.placeholder.com/800x450?text=No+Image+Available';
  }
  return originalUrl;
}
```

## Error Handling

The app implements comprehensive error handling:
- Network errors are caught and displayed to the user
- Loading states are shown during data fetching
- Shimmer effects for loading states
- Error widgets for failed image loading

## Android NDK Configuration

The app includes a solution for Android NDK version compatibility issues:

1. Create a symbolic link from the required NDK version to the available one:
```bash
cd ~/Library/Android/sdk/ndk
rm -rf 27.0.12077973  # Remove incomplete directory if it exists
ln -s 26.3.11579264 27.0.12077973  # Create symbolic link
```

2. Configure build.gradle.kts to use the required NDK version:
```kotlin
android {
    // Using the required NDK version via symbolic link
    ndkVersion = "27.0.12077973"
    ...
}
```

## How to Run

1. Ensure Flutter is installed on your system
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Configure Android NDK as described above (if needed)
5. Run `flutter run` to launch the app on a connected device or emulator

## Customization

### Theme

The app uses Material Design 3 with Oswald Google Font for headings. To customize the theme:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.oswaldTextTheme(
    ThemeData.dark().textTheme,
  ),
)
```

### Adding New Features

To add new features:
1. Create new model classes in the `models` directory if needed
2. Add new services in the `services` directory for business logic
3. Create new widgets in the `widgets` directory
4. Update or create screens in the `screens` directory

## Responsive Design

The app is fully responsive and optimized for different screen sizes:

### Tablet and Desktop Optimizations

- **Multi-column Layout**: Automatically switches to 2-column grid on tablets and desktops
- **Scaled UI Elements**: App bar, icons, and text scale up appropriately on larger screens
- **Optimized Navigation**: Bottom navigation bar and drawer are enhanced for tablet use
- **WebView Improvements**: Enhanced WebView experience on tablets with larger controls

```dart
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
    ),
    centerTitle: true,
    toolbarHeight: isLargeScreen ? 90 : 56, // Much taller AppBar for tablet
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: isLargeScreen ? 40 : 24, // Much larger icon for tablet
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
  ),
)
```

## Best Practices

- Implement proper error handling for all network requests
- Use the WebView for in-app content viewing
- Follow the established architecture pattern for new features
- Add comprehensive comments for complex logic
- Use debugPrint instead of print for debugging
- Ensure UI elements scale appropriately for different screen sizes

## iOS Configuration

The app has been configured to work properly on iOS devices:

1. WebView functionality has been optimized for iOS compatibility
2. URL handling has been improved to ensure proper scheme prefixes
3. iOS-specific settings have been applied to the WebView component

### iOS Troubleshooting

If you encounter issues with the WebView on iOS:

1. Ensure all URLs have proper schemes (http:// or https://)
2. Check that the flutter_inappwebview package is at version 6.0.0 or higher
3. Verify that iOS-specific settings are properly configured:
   ```dart
   initialSettings: InAppWebViewSettings(
     javaScriptEnabled: true,
     javaScriptCanOpenWindowsAutomatically: true,
     allowsInlineMediaPlayback: true,  // Important for iOS
   ),
   ```
4. For detailed WebView debugging, refer to the [webview-bug.md](./webview-bug.md) documentation

## Additional Documentation

For more detailed information about platform-specific configuration issues, refer to:

- [android-mess.md](./android-mess.md) - Documentation of Android NDK and Gradle issues and solutions
- [webview-bug.md](./webview-bug.md) - Documentation of WebView issues and solutions for iOS
