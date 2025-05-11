class AppConstants {
  // API URLs
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  static const String apiBaseUrl = baseUrl + apiVersion;

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String userEndpoint = '/user';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // App settings
  static const String appName = 'Flutter Template App';
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}
