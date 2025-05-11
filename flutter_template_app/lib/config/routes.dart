import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
