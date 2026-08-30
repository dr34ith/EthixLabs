import 'package:ethixlabs/main/dashboard.dart';
import 'package:ethixlabs/main/library.dart';
import 'package:ethixlabs/main/mission.dart';
import 'package:ethixlabs/main/notification.dart';
import 'package:ethixlabs/main/profilescreen.dart';
import 'package:ethixlabs/main/roadmap.dart';
import 'package:ethixlabs/core/widgets/ethix_app_bar.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const MissionsScreen(),
    const RoadmapScreen(),
    const LibraryScreen(),
  ];

  void switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EthixAppBar(
        onNotificationTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
        },
        onProfileTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        },
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: AppColors.bgPrimary.withOpacity(0.72),
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF3A46),
        unselectedItemColor: const Color(0xFF8B8285),
        showUnselectedLabels: true,
        backgroundColor: AppColors.bgPrimary,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Missions'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'RoadMap'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        ],
      ),
    );
  }
}
