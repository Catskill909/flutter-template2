import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Add auth token to headers
  void setAuthToken(String token) {
    headers['Authorization'] = 'Bearer $token';
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Example of a specific API call
  Future<User> getUserProfile() async {
    final data = await get(AppConstants.userEndpoint);
    return User.fromJson(data);
  }
}
