import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/features/profile/domain/user_level.dart';
import 'package:ethixlabs/features/profile/domain/user_level_service.dart';
import 'package:ethixlabs/features/profile/presentation/widgets/level_up_modal.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'package:ethixlabs/core/widgets/reactive_glow.dart';
import 'package:ethixlabs/core/widgets/ambient_background_glow.dart';
import 'stage_scaffold.dart';

class ApplyStage extends StatefulWidget {
  final MissionData mission;
  const ApplyStage({Key? key, required this.mission}) : super(key: key);

  @override
  State<ApplyStage> createState() => _ApplyStageState();
}

class _ApplyStageState extends State<ApplyStage> {
  int? _selectedIndex;
  bool _submitted = false;

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() => _submitted = true);
    final correct = _selectedIndex == widget.mission.applyCorrectIndex;
    if (correct) {
      final provider = context.read<AppProvider>();
      final progress = provider.getMissionProgress(widget.mission.number);
      UserLevel? leveledUpTo;
      if (!progress.completedStages.contains(MissionStage.apply)) {
        final previousLevel = _currentLevel(provider);
        provider.completeStage(widget.mission.number, MissionStage.apply);
        final newLevel = _currentLevel(provider);
        if (newLevel.level != previousLevel.level) {
          leveledUpTo = newLevel;
        }
      }
      _showMissionComplete(leveledUpTo: leveledUpTo);
    }
  }

  UserLevel _currentLevel(AppProvider provider) {
    return UserLevelService.calculateLevel(
      completedMissions: provider.completedMissions,
      postTestScore:
          provider.posttestDone ? provider.posttestScore.toDouble() : null,
    );
  }

  void _showMissionComplete({UserLevel? leveledUpTo}) {
    final provider = context.read<AppProvider>();
    final progress = provider.getMissionProgress(widget.mission.number);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1E0A12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: AmbientBackgroundGlow(
        glowColor: AppColors.gold,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trophy
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/pixel_images/TROPHY.png', fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.emoji_events, color: Colors.amber, size: 44)),
                ),
              ),
              const SizedBox(height: 16),
              Text('MISSION COMPLETE!', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              Text('Mission ${widget.mission.number}: ${widget.mission.title}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 16),

              // Stars earned
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(3, (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.star, color: i < progress.starsEarned ? Colors.amber : Colors.white24, size: 30),
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Text('${progress.starsEarned}/3 Stars', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 14)),
              const SizedBox(height: 16),

              // Flag
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/pixel_images/TROPHY.png', height: 20,
                            errorBuilder: (c, e, s) => const Icon(Icons.flag, color: Colors.green, size: 20)),
                        const SizedBox(width: 8),
                        Text('FLAG CAPTURED!', style: GoogleFonts.orbitron(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'FLAG{M${widget.mission.number}_COMPLETE}',
                      style: GoogleFonts.robotoMono(color: const Color(0xFF7FFF7F), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (widget.mission.chestUnlock != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_open, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Text('${widget.mission.chestUnlock} Unlocked!',
                          style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    if (leveledUpTo != null &&
                        await LevelUpTracker.shouldShow(leveledUpTo.level)) {
                      await LevelUpTracker.markShown(leveledUpTo.level);
                      if (mounted) {
                        await LevelUpModal.show(context, leveledUpTo);
                      }
                    }
                    if (!mounted) return;
                    // Pop back to mission detail or missions list
                    Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/missions');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('RETURN TO MISSIONS', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<AppProvider>().getMissionProgress(widget.mission.number);
    final alreadyDone = progress.completedStages.contains(MissionStage.apply);
    final isCorrect = _selectedIndex == widget.mission.applyCorrectIndex;

    return StageScaffold(
      stageNumber: 6,
      stageTitle: 'Apply Remediation',
      missionNumber: widget.mission.number,
      iconPath: 'assets/pixel_images/pen.png',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.build, color: Colors.teal, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Select the correct security fix to remediate this vulnerability.',
                    style: GoogleFonts.robotoMono(color: AppColorsOnLight.bodyText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Which remediation correctly fixes this vulnerability?',
              style: GoogleFonts.orbitron(color: AppColorsOnLight.bodyText, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Options
          ...widget.mission.applyOptions.asMap().entries.map((entry) {
            final i = entry.key;
            final option = entry.value;
            final isSelected = _selectedIndex == i;
            Color borderColor = AppColors.accent.withOpacity(0.3);
            Color bgColor = const Color(0xFF1E0A12);
            Widget? trailingWidget;

            if (_submitted || alreadyDone) {
              if (i == widget.mission.applyCorrectIndex) {
                borderColor = Colors.teal;
                bgColor = Colors.teal.withOpacity(0.1);
                trailingWidget = const Icon(Icons.check_circle, color: Colors.teal, size: 20);
              } else if (isSelected && i != widget.mission.applyCorrectIndex) {
                borderColor = Colors.red;
                bgColor = Colors.red.withOpacity(0.1);
                trailingWidget = const Icon(Icons.cancel, color: Colors.red, size: 20);
              }
            } else if (isSelected) {
              borderColor = AppColors.accent;
              bgColor = AppColors.accent.withOpacity(0.1);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReactiveGlow(
                color: i == widget.mission.applyCorrectIndex ? Colors.teal : Colors.red,
                borderRadius: BorderRadius.circular(12),
                onTap: (_submitted || alreadyDone) ? null : () => setState(() => _selectedIndex = i),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.accent : Colors.transparent,
                          border: Border.all(color: isSelected ? AppColors.accent : Colors.white38, width: 2),
                        ),
                        child: isSelected ? const Icon(Icons.circle, color: Colors.white, size: 10) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4))),
                      if (trailingWidget != null) ...[const SizedBox(width: 8), trailingWidget],
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          if (_submitted || alreadyDone) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (isCorrect || alreadyDone) ? Colors.teal.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (isCorrect || alreadyDone) ? Colors.teal.withOpacity(0.4) : Colors.orange.withOpacity(0.4)),
              ),
              child: Text(
                (isCorrect || alreadyDone)
                    ? '✅ Correct! +1 ⭐ Star earned! Mission complete!'
                    : '❌ Incorrect. The correct remediation is highlighted above.',
                style: GoogleFonts.orbitron(
                  color: (isCorrect || alreadyDone) ? Colors.teal : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (alreadyDone)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsOnLight.buttonBg,
                    foregroundColor: AppColorsOnLight.buttonText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('BACK TO MISSION', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedIndex != null ? AppColorsOnLight.buttonBg : Colors.grey.shade800,
                  foregroundColor: AppColorsOnLight.buttonText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('APPLY REMEDIATION', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
