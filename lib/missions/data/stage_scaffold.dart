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

  // Mission 1's 6-stage workflow uses an orange accent instead of the
  // app-wide pink accent. Every other mission keeps AppColors.accent.
  static const Color _orange = Color(0xFFFF8A00);
  Color get _accent => missionNumber == 1 ? _orange : AppColors.accent;

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
                color: _accent,
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
        child: Container(
          // Darken the background photo so the white content card below
          // always has enough contrast, no matter how busy the image is.
          color: Colors.black.withOpacity(0.45),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _accent.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8)),
                    BoxShadow(color: _accent.withOpacity(0.15), blurRadius: 30, spreadRadius: -6),
                  ],
                ),
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
                            gradient: LinearGradient(
                              colors: [_accent.withOpacity(0.18), _accent.withOpacity(0.05)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _accent.withOpacity(0.6)),
                            boxShadow: [BoxShadow(color: _accent.withOpacity(0.2), blurRadius: 8)],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(iconPath, fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Icon(Icons.star, color: _accent)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STAGE $stageNumber OF 6',
                                style: GoogleFonts.robotoMono(color: _accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                              Text(
                                stageTitle.toUpperCase(),
                                style: GoogleFonts.orbitron(color: const Color(0xFF1A1A1A), fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        // VulnShop brand mark, echoing the storefront header
                        // used inside the VulnShop lab itself.
                        Image.asset(
                          'assets/icons/vulnShop.png',
                          height: 34,
                          errorBuilder: (c, e, s) => Icon(Icons.storefront, color: _accent, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Divider(color: _accent.withOpacity(0.25)),
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}