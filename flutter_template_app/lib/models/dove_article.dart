import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html_parser;

class DoveArticle {
  final String title;
  final String link;
  final String description;
  final String imageUrl;
  final String town;
  final String artist;
  final String pubDate;
  final int id;

  // Static method to proxy image URLs
  static String getProxiedImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) {
      debugPrint('Empty image URL, using placeholder');
      return 'https://via.placeholder.com/800x450?text=No+Image+Available';
    }

    debugPrint('Original image URL: $originalUrl');

    // Try a different image proxy service
    final proxiedUrl = originalUrl;
    debugPrint('Using direct image URL: $proxiedUrl');

    return proxiedUrl;
  }

  DoveArticle({
    required this.title,
    required this.link,
    required this.description,
    required this.imageUrl,
    required this.town,
    required this.artist,
    required this.pubDate,
    required this.id,
  });

  // Factory method for WordPress API
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

  // Keep the RSS factory method for backward compatibility
  factory DoveArticle.fromRss(Map<String, dynamic> rssItem) {
    // Extract the image URL from the description using regex
    final RegExp imgRegExp = RegExp(r'<img[^>]+src="([^">]+)"');
    final imgMatch = imgRegExp.firstMatch(rssItem['description'] ?? '');
    final imageUrl = imgMatch?.group(1) ?? '';

    // Extract town and artist from the description
    final RegExp townRegExp = RegExp(r'\*\*Town:\*\* ([^\n]+)');
    final townMatch = townRegExp.firstMatch(rssItem['description'] ?? '');
    final town = townMatch?.group(1)?.trim() ?? 'Unknown Town';

    final RegExp artistRegExp = RegExp(r'\*\*Artist:\*\* ([^\n]+)');
    final artistMatch = artistRegExp.firstMatch(rssItem['description'] ?? '');
    final artist = artistMatch?.group(1)?.trim() ?? 'Unknown Artist';

    return DoveArticle(
      title: rssItem['title'] ?? 'No Title',
      link: rssItem['link'] ?? '',
      description: rssItem['description'] ?? '',
      imageUrl: imageUrl, // Original URL, will be proxied when accessed
      town: town,
      artist: artist,
      pubDate: rssItem['pubDate'] ?? '',
      id: 0, // No ID available in RSS
    );
  }
}
