# AI Agent Guide for Dove Trail Flutter App

This guide is designed to help AI agents understand and work with the Dove Trail Flutter app codebase. It provides context, patterns, and best practices specific to this project.

## Project Overview

The Dove Trail Flutter app is a news reader application that fetches and displays articles from the Dove Trail website. It's built with Flutter and designed to work on web platforms, with special handling for CORS restrictions.

## Key Files and Their Purpose

- **main.dart**: Entry point of the app, contains theme configuration and app initialization
- **models/dove_article.dart**: Data model for articles with factory methods for different data sources
- **services/rss_service.dart**: Service for fetching articles with CORS proxy handling
- **services/mock_data.dart**: Mock data for offline/testing use
- **widgets/dove_card.dart**: Card widget for displaying articles
- **screens/home_screen.dart**: Main screen with article list and pull-to-refresh

## Common Patterns

### 1. CORS Proxy Pattern

The app uses a list of CORS proxies to fetch data from external APIs. When working with this pattern:

- Always try multiple proxies in sequence
- Handle different response formats from different proxies
- Provide a fallback mechanism (like mock data)
- Use the static `getProxiedImageUrl` method for image URLs

```dart
// Example of using the CORS proxy pattern
final List<String> _corsProxies = [
  'https://api.allorigins.win/raw?url=YOUR_API_URL',
  'https://corsproxy.io/?YOUR_API_URL',
  // Add more proxies as needed
];

// Try each proxy in sequence
for (int i = 0; i < _corsProxies.length; i++) {
  try {
    final response = await http.get(Uri.parse(_corsProxies[i]));
    if (response.statusCode == 200) {
      // Process response
      return processResponse(response.body);
    }
  } catch (e) {
    // Continue to next proxy
    continue;
  }
}

// Fallback to mock data
return MockData.getData();
```

### 2. Image Proxy Pattern

For images, use the static `getProxiedImageUrl` method from the `DoveArticle` class:

```dart
// Example of using the image proxy pattern
CachedNetworkImage(
  imageUrl: DoveArticle.getProxiedImageUrl(imageUrl),
  // Other parameters
)
```

### 3. Error Handling Pattern

The app uses a comprehensive error handling pattern:

```dart
// Example of error handling pattern
try {
  // Attempt operation
  final result = await someOperation();
  return result;
} catch (e) {
  // Log error
  if (kDebugMode) {
    print('Error: $e');
  }
  // Provide fallback
  return fallbackValue;
}
```

## Adding New Features

When adding new features to the app, follow these guidelines:

### 1. Adding a New Model

1. Create a new file in the `models` directory
2. Define the model class with required properties
3. Implement factory methods for different data sources
4. Add any necessary utility methods

```dart
// Example of adding a new model
class NewModel {
  final String property1;
  final int property2;
  
  NewModel({required this.property1, required this.property2});
  
  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(
      property1: json['property1'] ?? '',
      property2: json['property2'] ?? 0,
    );
  }
}
```

### 2. Adding a New Service

1. Create a new file in the `services` directory
2. Define the service class with required methods
3. Implement CORS proxy handling if fetching external data
4. Provide fallback mechanisms

```dart
// Example of adding a new service
class NewService {
  Future<List<NewModel>> fetchData() async {
    // Implement CORS proxy handling
    // Process response
    // Provide fallback
  }
}
```

### 3. Adding a New Widget

1. Create a new file in the `widgets` directory
2. Define the widget class with required parameters
3. Implement the build method
4. Add any necessary helper methods

```dart
// Example of adding a new widget
class NewWidget extends StatelessWidget {
  final NewModel model;
  
  const NewWidget({Key? key, required this.model}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implement widget UI
  }
}
```

### 4. Adding a New Screen

1. Create a new file in the `screens` directory
2. Define the screen class with required parameters
3. Implement the build method
4. Add any necessary helper methods

```dart
// Example of adding a new screen
class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Implement screen UI
  }
}
```

## Common Mistakes to Avoid

1. **Direct API Calls**: Always use the CORS proxy pattern for external API calls
2. **Direct Image URLs**: Always use the image proxy pattern for external images
3. **Missing Error Handling**: Always provide comprehensive error handling
4. **Missing Fallback**: Always provide fallback mechanisms
5. **Hardcoded Values**: Use constants or configuration for values that might change

## Testing

When testing the app, consider:

1. **CORS Restrictions**: Test with different CORS proxies
2. **Network Conditions**: Test with different network conditions (slow, offline)
3. **Error Scenarios**: Test error handling and fallback mechanisms
4. **UI Responsiveness**: Test on different screen sizes

## Conclusion

This guide provides a high-level overview of the Dove Trail Flutter app codebase and common patterns used in the project. By following these guidelines, AI agents can effectively work with the codebase and add new features while maintaining the existing architecture and patterns.
