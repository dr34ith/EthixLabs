import 'package:flutter/material.dart';
import 'package:test_vuln/main/dashboard.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/missions/mission_01/mission_01.dart';
import 'package:test_vuln/main/mission.dart'; // Add this import
import 'intro/intro.dart';
import 'main/main_layout.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EthixLabs',
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.themeData,
      // Define named routes
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/missions': (context) => const MissionsScreen(),
        '/mission_01': (context) => const Mission_01(),
      },

      onGenerateRoute: (settings) {

        return MaterialPageRoute(
          builder: (context) => IntroScreen(),
        );
      },
    );
  }
}