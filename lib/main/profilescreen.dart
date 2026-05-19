import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/auth/login.dart';
import 'package:test_vuln/main/settings.dart';
import 'package:test_vuln/services/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userName;
  late int _completed;
  late int _flags;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final s = HiveService.getProgressSummary();
    _userName  = s['userName']          as String? ?? 'Ethical Hacker';
    _completed = s['completedMissions'] as int?    ?? 0;
    _flags     = s['flags']             as int?    ?? 0;
  }

  String _getRank() {
    if (_completed >= 13) return 'Expert';
    if (_completed >= 8)  return 'Proficient';
    if (_completed >= 4)  return 'Developing';
    return 'Beginner';
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final hp = sw * 0.05;
    final vs = sh * 0.02;
    final avatarSize = sw * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context))),
      body: SizedBox.expand(
        child: Stack(children: [
          Positioned.fill(child: Image.asset('assets/images/bg3_noLogo.jpg', fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: hp, vertical: vs),
              child: Column(children: [
                // Avatar
                Container(
                  width: avatarSize, height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: const Color(0xFF1A1A1D),
                    border: Border.all(color: const Color(0xFFFF8A8A).withOpacity(0.4), width: 2),
                    boxShadow: [BoxShadow(color: const Color(0x33FF8A8A), blurRadius: 6.0, spreadRadius: 0.5)]),
                  child: Icon(Icons.person, size: avatarSize * 0.5, color: Colors.white)),
                SizedBox(height: vs),
                Text(_userName,
                  style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold,
                    color: Colors.white, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(_getRank(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFFFF8A8A), fontWeight: FontWeight.w600)),
                SizedBox(height: vs * 1.5),

                // Account info card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(sw * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF8A8A).withOpacity(0.4), width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, spreadRadius: 1),
                      const BoxShadow(color: Color(0x33FF8A8A), blurRadius: 6.0, spreadRadius: 0.5)]),
                  child: Column(children: [
                    Text('ACCOUNT INFORMATION',
                      style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold,
                        color: Colors.white70, letterSpacing: 1.5)),
                    const SizedBox(height: 20),
                    Text(_userName,
                      style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold,
                        color: Colors.white, letterSpacing: 1.2), textAlign: TextAlign.center),
                  ])),
                SizedBox(height: vs * 1.5),

                // Stats
                Row(children: [
                  Expanded(child: _stat('Missions Completed', '$_completed', Icons.assignment_turned_in, sw)),
                  SizedBox(width: sw * 0.03),
                  Expanded(child: _stat('Flags Earned', '$_flags', Icons.flag, sw)),
                ]),
                SizedBox(height: vs),
                Row(children: [
                  Expanded(child: _stat('Total Points', '${_flags * 100}', Icons.star, sw)),
                  SizedBox(width: sw * 0.03),
                  Expanded(child: _stat('Rank', _getRank(), Icons.emoji_events, sw)),
                ]),
                SizedBox(height: vs * 1.5),

                // Settings button
                SizedBox(width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    icon: const Icon(Icons.settings),
                    label: const Text('SETTINGS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFFF8A8A)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                SizedBox(height: vs),

                // Logout button
                SizedBox(width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1D),
                        title: const Text('Logout', style: TextStyle(color: Colors.white)),
                        content: const Text('Are you sure you want to logout?',
                          style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (r) => false);
                            },
                            child: const Text('Logout', style: TextStyle(color: Colors.red))),
                        ])),
                    icon: const Icon(Icons.logout),
                    label: const Text('LOGOUT'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                SizedBox(height: vs * 1.5),
              ])),
          ),
        ])),
    );
  }

  Widget _stat(String title, String value, IconData icon, double sw) =>
    Container(
      padding: EdgeInsets.all(sw * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF8A8A).withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, spreadRadius: 1),
          const BoxShadow(color: Color(0x33FF8A8A), blurRadius: 6.0, spreadRadius: 0.5)]),
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center),
      ]));
}
