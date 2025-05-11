import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock user data
    const String userName = 'John Doe';
    const String userEmail = 'john.doe@example.com';
    const String userBio = 'Flutter Developer | Tech Enthusiast';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile picture
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // User name
            const Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // User email
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            // User bio
            Text(
              userBio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 32),
            // Stats section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Posts', '24'),
                _buildStatItem('Followers', '1.2K'),
                _buildStatItem('Following', '567'),
              ],
            ),
            const SizedBox(height: 32),
            // Profile actions
            _buildProfileAction(Icons.edit, 'Edit Profile'),
            _buildProfileAction(Icons.bookmark, 'Saved Items'),
            _buildProfileAction(Icons.history, 'Activity History'),
            _buildProfileAction(Icons.help, 'Help & Support'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(label),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Handle action tap
          },
        ),
      ),
    );
  }
}
