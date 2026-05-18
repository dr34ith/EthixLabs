import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/main/settings.dart';
import 'package:test_vuln/auth/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;
    final avatarSize = screenWidth * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg3_noLogo.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                children: [
                // Profile Avatar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1A1D),
                        border: Border.all(
                          color: const Color(0xFFFF8A8A).withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33FF8A8A),
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: avatarSize * 0.5,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                SizedBox(height: verticalSpacing * 1.5),

                // Account Information Section (Name Card)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF8A8A).withOpacity(0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: const Color(0x33FF8A8A),
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ACCOUNT INFORMATION',
                        style: GoogleFonts.orbitron(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Full Name centered
                      Text(
                        'Alex Brown',
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.5),

                // Stats Cards (vertically centered below Name Card)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Missions Completed',
                        '3',
                        Icons.assignment_turned_in,
                        screenWidth,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildStatCard(
                        'Flags Earned',
                        '5',
                        Icons.flag,
                        screenWidth,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: verticalSpacing),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Points',
                        '10',
                        Icons.star,
                        screenWidth,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildStatCard(
                        'Rank',
                        'Beginner',
                        Icons.emoji_events,
                        screenWidth,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: verticalSpacing * 1.5),

                // Settings Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('SETTINGS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFFF8A8A)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1D),
                            title: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('LOGOUT'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.5),
              ],
            ),
          ),
        ),
        ],
      ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF8A8A).withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0x33FF8A8A),
            blurRadius: 6.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}