import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/missions/stages/learn_stage.dart';
import 'package:ethixlabs/missions/stages/observe_stage.dart';
import 'package:ethixlabs/missions/stages/test_stage.dart';
import 'package:ethixlabs/missions/stages/identify_stage.dart';
import 'package:ethixlabs/missions/stages/analyze_stage.dart';
import 'package:ethixlabs/missions/stages/apply_stage.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';

class MissionDetailScreen extends StatelessWidget {
  final MissionData mission;

  const MissionDetailScreen({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final progress = provider.getMissionProgress(mission.number);
    final unlocked = provider.isMissionUnlocked(mission.number);

    final stages = [
      _StageInfo(MissionStage.learn, 'Learn', 'Study the vulnerability concept and theory.', 'assets/pixel_images/book.png'),
      _StageInfo(MissionStage.observe, 'Observe', 'Examine the target and map attack surfaces.', 'assets/pixel_images/eye.png'),
      _StageInfo(MissionStage.test, 'Test', 'Submit payloads against the simulated target.', 'assets/pixel_images/test.png'),
      _StageInfo(MissionStage.identify, 'Identify', 'Name the vulnerability type and category.', 'assets/pixel_images/sarch.png'),
      _StageInfo(MissionStage.analyze, 'Analyze Impact', 'Assess severity, CVSS score, and real-world impact.', 'assets/pixel_images/idea.png'),
      _StageInfo(MissionStage.apply, 'Apply Remediation', 'Select and apply the correct security fix.', 'assets/pixel_images/pen.png'),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/icons/vulnShop.png',
              height: 54,
              errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC0392B), Color(0xFF922B21)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/mission_bg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColors.background),
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.55))),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Mission Header Card ──
                _buildHeaderCard(context, progress, unlocked),
                const SizedBox(height: 28),

                // ── Mission Steps ──
                Text(
                  'Mission Steps',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 14),

                ...stages.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stage = entry.value;
                  final isCompleted = progress.completedStages.contains(stage.stage);
                  final isUnlocked = provider.isStageUnlocked(mission.number, stage.stage);
                  return _buildStageCard(
                    context: context,
                    provider: provider,
                    stageInfo: stage,
                    stepNumber: i + 1,
                    isCompleted: isCompleted,
                    isUnlocked: isUnlocked && unlocked,
                  );
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, MissionProgress progress, bool unlocked) {
    final completedCount = progress.completedStages.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.6), width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.12), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tier badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'MISSION ${mission.number}',
                  style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                ),
                child: Text(
                  mission.tier.toUpperCase(),
                  style: GoogleFonts.robotoMono(fontSize: 10, color: AppColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${mission.subtitle.toUpperCase()}\n${mission.title.toUpperCase()}',
            style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, height: 1.3),
          ),
          const SizedBox(height: 10),
          Text(mission.description, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
          const SizedBox(height: 14),
          if (mission.owaspCategory.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Text(mission.owaspCategory, style: GoogleFonts.robotoMono(color: AppColors.accent, fontSize: 11)),
            ),
          const SizedBox(height: 16),
          // Progress indicator
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: completedCount / 6,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress.missionCompleted ? Colors.green : AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$completedCount/6', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          // Start/Continue button
          if (!progress.missionCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: unlocked ? () => _startMission(context) : null,
                icon: const Icon(Icons.chevron_right, size: 20),
                label: Text(
                  completedCount == 0 ? 'START MISSION' : 'CONTINUE MISSION',
                  style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: unlocked ? AppColors.accent : Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: BorderSide(color: unlocked ? AppColors.accent : Colors.grey, width: 1.5),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text('MISSION COMPLETE', style: GoogleFonts.orbitron(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('🏆 ${progress.starsEarned}★', style: const TextStyle(fontSize: 13, color: Colors.amber)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _startMission(BuildContext context) {
    // Navigate to the first incomplete stage
    final provider = context.read<AppProvider>();
    final progress = provider.getMissionProgress(mission.number);
    MissionStage targetStage = MissionStage.learn;
    for (final s in MissionStage.values) {
      if (!progress.completedStages.contains(s)) {
        targetStage = s;
        break;
      }
    }
    _navigateToStage(context, targetStage);
  }

  void _navigateToStage(BuildContext context, MissionStage stage) {
    Widget screen;
    switch (stage) {
      case MissionStage.learn:
        screen = LearnStage(mission: mission);
        break;
      case MissionStage.observe:
        screen = ObserveStage(mission: mission);
        break;
      case MissionStage.test:
        screen = TestStage(mission: mission);
        break;
      case MissionStage.identify:
        screen = IdentifyStage(mission: mission);
        break;
      case MissionStage.analyze:
        screen = AnalyzeStage(mission: mission);
        break;
      case MissionStage.apply:
        screen = ApplyStage(mission: mission);
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildStageCard({
    required BuildContext context,
    required AppProvider provider,
    required _StageInfo stageInfo,
    required int stepNumber,
    required bool isCompleted,
    required bool isUnlocked,
  }) {
    return GestureDetector(
      onTap: isUnlocked
          ? () => _navigateToStage(context, stageInfo.stage)
          : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Complete the previous stage first.'), duration: Duration(seconds: 1)),
              ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.08)
                : isUnlocked
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted
                  ? Colors.green.withOpacity(0.5)
                  : isUnlocked
                      ? AppColors.accent.withOpacity(0.6)
                      : Colors.white12,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0A10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted ? Colors.green.withOpacity(0.5) : AppColors.accent.withOpacity(0.3),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        stageInfo.iconPath,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Icon(Icons.circle, color: AppColors.accent.withOpacity(0.5), size: 30),
                      ),
                    ),
                    if (!isUnlocked)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(Icons.lock, color: Colors.white38, size: 20)),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stageInfo.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.white : Colors.white38,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stageInfo.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.white60 : Colors.white24,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status icon
              isCompleted
                  ? const Icon(Icons.check_circle, color: Colors.green, size: 22)
                  : isUnlocked
                      ? Icon(Icons.arrow_forward_ios, color: AppColors.accent, size: 16)
                      : const Icon(Icons.lock, color: Colors.white24, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageInfo {
  final MissionStage stage;
  final String title;
  final String description;
  final String iconPath;
  const _StageInfo(this.stage, this.title, this.description, this.iconPath);
}
