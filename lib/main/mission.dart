import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/theme/cyber_theme.dart';
import 'package:test_vuln/widgets/background_stack.dart';
import 'package:test_vuln/missions/mission_01/mission_01.dart';
import 'package:test_vuln/missions/mission_02/mission_02.dart';
import 'package:test_vuln/missions/mission_03/mission_03.dart';
import 'package:test_vuln/missions/mission_04/mission_04.dart';
import 'package:test_vuln/missions/mission_05/mission_05.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedTab = 0; // 0: All, 1: Foundational, 2: Intermediate, 3: Advanced

  late List<Map<String, dynamic>> missions;

  @override
  void initState() {
    super.initState();
    missions = [
      // ── Foundational Tier (Missions 1–5) ──
      {
        'tier': 'Foundational',
        'title': 'The Unlocked Door',
        'subtitle': 'SQLi – Login Bypass',
        'description': 'Use a tautology payload to bypass authentication and log in as admin.',
        'isCompleted': false,
        'difficulty': 'Easy',
        'reward': '50 pts',
      },
      {
        'tier': 'Foundational',
        'title': 'The Comment Trick',
        'subtitle': 'SQLi – Login Bypass with Comments',
        'description': 'Neutralize the password check using SQL comment syntax to gain access.',
        'isCompleted': false,
        'difficulty': 'Easy',
        'reward': '50 pts',
      },
      {
        'tier': 'Foundational',
        'title': 'Who Owns This Order?',
        'subtitle': 'BAC – IDOR',
        'description': 'Manipulate order IDs to access orders that belong to other users.',
        'isCompleted': false,
        'difficulty': 'Easy',
        'reward': '50 pts',
      },
      {
        'tier': 'Foundational',
        'title': 'The "Urgent Verification" Email',
        'subtitle': 'BAC – Phishing',
        'description': 'Identify and resist a phishing attempt disguised as an urgent account alert.',
        'isCompleted': false,
        'difficulty': 'Easy',
        'reward': '50 pts',
      },
      {
        'tier': 'Foundational',
        'title': 'The Hidden Admin Panel',
        'subtitle': 'BAC – Forced Browsing',
        'description': 'Locate and access a concealed admin login page through forced browsing.',
        'isCompleted': false,
        'difficulty': 'Easy',
        'reward': '50 pts',
      },

      // ── Intermediate Tier (Missions 6–10) ──
      {
        'tier': 'Intermediate',
        'title': 'Retrieving Hidden Records',
        'subtitle': 'SQLi – UNION Extraction',
        'description': 'Inject a UNION query to extract usernames and passwords from the database.',
        'isCompleted': false,
        'difficulty': 'Medium',
        'reward': '75 pts',
      },
      {
        'tier': 'Intermediate',
        'title': 'Someone Else\'s Profile',
        'subtitle': 'BAC – IDOR on Profile',
        'description': 'View another user\'s private profile data through an insecure direct object reference.',
        'isCompleted': false,
        'difficulty': 'Medium',
        'reward': '75 pts',
      },
      {
        'tier': 'Intermediate',
        'title': 'Changing Your Own Role',
        'subtitle': 'BAC – Role Parameter Tampering',
        'description': 'Escalate privileges by modifying hidden role parameters in requests.',
        'isCompleted': false,
        'difficulty': 'Medium',
        'reward': '75 pts',
      },
      {
        'tier': 'Intermediate',
        'title': 'The "Fake Order Confirmation"',
        'subtitle': 'BAC – Phishing with Urgency',
        'description': 'Spot a convincing fake order confirmation email designed to steal your credentials.',
        'isCompleted': false,
        'difficulty': 'Medium',
        'reward': '75 pts',
      },
      {
        'tier': 'Intermediate',
        'title': 'The Backup File Leak',
        'subtitle': 'BAC – Forced Browsing to Sensitive File',
        'description': 'Find exposed backup files containing sensitive configuration data.',
        'isCompleted': false,
        'difficulty': 'Medium',
        'reward': '75 pts',
      },

      // ── Advanced Tier (Missions 11–15) ──
      {
        'tier': 'Advanced',
        'title': 'Chain of Exploitation – SQLi + IDOR',
        'subtitle': 'SQLi + BAC – Combined Attack',
        'description': 'Combine SQL injection with IDOR vulnerabilities for deeper system access.',
        'isCompleted': false,
        'difficulty': 'Hard',
        'reward': '100 pts',
      },
      {
        'tier': 'Advanced',
        'title': 'Admin + IDOR Chain',
        'subtitle': 'Privilege Escalation & Mass IDOR',
        'description': 'Chain admin access with IDOR to compromise all user accounts at once.',
        'isCompleted': false,
        'difficulty': 'Hard',
        'reward': '100 pts',
      },
      {
        'tier': 'Advanced',
        'title': 'Spear Phishing – Targeted Email Attack',
        'subtitle': 'BAC – Social Engineering',
        'description': 'Execute a targeted phishing campaign using personalized social engineering tactics.',
        'isCompleted': false,
        'difficulty': 'Hard',
        'reward': '100 pts',
      },
      {
        'tier': 'Advanced',
        'title': 'Batch IDOR Harvest',
        'subtitle': 'BAC – IDOR on Batch API',
        'description': 'Automate IDOR attacks against a batch API endpoint to harvest user data.',
        'isCompleted': false,
        'difficulty': 'Hard',
        'reward': '100 pts',
      },
      {
        'tier': 'Advanced',
        'title': 'The Full VulnShop Audit',
        'subtitle': 'Comprehensive Capstone',
        'description': 'Perform a complete security audit of VulnShop, chaining all learned techniques.',
        'isCompleted': false,
        'difficulty': 'Hard',
        'reward': '150 pts',
      },
    ];
  }

  String _getRecommendedMission() {
    final incomplete = missions.firstWhere(
          (m) => m['isCompleted'] == false,
      orElse: () => missions[0],
    );
    return incomplete['title'];
  }

  String _getRecommendedDescription() {
    final incomplete = missions.firstWhere(
          (m) => m['isCompleted'] == false,
      orElse: () => missions[0],
    );
    return incomplete['description'];
  }

  String _getRecommendedTier() {
    final incomplete = missions.firstWhere(
          (m) => m['isCompleted'] == false,
      orElse: () => missions[0],
    );
    return incomplete['tier'];
  }

  List<Map<String, dynamic>> _getFilteredMissions() {
    if (_selectedTab == 0) return missions;
    if (_selectedTab == 1) return missions.where((m) => m['tier'] == 'Foundational').toList();
    if (_selectedTab == 2) return missions.where((m) => m['tier'] == 'Intermediate').toList();
    return missions.where((m) => m['tier'] == 'Advanced').toList();
  }

  void _navigateToMission(String title) {
    switch (title) {
      case 'The Unlocked Door':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_01()));
        break;
      case 'The Comment Trick':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_02()));
        break;
      case 'Who Owns This Order?':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_03()));
        break;
      case 'The "Urgent Verification" Email':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_04()));
        break;
      case 'The Hidden Admin Panel':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_05()));
        break;
    // case 'Retrieving Hidden Records':
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_06()));
    //   break;
    // case 'Someone Else\'s Profile':
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_07()));
    //   break;
    // case 'Changing Your Own Role':
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_08()));
    //   break;
    // case 'The "Fake Order Confirmation"':
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_09()));
    //   break;
    // case 'The Backup File Leak':
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const Mission_10()));
    //   break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mission "$title" coming soon!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return BackgroundStack(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // ── Title & Subtitle ──
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEARNING MISSIONS',
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: CyberTheme.primaryAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete 15 structured missions to earn your certificate.',
                      style: TextStyle(fontSize: 12, color: CyberTheme.textMuted),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),

              // ── Recommended Card ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: CyberTheme.glowBoxDecoration(
                    backgroundColor: CyberTheme.surface,
                    borderRadius: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RECOMMENDED FOR YOU',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CyberTheme.primaryAccent,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getRecommendedTier(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRecommendedMission(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRecommendedDescription(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 1.5),

            // ── Mission List Card ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0x47000000),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: CyberTheme.primaryAccent, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Tabs ──
                    Row(
                      children: [
                        _buildTab('All', 0),
                        _buildTab('Foundational', 1),
                        _buildTab('Intermediate', 2),
                        _buildTab('Advanced', 3),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Mission Cards ──
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _getFilteredMissions().length,
                      itemBuilder: (context, index) {
                        final mission = _getFilteredMissions()[index];
                        final originalIndex = missions.indexWhere(
                              (m) => m['title'] == mission['title'],
                        );
                        // Mission number = originalIndex + 1
                        return _buildMissionCard(
                          missionNumber: originalIndex + 1,
                          missionIndex: originalIndex,
                          tier: mission['tier'],
                          title: mission['title'],
                          subtitle: mission['subtitle'],
                          description: mission['description'],
                          isCompleted: mission['isCompleted'],
                          difficulty: mission['difficulty'] ?? 'Easy',
                          reward: mission['reward'] ?? '50 pts',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? CyberTheme.primaryAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(70),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF0A0A0F) : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard({
    required int missionNumber,
    required int missionIndex,
    required String tier,
    required String title,
    required String subtitle,
    required String description,
    required bool isCompleted,
    required String difficulty,
    required String reward,
  }) {
    Color difficultyColor = difficulty == 'Easy'
        ? Colors.green
        : difficulty == 'Medium'
            ? Colors.orange
            : Colors.red;

    return GestureDetector(
      onTap: () => _navigateToMission(title),
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CyberTheme.primaryAccent.withOpacity(0.05),
              Colors.black.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CyberTheme.primaryAccent.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: CyberTheme.primaryAccent.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission number + tier + difficulty badge
                  Row(
                    children: [
                      Text(
                        'Mission $missionNumber',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CyberTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: difficultyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: difficultyColor, width: 1),
                        ),
                        child: Text(
                          difficulty,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: difficultyColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· $tier',
                        style: const TextStyle(
                          fontSize: 11,
                          color: CyberTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Subtitle (technique tag)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: CyberTheme.primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Reward
                  Row(
                    children: [
                      const Icon(Icons.star, color: CyberTheme.primaryAccent, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        reward,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CyberTheme.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // ── Circle checkbox ──
            GestureDetector(
              onTap: () {
                setState(() {
                  missions[missionIndex]['isCompleted'] =
                  !missions[missionIndex]['isCompleted'];
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCompleted
                          ? 'Mission "$title" marked as incomplete'
                          : 'Mission "$title" completed! 🎉',
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: CyberTheme.primaryAccent,
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? CyberTheme.primaryAccent : Colors.transparent,
                  border: Border.all(color: CyberTheme.primaryAccent, width: 2),
                  boxShadow: isCompleted
                      ? [
                          BoxShadow(
                            color: CyberTheme.primaryAccent.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: CyberTheme.background, size: 20)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}