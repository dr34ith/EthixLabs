import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/missions/stages/test_stage.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'stage_scaffold.dart';

class ObserveStage extends StatelessWidget {
  final MissionData mission;
  const ObserveStage({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StageScaffold(
      stageNumber: 2,
      stageTitle: 'Observe',
      missionNumber: mission.number,
      iconPath: 'assets/pixel_images/eye.png',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye, color: Colors.blue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Carefully examine the target application. Map attack surfaces before testing.',
                    style: GoogleFonts.robotoMono(color: AppColorsOnLight.bodyText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // VulnShop preview banner
          _VulnShopBanner(),
          const SizedBox(height: 20),

          // Observe content
          _buildObserveContent(mission.observeContent),
          const SizedBox(height: 30),

          _buildNextButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildObserveContent(String content) {
    final lines = content.trim().split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) return const SizedBox(height: 8);
        final isCheckbox = trimmed.startsWith('□');
        final isChecked = trimmed.startsWith('✓');
        final isHeader = trimmed.endsWith(':') && !isCheckbox;

        if (isHeader) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(trimmed, style: GoogleFonts.orbitron(color: AppColorsOnLight.sectionLabel, fontSize: 12, fontWeight: FontWeight.bold)),
          );
        }
        if (isCheckbox || isChecked) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isChecked ? Colors.green.shade700 : AppColorsOnLight.mutedText, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  trimmed.substring(2),
                  style: const TextStyle(color: AppColorsOnLight.bodyText, fontSize: 13, height: 1.4),
                )),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(trimmed, style: const TextStyle(color: AppColorsOnLight.bulletText, fontSize: 13, height: 1.6)),
        );
      }).toList(),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final provider = context.read<AppProvider>();
    final progress = provider.getMissionProgress(mission.number);
    final alreadyDone = progress.completedStages.contains(MissionStage.observe);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (!alreadyDone) {
            provider.completeStage(mission.number, MissionStage.observe);
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => TestStage(mission: mission)));
        },
        icon: Icon(alreadyDone ? Icons.arrow_forward : Icons.check, size: 18),
        label: Text(
          alreadyDone ? 'PROCEED TO TEST' : 'OBSERVATION COMPLETE → TEST',
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

class _VulnShopBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE68C8C).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Image.asset('assets/icons/vulnShop.png', height: 36,
              errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart, color: Color(0xFFE68C8C), size: 32)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VulnShop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Simulated e-commerce target — observe its features below',
                    style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
