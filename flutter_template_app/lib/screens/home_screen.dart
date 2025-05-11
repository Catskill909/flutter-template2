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
            width: isLargeScreen ? 320 : 280, // Wider drawer for tablet/desktop
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: isLargeScreen
                            ? 40
                            : 30, // Larger avatar for tablet/desktop
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          size: isLargeScreen
                              ? 50
                              : 40, // Larger icon for tablet/desktop
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          height: isLargeScreen
                              ? 16
                              : 10), // More spacing for tablet/desktop
                      Text(
                        'Flutter Template',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isLargeScreen
                                      ? 24
                                      : null, // Larger text for tablet/desktop
                                ),
                      ),
                      Text(
                        'template@example.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              fontSize: isLargeScreen
                                  ? 16
                                  : null, // Larger text for tablet/desktop
                            ),
                      ),
                    ],
                  ),
                ),
                // Internal navigation items
                ListTile(
                  leading: Icon(
                    Icons.explore,
                    size: isLargeScreen
                        ? 28
                        : 24, // Larger icon for tablet/desktop
                  ),
                  title: Text(
                    'Dove Trail',
                    style: TextStyle(
                      fontSize: isLargeScreen
                          ? 18
                          : 16, // Larger text for tablet/desktop
                    ),
                  ),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'Tab 2',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'Tab 3',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  selected: _selectedIndex == 2,
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'Tab 4',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  selected: _selectedIndex == 3,
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                // External links
                ListTile(
                  leading: Icon(
                    Icons.language,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'Website',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://flutter.dev');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.code,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'GitHub',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://github.com/flutter/flutter');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.help,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'Help Center',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchUrl('https://docs.flutter.dev');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    size: isLargeScreen ? 28 : 24,
                  ),
                  title: Text(
                    'About',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 18 : 16,
                    ),
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

          return NavigationBar(
            onDestinationSelected: _onItemTapped,
            selectedIndex: _selectedIndex,
            height: isLargeScreen
                ? 80
                : 60, // Taller navigation bar for tablet/desktop
            labelBehavior: isLargeScreen
                ? NavigationDestinationLabelBehavior.alwaysShow
                : NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.explore_outlined,
                  size: isLargeScreen
                      ? 32
                      : 24, // Larger icons for tablet/desktop
                ),
                selectedIcon: Icon(
                  Icons.explore,
                  size: isLargeScreen ? 32 : 24,
                ),
                label: 'Dove Trail',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_outline,
                  size: isLargeScreen ? 32 : 24,
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  size: isLargeScreen ? 32 : 24,
                ),
                label: 'Tab 2',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.notifications_outlined,
                  size: isLargeScreen ? 32 : 24,
                ),
                selectedIcon: Icon(
                  Icons.notifications,
                  size: isLargeScreen ? 32 : 24,
                ),
                label: 'Tab 3',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  size: isLargeScreen ? 32 : 24,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: isLargeScreen ? 32 : 24,
                ),
                label: 'Tab 4',
              ),
            ],
          );
        },
      ),
    );
  }
}
