import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/missions/stages/apply_stage.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'stage_scaffold.dart';

class AnalyzeStage extends StatelessWidget {
  final MissionData mission;
  const AnalyzeStage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StageScaffold(
      stageNumber: 5,
      stageTitle: 'Analyze Impact',
      missionNumber: mission.number,
      iconPath: 'assets/pixel_images/idea.png',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Colors.orange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Assess the real-world impact, severity score, and consequences of this vulnerability.',
                    style: GoogleFonts.robotoMono(color: AppColorsOnLight.bodyText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Impact content
          _buildAnalyzeContent(mission.analyzeContent),
          const SizedBox(height: 24),

          _buildNextButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAnalyzeContent(String content) {
    final paragraphs = content.trim().split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        final trimmed = para.trim();

        // CVSS score lines
        if (trimmed.contains('CVSS')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(trimmed, style: GoogleFonts.robotoMono(color: Colors.orange, fontSize: 12, height: 1.4))),
                ],
              ),
            ),
          );
        }

        // Bullet lists
        if (trimmed.contains('\n• ') || trimmed.startsWith('• ')) {
          final lines = trimmed.split('\n');
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((l) {
                final lt = l.trim();
                if (lt.startsWith('• ')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: AppColorsOnLight.sectionLabel, fontSize: 16)),
                        Expanded(child: Text(lt.substring(2), style: const TextStyle(color: AppColorsOnLight.bulletText, fontSize: 13, height: 1.5))),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(lt, style: const TextStyle(color: AppColorsOnLight.bodyText, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4)),
                );
              }).toList(),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(trimmed, style: const TextStyle(color: AppColorsOnLight.bodyText, fontSize: 14, height: 1.7)),
        );
      }).toList(),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final provider = context.read<AppProvider>();
    final progress = provider.getMissionProgress(mission.number);
    final alreadyDone = progress.completedStages.contains(MissionStage.analyze);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (!alreadyDone) {
            provider.completeStage(mission.number, MissionStage.analyze);
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => ApplyStage(mission: mission)));
        },
        icon: Icon(alreadyDone ? Icons.arrow_forward : Icons.check, size: 18),
        label: Text(
          alreadyDone ? 'PROCEED TO APPLY' : 'ANALYSIS COMPLETE → APPLY',
          style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsOnLight.buttonBg,
          foregroundColor: AppColorsOnLight.buttonText,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
