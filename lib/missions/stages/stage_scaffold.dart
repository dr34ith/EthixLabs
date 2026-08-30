import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';

// Shared scaffold for all 6 mission stages
class StageScaffold extends StatelessWidget {
  final int stageNumber;
  final String stageTitle;
  final int missionNumber;
  final String iconPath;
  final Widget child;

  const StageScaffold({
    Key? key,
    required this.stageNumber,
    required this.stageTitle,
    required this.missionNumber,
    required this.iconPath,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'M$missionNumber',
                style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Stage $stageNumber: $stageTitle',
              style: GoogleFonts.orbitron(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/icons/vulnShop.png',
              height: 48,
              errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/missions_BG.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage header
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.accent.withOpacity(0.6)),
                        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 8)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(iconPath, fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.star, color: Color(0xFFE68C8C))),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STAGE $stageNumber OF 6',
                          style: GoogleFonts.robotoMono(color: AppColorsOnLight.sectionLabel, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                        ),
                        Text(
                          stageTitle.toUpperCase(),
                          style: GoogleFonts.orbitron(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.black26),
                const SizedBox(height: 16),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
