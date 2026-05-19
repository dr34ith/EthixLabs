import 'package:flutter/material.dart';
import 'package:test_vuln/intro/intro.dart';
import 'package:test_vuln/main/main_layout.dart';
import 'package:test_vuln/services/hive_service.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await HiveService.loadMissionsFromAssets();
  runApp(const EthixLabsApp());
}

class EthixLabsApp extends StatelessWidget {
  const EthixLabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EthixLabs',
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.themeData,
      home: IntroScreen(),
      routes: {
        '/main': (context) => const MainLayout(),
      },
    );
  }
}
