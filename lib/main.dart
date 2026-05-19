import 'package:flutter/material.dart';
import 'package:test_vuln/auth/login.dart';
import 'package:test_vuln/intro/intro.dart';
import 'package:test_vuln/main/main_layout.dart';
import 'package:test_vuln/services/hive_service.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await HiveService.loadMissionsFromAssets();

  final isLoggedIn = HiveService.isLoggedIn();
  final initialRoute = isLoggedIn ? '/main' : '/intro';

  runApp(EthixLabsApp(initialRoute: initialRoute));
}

class EthixLabsApp extends StatelessWidget {
  final String initialRoute;
  const EthixLabsApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EthixLabs',
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.themeData,
      initialRoute: initialRoute,
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainLayout(),
      },
    );
  }
}