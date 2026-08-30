import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/missions/stages/analyze_stage.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'package:ethixlabs/core/widgets/reactive_glow.dart';
import 'stage_scaffold.dart';

class IdentifyStage extends StatefulWidget {
  final MissionData mission;
  const IdentifyStage({Key? key, required this.mission}) : super(key: key);

  @override
  State<IdentifyStage> createState() => _IdentifyStageState();
}

class _IdentifyStageState extends State<IdentifyStage> {
  int? _selectedIndex;
  bool _submitted = false;

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() => _submitted = true);
    final correct = _selectedIndex == widget.mission.identifyCorrectIndex;
    if (correct) {
      final provider = context.read<AppProvider>();
      final progress = provider.getMissionProgress(widget.mission.number);
      if (!progress.completedStages.contains(MissionStage.identify)) {
        provider.completeStage(widget.mission.number, MissionStage.identify);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<AppProvider>().getMissionProgress(widget.mission.number);
    final alreadyDone = progress.completedStages.contains(MissionStage.identify);
    final isCorrect = _selectedIndex == widget.mission.identifyCorrectIndex;

    return StageScaffold(
      stageNumber: 4,
      stageTitle: 'Identify',
      missionNumber: widget.mission.number,
      iconPath: 'assets/pixel_images/sarch.png',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.purple, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Identify the vulnerability type based on what you observed and tested.',
                    style: GoogleFonts.robotoMono(color: AppColorsOnLight.bodyText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('What vulnerability did you find?',
              style: GoogleFonts.orbitron(color: AppColorsOnLight.bodyText, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Select the correct vulnerability category:',
              style: const TextStyle(color: AppColorsOnLight.mutedText, fontSize: 13)),
          const SizedBox(height: 16),

          // Options
          ...widget.mission.identifyOptions.asMap().entries.map((entry) {
            final i = entry.key;
            final option = entry.value;
            final isSelected = _selectedIndex == i;
            Color borderColor = AppColors.accent.withOpacity(0.3);
            Color bgColor = const Color(0xFF1E0A12);
            Widget? trailingWidget;

            if (_submitted || alreadyDone) {
              if (i == widget.mission.identifyCorrectIndex) {
                borderColor = Colors.green;
                bgColor = Colors.green.withOpacity(0.1);
                trailingWidget = const Icon(Icons.check_circle, color: Colors.green, size: 20);
              } else if (isSelected && i != widget.mission.identifyCorrectIndex) {
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
                color: i == widget.mission.identifyCorrectIndex ? Colors.green : Colors.red,
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

          // Feedback
          if (_submitted || alreadyDone) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (isCorrect || alreadyDone) ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (isCorrect || alreadyDone) ? Colors.green.withOpacity(0.4) : Colors.orange.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (isCorrect || alreadyDone) ? '✅ Correct! +1 ⭐ Star earned!' : '❌ Incorrect. Review the correct answer above.',
                    style: GoogleFonts.orbitron(
                      color: (isCorrect || alreadyDone) ? Colors.green : Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCorrect || alreadyDone) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.mission.identifyOptions[widget.mission.identifyCorrectIndex],
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyzeStage(mission: widget.mission))),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text('PROCEED TO ANALYZE', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsOnLight.buttonBg,
                  foregroundColor: AppColorsOnLight.buttonText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
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
                child: Text('SUBMIT ANSWER', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
