import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kDebugMode;
import '../models/dove_article.dart';

class RssService {
  // WordPress API URL
  static const String wordPressApiUrl =
      'https://dovetrail.com/wp-json/wp/v2/posts?per_page=100';

  // Direct URL to the WordPress API - no proxy needed for Android
  final String _wordPressApiUrl =
      'https://dovetrail.com/wp-json/wp/v2/posts?per_page=100';

  Future<List<DoveArticle>> fetchDoveArticles() async {
    try {
      if (kDebugMode) {
        print('Fetching articles from WordPress API directly');
      }

      // Direct request to WordPress API - works fine on Android
      final response = await http.get(Uri.parse(_wordPressApiUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('WordPress API request timed out');
        },
      );

      if (response.statusCode == 200) {
        // Parse the WordPress API response
        return _parseWordPressResponse(response.body);
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching articles: $e');
      }

      // If the direct API call fails, throw an exception
      // This will show the error UI to the user
      throw Exception('Failed to load articles: $e');
    }
  }

  // Parse WordPress API response
  List<DoveArticle> _parseWordPressResponse(String jsonString) {
    final List<dynamic> posts = json.decode(jsonString);

    return posts.map((post) {
      return DoveArticle.fromWordPress(post);
    }).toList();
  }
}
