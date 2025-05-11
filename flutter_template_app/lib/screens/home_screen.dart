import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tab1.dart';
import 'tab2.dart';
import 'tab3.dart';
import 'tab4.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Tab1Screen(),
    const Tab2Screen(),
    const Tab3Screen(),
    const Tab4Screen(),
  ];

  final List<String> _titles = [
    'Dove Trail',
    'Tab 2',
    'Tab 3',
    'Tab 4',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a tablet/desktop
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            fontSize: isLargeScreen ? 32 : 24, // Larger font for tablet/desktop
          ),
        ),
        centerTitle: true,
        toolbarHeight:
            isLargeScreen ? 72 : 56, // Taller AppBar for tablet/desktop
      ),
      drawer: Builder(
        builder: (context) {
          // Determine if we're on a tablet/desktop
          final isLargeScreen = MediaQuery.of(context).size.width > 600;

          return Drawer(
            width: isLargeScreen ? 360 : 300, // Wider drawer for tablet/desktop
            backgroundColor:
                Colors.black, // Force dark mode with black background
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Custom drawer header that won't overflow
                Container(
                  color: Colors.blue.shade900, // Dark blue header
                  height: isLargeScreen
                      ? 180
                      : 150, // Fixed height based on screen size
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: isLargeScreen ? 40 : 30,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.person,
                              size: isLargeScreen ? 50 : 36,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Text column
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flutter Template',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isLargeScreen ? 24 : 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'template@example.com',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isLargeScreen ? 16 : 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Internal navigation items
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'NAVIGATION',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade300, // Light blue for dark theme
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24 : 16,
                    vertical: isLargeScreen ? 4 : 0,
                  ),
                  leading: Icon(
                    Icons.explore,
                    size: isLargeScreen
                        ? 32
                        : 24, // Larger icon for tablet/desktop
                    color: _selectedIndex == 0
                        ? Colors.blue.shade300 // Light blue for selected item
                        : Colors.white70, // Light gray for unselected items
                  ),
                  title: Text(
                    'Dove Trail',
                    style: TextStyle(
                      fontSize: isLargeScreen
                          ? 20
                          : 16, // Larger text for tablet/desktop
                      fontWeight: _selectedIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == 0
                          ? Colors.white
                          : Colors
                              .white70, // White for selected, gray for unselected
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: _selectedIndex == 0,
                  selectedColor:
                      Colors.blue.shade300, // Light blue for selected item
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24 : 16,
                    vertical: isLargeScreen ? 4 : 0,
                  ),
                  leading: Icon(
                    Icons.favorite,
                    size: isLargeScreen ? 32 : 24,
                    color: _selectedIndex == 1
                        ? Colors.blue.shade300 // Light blue for selected item
                        : Colors.white70, // Light gray for unselected items
                  ),
                  title: Text(
                    'Tab 2',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      fontWeight: _selectedIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == 1
                          ? Colors.white
                          : Colors
                              .white70, // White for selected, gray for unselected
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: _selectedIndex == 1,
                  selectedColor:
                      Colors.blue.shade300, // Light blue for selected item
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24 : 16,
                    vertical: isLargeScreen ? 4 : 0,
                  ),
                  leading: Icon(
                    Icons.notifications,
                    size: isLargeScreen ? 32 : 24,
                    color: _selectedIndex == 2
                        ? Colors.blue.shade300 // Light blue for selected item
                        : Colors.white70, // Light gray for unselected items
                  ),
                  title: Text(
                    'Tab 3',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      fontWeight: _selectedIndex == 2
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == 2
                          ? Colors.white
                          : Colors
                              .white70, // White for selected, gray for unselected
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: _selectedIndex == 2,
                  selectedColor:
                      Colors.blue.shade300, // Light blue for selected item
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 24 : 16,
                    vertical: isLargeScreen ? 4 : 0,
                  ),
                  leading: Icon(
                    Icons.person,
                    size: isLargeScreen ? 32 : 24,
                    color: _selectedIndex == 3
                        ? Colors.blue.shade300 // Light blue for selected item
                        : Colors.white70, // Light gray for unselected items
                  ),
                  title: Text(
                    'Tab 4',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      fontWeight: _selectedIndex == 3
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == 3
                          ? Colors.white
                          : Colors
                              .white70, // White for selected, gray for unselected
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: _selectedIndex == 3,
                  selectedColor:
                      Colors.blue.shade300, // Light blue for selected item
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Divider(
                    color: Colors.white24, // Light divider for dark theme
                    thickness: 1,
                  ),
                ),
                // External links
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'EXTERNAL LINKS',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade300, // Light blue for dark theme
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Icon(
                    Icons.language,
                    size: isLargeScreen ? 32 : 24,
                    color: Colors.white70, // Light gray for icons
                  ),
                  title: Text(
                    'Website',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      color: Colors.white70, // Light gray for text
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://flutter.dev');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Icon(
                    Icons.code,
                    size: isLargeScreen ? 32 : 24,
                    color: Colors.white70, // Light gray for icons
                  ),
                  title: Text(
                    'GitHub',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      color: Colors.white70, // Light gray for text
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://github.com/flutter/flutter');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Icon(
                    Icons.help,
                    size: isLargeScreen ? 32 : 24,
                    color: Colors.white70, // Light gray for icons
                  ),
                  title: Text(
                    'Help Center',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      color: Colors.white70, // Light gray for text
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://docs.flutter.dev');
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Icon(
                    Icons.info,
                    size: isLargeScreen ? 32 : 24,
                    color: Colors.white70, // Light gray for icons
                  ),
                  title: Text(
                    'About',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      color: Colors.white70, // Light gray for text
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://flutter.dev/about');
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Builder(
        builder: (context) {
          // Determine if we're on a tablet/desktop
          final isLargeScreen = MediaQuery.of(context).size.width > 600;

          // Create a custom NavigationBar with larger text and icons for tablets
          return NavigationBar(
            onDestinationSelected: _onItemTapped,
            selectedIndex: _selectedIndex,
            height: isLargeScreen
                ? 120
                : 60, // Much taller navigation bar for tablet
            labelBehavior: NavigationDestinationLabelBehavior
                .alwaysShow, // Always show labels
            destinations: [
              // Use custom sized icons and text for each destination
              NavigationDestination(
                icon: Icon(
                  Icons.explore_outlined,
                  size: isLargeScreen ? 48 : 24, // Much larger icons for tablet
                ),
                selectedIcon: Icon(
                  Icons.explore,
                  size: isLargeScreen ? 48 : 24,
                ),
                label: isLargeScreen
                    ? 'DOVE TRAIL' // Uppercase and larger for tablet (visual effect)
                    : 'Dove Trail',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_outline,
                  size: isLargeScreen ? 48 : 24,
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  size: isLargeScreen ? 48 : 24,
                ),
                label: isLargeScreen ? 'TAB 2' : 'Tab 2',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.notifications_outlined,
                  size: isLargeScreen ? 48 : 24,
                ),
                selectedIcon: Icon(
                  Icons.notifications,
                  size: isLargeScreen ? 48 : 24,
                ),
                label: isLargeScreen ? 'TAB 3' : 'Tab 3',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  size: isLargeScreen ? 48 : 24,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: isLargeScreen ? 48 : 24,
                ),
                label: isLargeScreen ? 'TAB 4' : 'Tab 4',
              ),
            ],
          );
        },
      ),
    );
  }
}
