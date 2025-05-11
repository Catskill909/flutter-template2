import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSectionHeader('App Preferences'),
          _buildSwitchTile(
            'Dark Mode',
            'Switch between light and dark theme',
            Icons.dark_mode,
            _darkModeEnabled,
            (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSliderTile(
            'Text Size',
            'Adjust the text size throughout the app',
            Icons.text_fields,
            _textSize,
            12.0,
            20.0,
            (value) {
              setState(() {
                _textSize = value;
              });
            },
          ),
          const Divider(),
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            'Push Notifications',
            'Receive notifications about activity',
            Icons.notifications,
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildSectionHeader('Account'),
          _buildActionTile(
            'Personal Information',
            'Manage your personal details',
            Icons.person,
            () {
              // Navigate to personal info screen
            },
          ),
          _buildActionTile(
            'Security',
            'Change password and security settings',
            Icons.security,
            () {
              // Navigate to security screen
            },
          ),
          _buildActionTile(
            'Privacy',
            'Manage your privacy settings',
            Icons.privacy_tip,
            () {
              // Navigate to privacy screen
            },
          ),
          const Divider(),
          _buildSectionHeader('About'),
          _buildActionTile(
            'App Version',
            '1.0.0',
            Icons.info,
            () {
              // Show app version info
            },
          ),
          _buildActionTile(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description,
            () {
              // Show terms of service
            },
          ),
          _buildActionTile(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.policy,
            () {
              // Show privacy policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 2).toInt(),
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
