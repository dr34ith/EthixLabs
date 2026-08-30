import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/widgets/glow_card.dart';
import 'package:ethixlabs/core/widgets/breathing_glow.dart';
import 'package:ethixlabs/missions/mission_detail.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/core/widgets/screen_title_header.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _selectedTab = 0;

  static const _tabs = ['All', 'Basics', 'Foundational', 'Intermediate', 'Advanced'];

  final Map<int, Map<String, String>> _tierObjectives = {
    0: {'tier': 'All Missions', 'text': 'Complete all 25 missions across all tiers to earn your EthixLabs certificate.'},
    1: {'tier': 'Basics', 'text': 'Get familiar with the VulnShop environment, the ethical hacking mindset, and the six-stage workflow.'},
    2: {'tier': 'Foundational', 'text': 'Master Broken Access Control and Injection attacks through hands-on payload testing.'},
    3: {'tier': 'Intermediate', 'text': 'Explore Authentication Failures, Security Misconfiguration, Cryptographic Failures, and AI Prompt Injection.'},
    4: {'tier': 'Advanced', 'text': 'Chain multiple vulnerabilities to compromise VulnShop completely.'},
  };

  List<MissionData> _getFilteredMissions() {
    if (_selectedTab == 0) return allMissions;
    final tier = _tabs[_selectedTab];
    return allMissions.where((m) => m.tier == tier).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final obj = _tierObjectives[_selectedTab]!;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            const ScreenTitleHeader(
              title: 'Missions',
              subtitle: 'Complete 25 missions to earn your certificate.',
            ),
            const SizedBox(height: 16),

            // ── Objectives Card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.9), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Objectives:', style: GoogleFonts.orbitron(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(obj['tier']!, style: GoogleFonts.orbitron(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      obj['text']!,
                      style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Mission List ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Filter tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildTab(e.value, e.key),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mission cards
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _getFilteredMissions().length,
                    itemBuilder: (context, index) {
                      final mission = _getFilteredMissions()[index];
                      final progress = provider.getMissionProgress(mission.number);
                      final isUnlocked = provider.isMissionUnlocked(mission.number);
                      return _buildMissionCard(context, mission, progress, isUnlocked);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.accent : Colors.white12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, MissionData mission, MissionProgress progress, bool isUnlocked) {
    // Sequential unlocking means at most one mission is ever both unlocked
    // and incomplete at a time — the "current" one the player should do next.
    final isCurrentActive = isUnlocked && !progress.missionCompleted;
    return GestureDetector(
      onTap: () {
        if (!isUnlocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Complete Mission ${mission.number - 1} first to unlock this.'),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => MissionDetailScreen(mission: mission)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Opacity(
          opacity: isUnlocked ? 1.0 : 0.5,
          child: _wrapIfCurrentActive(
            isCurrentActive,
            GlowCard(
              neon: progress.missionCompleted ? Colors.green : AppColors.accent,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 68,
                    height: 68,
                    color: const Color(0xFF151515),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/pixel_images/missionbymission_BG.png',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            mission.iconPath,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.bug_report, color: Colors.white70),
                          ),
                        ),
                        if (!isUnlocked)
                          Container(
                            color: Colors.black.withOpacity(0.6),
                            child: const Center(child: Icon(Icons.lock, color: Colors.white54, size: 22)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mission ${mission.number} · ${mission.tier}',
                        style: GoogleFonts.robotoMono(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(mission.title, style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(mission.subtitle, style: GoogleFonts.robotoMono(color: AppColors.accent, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        mission.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.4),
                      ),
                      if (progress.missionCompleted) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.green, size: 14),
                            const SizedBox(width: 4),
                            Text('Complete · ${progress.starsEarned}★',
                                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ] else if (progress.completedStages.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text('${progress.completedStages.length}/6 stages',
                            style: TextStyle(color: AppColors.accent.withOpacity(0.7), fontSize: 11)),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                // Status
                progress.missionCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                    : isUnlocked
                        ? Icon(Icons.arrow_forward_ios, color: AppColors.accent, size: 14)
                        : const Icon(Icons.lock, color: Colors.white24, size: 18),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapIfCurrentActive(bool isCurrentActive, Widget child) {
    if (!isCurrentActive) return child;
    return BreathingGlow(
      color: AppColors.crimsonGlow,
      borderRadius: BorderRadius.circular(14),
      child: child,
    );
  }
}
