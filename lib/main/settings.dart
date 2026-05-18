import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_vuln/auth/login.dart';
import 'package:test_vuln/main/profilescreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeEnabled = prefs.getBool('darkMode') ?? true;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkModeEnabled = value;
    });
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD1D1),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your EthixLabs experience',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),

              // Profile Section
              _buildSectionHeader('Profile'),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.person,
                title: 'My Profile',
                subtitle: 'View and edit your profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.account_circle,
                title: 'Account Information',
                subtitle: 'Manage your account details',
                onTap: () {
                  _showComingSoon(context);
                },
              ),

              const SizedBox(height: 24),

              // App Preferences Section
              _buildSectionHeader('App Preferences'),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.palette,
                title: 'App Theme',
                subtitle: _darkModeEnabled ? 'Dark mode enabled' : 'Light mode enabled',
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    _saveDarkMode(value);
                  },
                  activeColor: const Color(0xFFE68C8C),
                ),
                onTap: () {
                  _saveDarkMode(!_darkModeEnabled);
                },
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: _notificationsEnabled ? 'Notifications enabled' : 'Notifications disabled',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    _saveNotifications(value);
                  },
                  activeColor: const Color(0xFFE68C8C),
                ),
                onTap: () {
                  _saveNotifications(!_notificationsEnabled);
                },
              ),

              const SizedBox(height: 24),

              // Learning Section
              _buildSectionHeader('Learning'),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.school,
                title: 'Learning Preferences',
                subtitle: 'Difficulty level and reminders',
                onTap: () {
                  _showComingSoon(context);
                },
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.bar_chart,
                title: 'Progress Tracking',
                subtitle: 'View your learning progress',
                onTap: () {
                  _showComingSoon(context);
                },
              ),

              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader('About'),
              const SizedBox(height: 12),
              _buildSettingsTile(
                icon: Icons.info,
                title: 'About EthixLabs',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: () {
                  _showComingSoon(context);
                },
              ),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () {
                  _showComingSoon(context);
                },
              ),

              const SizedBox(height: 32),

              // Logout Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE68C8C),
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE68C8C).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE68C8C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFE68C8C),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing else const Icon(Icons.chevron_right, color: Color(0xFFE68C8C)),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        backgroundColor: Color(0xFFE68C8C),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white38.withOpacity(0.5)),
        ),
        title: const Text(
          'About EthixLabs',
          style: TextStyle(
            color: Color(0xFFFFD1D1),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EthixLabs',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'A comprehensive cybersecurity learning platform designed to teach ethical hacking through hands-on missions and interactive challenges.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFE68C8C)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
