import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/missions/stages/observe_stage.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'stage_scaffold.dart';

class LearnStage extends StatelessWidget {
  final MissionData mission;
  const LearnStage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StageScaffold(
      stageNumber: 1,
      stageTitle: 'Learn',
      missionNumber: mission.number,
      iconPath: 'assets/pixel_images/book.png',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stage description
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Color(0xFFE68C8C), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Study the vulnerability concept. You must complete this stage before proceeding.',
                    style: GoogleFonts.robotoMono(color: AppColorsOnLight.bodyText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mission title
          Text(
            'Mission ${mission.number}: ${mission.title}',
            style: GoogleFonts.orbitron(color: AppColorsOnLight.sectionLabel, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            mission.owaspCategory.isEmpty ? 'Orientation' : mission.owaspCategory,
            style: GoogleFonts.robotoMono(color: AppColorsOnLight.mutedText, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Learn content
          _buildContentCard(mission.learnContent),

          const SizedBox(height: 30),

          // Complete button
          _buildCompleteButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContentCard(String content) {
    final paragraphs = content.trim().split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        final isCode = para.trim().startsWith('\$') || para.trim().startsWith('SELECT') || para.trim().startsWith('//') || para.contains('→');
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: isCode
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1A0A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    para.trim(),
                    style: GoogleFonts.robotoMono(color: const Color(0xFF7FFF7F), fontSize: 12, height: 1.6),
                  ),
                )
              : Text(
                  para.trim(),
                  style: const TextStyle(color: AppColorsOnLight.bodyText, fontSize: 14, height: 1.7),
                ),
        );
      }).toList(),
    );
  }

  Widget _buildCompleteButton(BuildContext context) {
    final provider = context.read<AppProvider>();
    final progress = provider.getMissionProgress(mission.number);
    final alreadyDone = progress.completedStages.contains(MissionStage.learn);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (!alreadyDone) {
            provider.completeStage(mission.number, MissionStage.learn);
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ObserveStage(mission: mission)),
          );
        },
        icon: Icon(alreadyDone ? Icons.arrow_forward : Icons.check, size: 18),
        label: Text(
          alreadyDone ? 'PROCEED TO OBSERVE' : 'MARK AS LEARNED → NEXT',
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
