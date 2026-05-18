import 'package:flutter/material.dart';
import 'package:test_vuln/main/dashboard.dart';
import 'package:test_vuln/main/library.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/main/notification.dart';
import 'package:test_vuln/main/profilescreen.dart';
import 'package:test_vuln/main/shop.dart';
import 'package:test_vuln/main/settings.dart';
import 'package:test_vuln/theme/cyber_theme.dart';
/*import 'vulnbot_screen.dart';
import 'shop_screen.dart'; */
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  /*final List<Widget> _pages = [
  const VulnBotScreen(),   // Your existing VulnBot screen
  ];
  */

  // For now, just placeholders to avoid errors
  final List<Widget> _pages = [
    const DashboardScreen(), // Home screen will go here
    const MissionsScreen(), // Missions screen will go here
    Container(), // VulnBot screen will go here
    const LibraryScreen(), // Library screen will go here
  const ShopScreen(),   // Shop screen will go here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========== APPBAR ==========
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo
            Image.asset(
              'assets/icons/EthixLabs_LOGO.png',
              height: 120,
              width: 120,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.apps, size: 40);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          // Notification icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                },
              ),
            ],
          ),
          // Profile icon
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
        backgroundColor: CyberTheme.navigationBackground,
        elevation: 2,
        foregroundColor: Colors.white,
      ),

      // ========== BODY WITH BACKGROUND IMAGE ==========
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg3_noLogo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _pages[_selectedIndex],
      ),

      // ========== BOTTOM NAVIGATION BAR ==========
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: CyberTheme.primaryAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: CyberTheme.navigationBackground,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Missions',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/VulnbotAI_LOGO.png',
              width: 54,
              height: 54,
            ),
            label: 'VulnBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
  Widget buildAppBarIcon(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 60, color: Colors.white),
      splashRadius: 24,
      onPressed: onPressed,
    );
  }
}