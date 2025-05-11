# Code Examples from Dove Trail Flutter App

This document provides key code examples from the Dove Trail Flutter app that can be used as reference for implementing similar features in other Flutter applications.

## Table of Contents

1. [CORS Proxy Implementation](#cors-proxy-implementation)
2. [Image Proxy Implementation](#image-proxy-implementation)
3. [WordPress API Integration](#wordpress-api-integration)
4. [Error Handling](#error-handling)
5. [UI Components](#ui-components)

## CORS Proxy Implementation

### Multiple CORS Proxies with Fallback

```dart
// From rss_service.dart
class RssService {
  // List of CORS proxies to try
  final List<String> _corsProxies = [
    // WordPress API with CORS proxies
    'https://api.allorigins.win/raw?url=https://dovetrail.com/wp-json/wp/v2/posts?per_page=100',
    'https://corsproxy.io/?https://dovetrail.com/wp-json/wp/v2/posts?per_page=100',
    'https://thingproxy.freeboard.io/fetch/https://dovetrail.com/wp-json/wp/v2/posts?per_page=100',
    // Fallback to RSS feed if WordPress API fails
    'https://api.rss2json.com/v1/api.json?rss_url=https://dovetrail.com/feed/',
  ];

  Future<List<DoveArticle>> fetchDoveArticles() async {
    // Try each proxy in order until one works
    for (int i = 0; i < _corsProxies.length; i++) {
      try {
        final proxyUrl = _corsProxies[i];
        // Log proxy attempt in debug mode
        if (kDebugMode) {
          print('Trying CORS proxy $i: $proxyUrl');
        }

        final response = await http.get(Uri.parse(proxyUrl));

        if (response.statusCode == 200) {
          try {
            // First try to parse as WordPress API response (JSON array)
            if (proxyUrl.contains('wp-json/wp/v2/posts')) {
              return _parseWordPressResponse(response.body);
            }
            // Check if this is the RSS2JSON API response
            else if (proxyUrl.contains('rss2json.com')) {
              return _parseRss2JsonResponse(response.body);
            }
            // Process other proxy responses...
          } catch (e) {
            // Continue to next proxy
            continue;
          }
        }
      } catch (e) {
        // Continue to the next proxy if this one fails
        continue;
      }
    }

    // If all proxies fail, use mock data
    if (kDebugMode) {
      print('All CORS proxies failed, using mock data');
    }
    
    // Use mock data as a fallback
    final mockArticles = MockData.getDoveArticles();
    
    // Add a delay to simulate network request
    await Future.delayed(const Duration(milliseconds: 800));
    
    return mockArticles;
  }
}
```

## Image Proxy Implementation

### Proxy Method in DoveArticle Class

```dart
// From dove_article.dart
class DoveArticle {
  // ... other properties and methods

  // Static method to proxy image URLs
  static String getProxiedImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) {
      return 'https://via.placeholder.com/800x450?text=No+Image+Available';
    }
    
    // Use a reliable CORS proxy for images
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(originalUrl)}';
  }
}
```

### Using the Proxy Method with CachedNetworkImage

```dart
// From dove_card.dart
AspectRatio(
  aspectRatio: 16 / 9,
  child: CachedNetworkImage(
    imageUrl: DoveArticle.getProxiedImageUrl(article.imageUrl),
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        color: Colors.black,
      ),
    ),
    errorWidget: (context, url, error) => Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.image_not_supported,
            color: Colors.white70, size: 40),
      ),
    ),
  ),
),
```

## WordPress API Integration

### Parsing WordPress API Response

```dart
// From rss_service.dart
List<DoveArticle> _parseWordPressResponse(String jsonString) {
  final List<dynamic> posts = json.decode(jsonString);

  return posts.map((post) {
    return DoveArticle.fromWordPress(post);
  }).toList();
}
```

### WordPress Factory Method in DoveArticle

```dart
// From dove_article.dart
factory DoveArticle.fromWordPress(Map<String, dynamic> wpItem) {
  // Extract title from rendered title
  final title = wpItem['title']?['rendered'] ?? 'No Title';

  // Clean title from HTML entities
  final cleanTitle = html_parser.parse(title).body?.text ?? title;

  // Extract link
  final link = wpItem['link'] ?? '';

  // Extract description from content
  final description = wpItem['content']?['rendered'] ?? '';

  // Extract image URL
  final imageUrl = wpItem['featured_media_src_url'] ?? '';

  // Extract town
  final town = wpItem['town'] ?? 'Unknown Town';

  // Extract artist - if not available, try to extract from content
  String artist = wpItem['artist'] ?? '';
  if (artist.isEmpty) {
    final RegExp artistRegExp = RegExp(r'\*\*Artist:\*\* ([^\n]+)');
    final artistMatch = artistRegExp.firstMatch(description);
    artist = artistMatch?.group(1)?.trim() ?? 'Unknown Artist';
  }

  // Extract publication date
  final pubDate = wpItem['date'] ?? '';

  // Extract ID
  final id = wpItem['id'] ?? 0;

  return DoveArticle(
    title: cleanTitle,
    link: link,
    description: description,
    imageUrl: imageUrl, // Original URL, will be proxied when accessed
    town: town,
    artist: artist,
    pubDate: pubDate,
    id: id,
  );
}
```

## Error Handling

### Network Error Handling

```dart
try {
  final response = await http.get(Uri.parse(proxyUrl));
  
  if (response.statusCode == 200) {
    // Process response
  } else {
    // Handle non-200 status code
    throw Exception('Failed to load data: ${response.statusCode}');
  }
} catch (e) {
  // Handle network errors
  if (kDebugMode) {
    print('Error with proxy $i: $e');
  }
  // Continue to the next proxy
  continue;
}
```

### Image Loading Error Handling

```dart
CachedNetworkImage(
  imageUrl: DoveArticle.getProxiedImageUrl(article.imageUrl),
  fit: BoxFit.cover,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[800]!,
    highlightColor: Colors.grey[700]!,
    child: Container(
      color: Colors.black,
    ),
  ),
  errorWidget: (context, url, error) => Container(
    color: Colors.grey[900],
    child: const Center(
      child: Icon(Icons.image_not_supported,
          color: Colors.white70, size: 40),
    ),
  ),
),
```

## UI Components

### Card with Gradient Overlay

```dart
Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () => _launchUrl(article.link),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image with title overlay
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: DoveArticle.getProxiedImageUrl(article.imageUrl),
                fit: BoxFit.cover,
                // ... placeholder and error widget
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(204),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              height: 120,
            ),
            // Title and metadata
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // ... metadata
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),
```

### Opening External Links

```dart
Future<void> _launchUrl(String url) async {
  if (url.isEmpty) return;

  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
```

These code examples showcase the key implementations in the Dove Trail Flutter app. They can be used as reference for implementing similar features in other Flutter applications.
