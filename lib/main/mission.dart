import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/services/hive_service.dart';
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
  int _selectedTab = 0;

  // Routes for implemented missions only
  static final Map<String, Widget Function()> _routes = {
    'The Unlocked Door':              () => const Mission_01(),
    'The Comment Trick':              () => const Mission_02(),
    'Who Owns This Order?':           () => const Mission_03(),
    'The "Urgent Verification" Email':() => const Mission_04(),
    'The Hidden Admin Panel':         () => const Mission_05(),
  };

  final List<Map<String, dynamic>> missions = [
    // ── Foundational ──
    {'tier':'Foundational','title':'The Unlocked Door',              'subtitle':'SQLi – Login Bypass',          'description':'Use a tautology payload to bypass authentication and log in as admin.','difficulty':'Easy','reward':'50 pts'},
    {'tier':'Foundational','title':'The Comment Trick',              'subtitle':'SQLi – Login Bypass with Comments','description':'Neutralize the password check using SQL comment syntax.','difficulty':'Easy','reward':'50 pts'},
    {'tier':'Foundational','title':'Who Owns This Order?',           'subtitle':'BAC – IDOR',                   'description':'Manipulate order IDs to access orders that belong to other users.','difficulty':'Easy','reward':'50 pts'},
    {'tier':'Foundational','title':'The "Urgent Verification" Email','subtitle':'BAC – Phishing',               'description':'Identify and resist a phishing attempt disguised as an urgent account alert.','difficulty':'Easy','reward':'50 pts'},
    {'tier':'Foundational','title':'The Hidden Admin Panel',         'subtitle':'BAC – Forced Browsing',        'description':'Locate and access a concealed admin login page through forced browsing.','difficulty':'Easy','reward':'50 pts'},
    // ── Intermediate ──
    {'tier':'Intermediate','title':'Retrieving Hidden Records',       'subtitle':'SQLi – UNION Extraction',      'description':'Inject a UNION query to extract usernames and passwords from the database.','difficulty':'Medium','reward':'75 pts'},
    {'tier':'Intermediate','title':"Someone Else's Profile",          'subtitle':'BAC – IDOR on Profile',        'description':"View another user's private profile data through an insecure direct object reference.",'difficulty':'Medium','reward':'75 pts'},
    {'tier':'Intermediate','title':'Changing Your Own Role',          'subtitle':'BAC – Role Parameter Tampering','description':'Escalate privileges by modifying hidden role parameters in requests.','difficulty':'Medium','reward':'75 pts'},
    {'tier':'Intermediate','title':'The "Fake Order Confirmation"',   'subtitle':'BAC – Phishing with Urgency',  'description':'Spot a convincing fake order confirmation email designed to steal your credentials.','difficulty':'Medium','reward':'75 pts'},
    {'tier':'Intermediate','title':'The Backup File Leak',            'subtitle':'BAC – Forced Browsing',        'description':'Find exposed backup files containing sensitive configuration data.','difficulty':'Medium','reward':'75 pts'},
    // ── Advanced ──
    {'tier':'Advanced','title':'Chain of Exploitation – SQLi + IDOR',    'subtitle':'SQLi + BAC – Combined Attack',  'description':'Combine SQL injection with IDOR vulnerabilities for deeper system access.','difficulty':'Hard','reward':'100 pts'},
    {'tier':'Advanced','title':'Admin + IDOR Chain',                       'subtitle':'Privilege Escalation & Mass IDOR','description':'Chain admin access with IDOR to compromise all user accounts at once.','difficulty':'Hard','reward':'100 pts'},
    {'tier':'Advanced','title':'Spear Phishing – Targeted Email Attack',   'subtitle':'BAC – Social Engineering',   'description':'Execute a targeted phishing campaign using personalized social engineering tactics.','difficulty':'Hard','reward':'100 pts'},
    {'tier':'Advanced','title':'Batch IDOR Harvest',                       'subtitle':'BAC – IDOR on Batch API',    'description':'Automate IDOR attacks against a batch API endpoint to harvest user data.','difficulty':'Hard','reward':'100 pts'},
    {'tier':'Advanced','title':'The Full VulnShop Audit',                  'subtitle':'Comprehensive Capstone',     'description':'Perform a complete security audit of VulnShop, chaining all learned techniques.','difficulty':'Hard','reward':'150 pts'},
  ];

  List<Map<String, dynamic>> get _filtered {
    switch (_selectedTab) {
      case 1: return missions.where((m) => m['tier'] == 'Foundational').toList();
      case 2: return missions.where((m) => m['tier'] == 'Intermediate').toList();
      case 3: return missions.where((m) => m['tier'] == 'Advanced').toList();
      default: return missions;
    }
  }

  bool _isCompleted(String title) {
    try {
      final all = HiveService.getAllMissions();
      final match = all.firstWhere((m) => m['title'] == title, orElse: () => {});
      if (match.isEmpty) return false;
      return HiveService.isMissionCompleted(match['id'] as String);
    } catch (_) { return false; }
  }

  String _recommendedTitle() {
    try {
      return missions.firstWhere(
        (m) => !_isCompleted(m['title'] as String),
        orElse: () => missions.first)['title'] as String;
    } catch (_) { return missions.first['title'] as String; }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final hp = sw * 0.05;
    final vs = MediaQuery.of(context).size.height * 0.02;

    return BackgroundStack(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.all(hp),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('LEARNING MISSIONS',
                style: GoogleFonts.orbitron(fontSize: 28, fontWeight: FontWeight.bold,
                  color: CyberTheme.primaryAccent, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Text('Complete 15 structured missions to earn your certificate.',
                style: TextStyle(fontSize: 12, color: CyberTheme.textMuted)),
            ])),
          SizedBox(height: vs * 0.5),

          // Recommended card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hp),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: CyberTheme.glowBoxDecoration(backgroundColor: CyberTheme.surface, borderRadius: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('RECOMMENDED FOR YOU',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: CyberTheme.primaryAccent, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(_recommendedTitle(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ]))),
          SizedBox(height: vs * 1.5),

          // Mission list card
          Container(
            decoration: BoxDecoration(
              color: const Color(0x47000000),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: CyberTheme.primaryAccent, width: 1)),
            child: Padding(
              padding: EdgeInsets.all(sw * 0.04),
              child: Column(children: [
                // Tabs
                Row(children: [
                  _tab('All', 0), _tab('Foundational', 1),
                  _tab('Intermediate', 2), _tab('Advanced', 3),
                ]),
                const SizedBox(height: 24),

                // Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final m = _filtered[i];
                    final title = m['title'] as String;
                    final origIdx = missions.indexWhere((x) => x['title'] == title);
                    final completed = _isCompleted(title);
                    final hasRoute = _routes.containsKey(title);
                    final difficulty = m['difficulty'] as String;
                    final diffColor = difficulty == 'Easy'
                      ? Colors.green : difficulty == 'Medium' ? Colors.orange : Colors.red;
                    return GestureDetector(
                      onTap: () {
                        final builder = _routes[title];
                        if (builder != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => builder()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mission "$title" — coming soon!')));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                        padding: EdgeInsets.all(sw * 0.04),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            CyberTheme.primaryAccent.withOpacity(0.05), Colors.black.withOpacity(0.4)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: hasRoute
                              ? CyberTheme.primaryAccent.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.3),
                            width: 1.5),
                          boxShadow: [BoxShadow(
                            color: CyberTheme.primaryAccent.withOpacity(0.1),
                            blurRadius: 8, offset: const Offset(0, 4))]),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Text('Mission ${origIdx + 1}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                  color: CyberTheme.primaryAccent)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: diffColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: diffColor)),
                                child: Text(difficulty,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: diffColor))),
                              const SizedBox(width: 8),
                              Text('· ${m['tier']}',
                                style: const TextStyle(fontSize: 11, color: CyberTheme.textMuted)),
                            ]),
                            const SizedBox(height: 4),
                            Text(title,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,
                                color: hasRoute ? Colors.white : Colors.grey)),
                            Text(m['subtitle'] as String,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CyberTheme.primaryAccent)),
                            const SizedBox(height: 6),
                            Text(m['description'] as String,
                              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8))),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.star, color: CyberTheme.primaryAccent, size: 14),
                              const SizedBox(width: 4),
                              Text(m['reward'] as String,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                  color: CyberTheme.primaryAccent)),
                            ]),
                          ])),
                          const SizedBox(width: 16),
                          Container(
                            width: sw * 0.08, height: sw * 0.08,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: completed ? CyberTheme.primaryAccent : Colors.transparent,
                              border: Border.all(color: CyberTheme.primaryAccent, width: 2),
                              boxShadow: completed ? [BoxShadow(
                                color: CyberTheme.primaryAccent.withOpacity(0.5),
                                blurRadius: 8, spreadRadius: 2)] : null),
                            child: completed
                              ? const Icon(Icons.check, color: CyberTheme.background, size: 20)
                              : hasRoute ? null : const Icon(Icons.lock, color: Colors.grey, size: 16)),
                        ])));
                  }),
              ]))),
          SizedBox(height: vs * 2),
        ]),
      ),
    );
  }

  Widget _tab(String title, int index) {
    final sel = _selectedTab == index;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: sel ? CyberTheme.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(70)),
        child: Text(title, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
            color: sel ? const Color(0xFF0A0A0F) : Colors.grey.shade300)))));
  }
}
