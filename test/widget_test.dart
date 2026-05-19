import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:test_vuln/intro/intro.dart';
import 'package:test_vuln/auth/login.dart';
import 'package:test_vuln/auth/signup.dart';
import 'package:test_vuln/main/dashboard.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/main/notification.dart';
import 'package:test_vuln/main/profilescreen.dart';
import 'package:test_vuln/main/main_layout.dart';
import 'package:test_vuln/services/hive_service.dart';
import 'package:test_vuln/services/regex_engine.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.themeData,
      home: child,
    );

Future<void> _loginTestUser() async {
  try {
    await HiveService.registerUser('tester', 'password123', 'Tester User');
  } catch (_) {}
  await HiveService.loginUser('tester', 'password123');
  await HiveService.setCurrentUser('tester');
  await HiveService.setDisplayName('Tester User');
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('missions');
    await Hive.openBox('users');
    await Hive.openBox('userProgress');
    await HiveService.loadMissionsFromAssets();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  // ==================== IntroScreen ====================
  group('IntroScreen', () {
    testWidgets('renders headline text', (tester) async {
      await tester.pumpWidget(_wrap(IntroScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('LEARN SECURITY'), findsOneWidget);
    });

    testWidgets('renders START THE MISSION button', (tester) async {
      await tester.pumpWidget(_wrap(IntroScreen()));
      await tester.pumpAndSettle();
      expect(find.text('START THE MISSION'), findsOneWidget);
    });

    testWidgets('tapping START navigates to SignupScreen', (tester) async {
      await tester.pumpWidget(_wrap(IntroScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('START THE MISSION'));
      await tester.pumpAndSettle();
      expect(find.byType(SignupScreen), findsOneWidget);
    });
  });

  // ==================== LoginScreen ====================
  group('LoginScreen', () {
    testWidgets('renders LOG-IN button', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text('LOG IN'), findsOneWidget);
    });

    testWidgets('renders username and password fields', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('shows snackbar if username empty', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LOG IN'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Sign-up link is visible', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('tapping Sign-up navigates to SignupScreen', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.byType(SignupScreen), findsOneWidget);
    });
  });

  // ==================== SignupScreen ====================
  group('SignupScreen', () {
    testWidgets('renders SIGN UP button', (tester) async {
      await tester.pumpWidget(_wrap(const SignupScreen()));
      await tester.pumpAndSettle();
      expect(find.text('SIGN UP'), findsOneWidget);
    });

    testWidgets('shows error if username empty', (tester) async {
      await tester.pumpWidget(_wrap(const SignupScreen()));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '');
      await tester.enterText(fields.at(1), 'pass123');
      await tester.enterText(fields.at(2), 'pass123');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows error if passwords do not match', (tester) async {
      await tester.pumpWidget(_wrap(const SignupScreen()));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'juan123');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'different456');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows error if password under 8 chars', (tester) async {
      await tester.pumpWidget(_wrap(const SignupScreen()));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'juan123');
      await tester.enterText(fields.at(1), 'short');
      await tester.enterText(fields.at(2), 'short');
      await tester.tap(find.text('SIGN UP'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Log-in link is visible', (tester) async {
      await tester.pumpWidget(_wrap(const SignupScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Log in'), findsOneWidget);
    });
  });

  // ==================== DashboardScreen ====================
  group('DashboardScreen', () {
    setUp(() async {
      await _loginTestUser();
    });

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('shows MISSION PROGRESS text', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('MISSION PROGRESS'), findsOneWidget);
    });

    testWidgets('shows WELCOME BACK text', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('WELCOME BACK'), findsOneWidget);
    });

    testWidgets('shows tier stat cards', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('FOUNDATIONAL'), findsOneWidget);
      expect(find.textContaining('INTERMEDIATE'), findsOneWidget);
      expect(find.textContaining('ADVANCED'), findsOneWidget);
    });

    testWidgets('shows SYSTEM DIAGNOSTIC hero card', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('SYSTEM DIAGNOSTIC'), findsOneWidget);
    });

    testWidgets('shows RECOMMENDED MISSION card', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('RECOMMENDED MISSION'), findsOneWidget);
    });

    testWidgets('shows quick link labels', (tester) async {
      await tester.pumpWidget(_wrap(const DashboardScreen()));
      await tester.pumpAndSettle();
      expect(find.text('VulnShop'), findsOneWidget);
      expect(find.text('VulnBot'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
    });
  });

  // ==================== MissionsScreen ====================
  group('MissionsScreen', () {
    setUp(() async {
      await _loginTestUser();
    });

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(MissionsScreen), findsOneWidget);
    });

    testWidgets('shows LEARNING MISSIONS header', (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('LEARNING MISSIONS'), findsOneWidget);
    });

    testWidgets('shows tab bar with All / Foundational / Intermediate / Advanced',
        (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Foundational'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('shows Mission 1 — The Unlocked Door', (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('The Unlocked Door'), findsWidgets);
    });

    testWidgets('switching to Foundational tab shows foundational missions',
        (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Foundational'));
      await tester.pumpAndSettle();
      expect(find.textContaining('The Unlocked Door'), findsOneWidget);
      expect(find.textContaining('The Comment Trick'), findsOneWidget);
      expect(find.textContaining('Who Owns This Order?'), findsOneWidget);
    });

    testWidgets('switching to Advanced tab shows Advanced missions',
        (tester) async {
      await tester.pumpWidget(_wrap(const MissionsScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Chain of Exploitation'), findsOneWidget);
      expect(find.textContaining('Batch IDOR Harvest'), findsOneWidget);
    });
  });

  // ==================== NotificationScreen ====================
  group('NotificationScreen', () {
    setUp(() async {
      await _loginTestUser();
    });

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const NotificationScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationScreen), findsOneWidget);
    });

    testWidgets('shows Claimed Flags title', (tester) async {
      await tester.pumpWidget(_wrap(const NotificationScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Claimed Flags'), findsOneWidget);
    });

    testWidgets('shows empty state when no flags earned yet', (tester) async {
      await HiveService.resetAllProgress();
      await tester.pumpWidget(_wrap(const NotificationScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('No flags claimed yet.'), findsOneWidget);
    });
  });

  // ==================== ProfileScreen ====================
  group('ProfileScreen', () {
    setUp(() async {
      await _loginTestUser();
    });

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('shows Profile in AppBar', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('shows ACCOUNT INFORMATION section', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('ACCOUNT INFORMATION'), findsOneWidget);
    });

    testWidgets('shows stat cards', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Missions Completed'), findsOneWidget);
      expect(find.text('Flags Earned'), findsOneWidget);
    });

    testWidgets('shows LOGOUT button', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      expect(find.text('LOGOUT'), findsOneWidget);
    });

    testWidgets('tapping LOGOUT shows confirmation dialog', (tester) async {
      await tester.pumpWidget(_wrap(const ProfileScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LOGOUT'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
    });
  });

  // ==================== MainLayout ====================
  group('MainLayout', () {
    setUp(() async {
      await _loginTestUser();
    });

    testWidgets('renders bottom nav with correct items', (tester) async {
      await tester.pumpWidget(_wrap(const MainLayout()));
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Missions'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
    });

    testWidgets('tapping Missions tab shows MissionsScreen', (tester) async {
      await tester.pumpWidget(_wrap(const MainLayout()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Missions'));
      await tester.pumpAndSettle();
      expect(find.textContaining('LEARNING MISSIONS'), findsOneWidget);
    });

    testWidgets('tapping Home tab shows DashboardScreen', (tester) async {
      await tester.pumpWidget(_wrap(const MainLayout()));
      await tester.pumpAndSettle();
      expect(find.textContaining('WELCOME BACK'), findsOneWidget);
    });
  });

  // ==================== HiveService Unit Tests ====================
  group('HiveService', () {
    setUp(() async {
      await _loginTestUser();
      await HiveService.resetAllProgress();
    });

    test('setDisplayName and getDisplayName round-trip', () async {
      await HiveService.setDisplayName('Maria Santos');
      expect(HiveService.getDisplayName(), equals('Maria Santos'));
    });

    test('getDisplayName returns default when no name set', () async {
      await HiveService.resetAllProgress();
      final name = HiveService.getDisplayName();
      expect(name, equals('Ethical Hacker'));
    });

    test('completeMission marks mission as completed', () async {
      await HiveService.completeMission('sqli_01', stars: 1);
      expect(HiveService.isMissionCompleted('sqli_01'), isTrue);
    });

    test('isMissionCompleted returns false for uncompleted mission', () async {
      expect(HiveService.isMissionCompleted('sqli_02'), isFalse);
    });

    test('getFlags returns correct count after completions', () async {
      await HiveService.completeMission('sqli_01', stars: 1);
      await HiveService.completeMission('sqli_02', stars: 1);
      expect(HiveService.getFlags(), equals(2));
    });

    test('getProgressSummary returns correct completedMissions count', () async {
      await HiveService.completeMission('sqli_01', stars: 1);
      final summary = HiveService.getProgressSummary();
      expect(summary['completedMissions'], equals(1));
    });

    test('progressFraction is between 0.0 and 1.0', () async {
      final summary = HiveService.getProgressSummary();
      final fraction = summary['progressFraction'] as double;
      expect(fraction, inInclusiveRange(0.0, 1.0));
    });

    test('resetProgress clears all completion data', () async {
      await HiveService.completeMission('sqli_01', stars: 1);
      await HiveService.resetAllProgress();
      expect(HiveService.isMissionCompleted('sqli_01'), isFalse);
      expect(HiveService.getFlags(), equals(0));
    });

    test('getAllMissions returns 15 missions', () {
      final missions = HiveService.getAllMissions();
      expect(missions.length, equals(15));
    });
  });

  // ==================== RegexEngine Unit Tests ====================
  group('RegexEngine', () {
    test('sqli_01: tautology payload passes', () {
      final result = RegexEngine.checkForMission("' OR '1'='1", 'sqli_auth');
      expect(result, isTrue);
    });

    test('sqli_01: wrong payload fails', () {
      final result = RegexEngine.checkForMission('hello', 'sqli_auth');
      expect(result, isFalse);
    });

    test('sqli_02: comment payload passes', () {
      final result = RegexEngine.checkForMission("admin'--", 'sqli_auth');
      expect(result, isTrue);
    });

    test('sqli_02: wrong payload fails', () {
      final result = RegexEngine.checkForMission('notacomment', 'sqli_auth');
      expect(result, isFalse);
    });

    test('bac_01: IDOR payload passes', () {
      final result = RegexEngine.checkForMission('?order_id=2', 'idor');
      expect(result, isTrue);
    });

    test('isSQLiAuth returns true for tautology payload', () {
      expect(RegexEngine.isSQLiAuth("' OR '1'='1"), isTrue);
    });

    test('isSQLiAuth returns false for benign input', () {
      expect(RegexEngine.isSQLiAuth('hello'), isFalse);
    });

    test('unknown mission type returns false gracefully', () {
      final result = RegexEngine.checkForMission('test', 'unknown_type_99');
      expect(result, isFalse);
    });
  });
}