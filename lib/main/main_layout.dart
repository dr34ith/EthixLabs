import 'package:flutter/material.dart';
import 'package:test_vuln/main/dashboard.dart';
import 'package:test_vuln/main/library.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/main/notification.dart';
import 'package:test_vuln/main/profilescreen.dart';
import 'package:test_vuln/main/shop.dart';
import 'package:test_vuln/main/vulnbot.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const MissionsScreen(),
    const VulnBotScreen(),
    const LibraryScreen(),
    const ShopScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final isVulnBot = _selectedIndex == 2;

    return Scaffold(
      appBar: isVulnBot ? null : AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/icons/EthixLabs_LOGO.png', height: 120, width: 120,
          errorBuilder: (_, __, ___) => const Icon(Icons.apps, size: 40)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()))),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()))),
        ],
        backgroundColor: CyberTheme.navigationBackground,
        elevation: 2,
        foregroundColor: Colors.white),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg3_noLogo.jpg'), fit: BoxFit.cover)),
        child: _pages[_selectedIndex]),

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
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Missions'),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/VulnbotAI_LOGO.png', width: 54, height: 54,
              errorBuilder: (_, __, ___) => const Icon(Icons.smart_toy_outlined)),
            label: 'VulnBot'),
          const BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shop'),
        ]),
    );
  }
}
