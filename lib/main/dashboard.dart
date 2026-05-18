import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/library/lib_01.dart';
import 'package:test_vuln/main/library.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/main/shop.dart';
import 'package:test_vuln/pretest/pretest_screen.dart';

/// ============================================================================
/// DASHBOARD SCREEN
/// ----------------------------------------------------------------------------
/// Deep obsidian (#0D0D0D) base, circuit-board overlay, deep-charcoal cards
/// (#1A1A1D) with high-intensity coral red (#FF8A8A) glows.
///
/// Visual order (top -> bottom):
///   1. Welcome header
///   2. Mission Progress card  (linear coral bar)
///   3. Tier stats row         (Foundational / Intermediate / Advanced)
///   4. SYSTEM DIAGNOSTIC PRE-TEST hero card  <- visually dominant
///   5. Recommended Mission - SQLi Login Bypass
///   6. Quick Links - VulnShop / VulnBot / Library
///   7. Footer - What is Ethical Hacking?
/// ============================================================================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ── Design tokens ──────────────────────────────────────────────────────────
  static const Color bg = Color(0xFF0D0D0D);          // Deep obsidian
  static const Color surface = Color(0xFF1A1A1D);     // Deep charcoal
  static const Color coralGlow = Color(0xFFFF8A8A);   // Soft coral (glow)
  static const Color coralSolid = Color(0xFFFF5F5F);  // Hot coral (CTA)
  static const Color metallicRed = Color(0xFFB23A48); // Metallic-red trim
  static const Color mutedCrimson = Color(0xFFE68C8C);

  // Spec: BoxShadow(color: #FF8A8A @0.2, blurRadius: 6, spreadRadius: 0)
  static List<BoxShadow> get minimalGlow => [
        BoxShadow(
          color: const Color(0x33FF8A8A),
          blurRadius: 6.0,
          spreadRadius: 0.5,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg3_noLogo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WelcomeHeader(),
                  SizedBox(height: verticalSpacing),

                  // 1. Mission Progress
                  const _MissionProgressCard(
                    completed: 7,
                    total: 15,
                    starsEarned: 32,
                  ),
                  SizedBox(height: verticalSpacing * 0.6),

                  // 2. Tier Stats row
                  Row(
                    children: const [
                      Expanded(
                        child: _TierStatCard(
                          title: 'Foundational',
                          progress: '5/5',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _TierStatCard(
                          title: 'Intermediate',
                          progress: '2/5',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _TierStatCard(
                          title: 'Advanced',
                          progress: '0/5',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing * 0.6),

                  // 3. HERO: System Diagnostic Pre-Test
                  _SystemDiagnosticHero(
                    onStart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreTestScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: verticalSpacing * 0.6),

                  // 4. Recommended Mission
                  _RecommendedMissionCard(
                    onStart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MissionsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: verticalSpacing * 0.6),

                  // 5. Quick Links
                  _QuickLinksRow(
                    onVulnShop: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShopScreen()),
                    ),
                    onVulnBot: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('VulnBot Assistant coming soon!'),
                        backgroundColor: coralGlow,
                      ),
                    ),
                    onLibrary: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LibraryScreen()),
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.6),

                  // 6. Footer info card
                  _EthicalHackingFooter(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EthicalHackingScreen(),
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 1.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared style helpers
// ─────────────────────────────────────────────────────────────────────────────
TextStyle _orbitron({
  double size = 16,
  FontWeight weight = FontWeight.w700,
  Color color = Colors.white,
  double letterSpacing = 1.2,
}) =>
    GoogleFonts.orbitron(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );

TextStyle _roboto({
  double size = 13,
  FontWeight weight = FontWeight.w400,
  Color color = Colors.white,
  double height = 1.4,
}) =>
    GoogleFonts.roboto(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );

BoxDecoration _cardDecoration({
  Color border = DashboardScreen.coralGlow,
  double borderWidth = 1.0,
  double radius = 16,
  bool glow = true,
}) =>
    BoxDecoration(
      color: DashboardScreen.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white38, width: borderWidth),
      boxShadow: glow ? DashboardScreen.minimalGlow : const [],
    );

// ─────────────────────────────────────────────────────────────────────────────
// Welcome header
// ─────────────────────────────────────────────────────────────────────────────
class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'WELCOME BACK, ALEX',
          style: _orbitron(
            size: 22,
            weight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your journey to becoming an ethical hacker continues.',
          textAlign: TextAlign.center,
          style: _roboto(size: 11, color: Colors.white.withOpacity(0.65)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mission Progress card  (header section with linear coral bar)
// ─────────────────────────────────────────────────────────────────────────────
class _MissionProgressCard extends StatelessWidget {
  const _MissionProgressCard({
    required this.completed,
    required this.total,
    required this.starsEarned,
  });

  final int completed;
  final int total;
  final int starsEarned;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;
    final starsTotal = 1175; // Fixed total stars
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MISSION PROGRESS',
            style: _orbitron(size: 14, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed / $total missions completed',
                style: _roboto(
                  size: 11,
                  color: Colors.white.withOpacity(0.9),
                  weight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 14, color: DashboardScreen.coralGlow),
                  const SizedBox(width: 4),
                  Text(
                    '$starsEarned / $starsTotal',
                    style: _roboto(
                      size: 12,
                      weight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  color: Colors.white.withOpacity(0.08),
                ),
                FractionallySizedBox(
                  widthFactor: pct.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          DashboardScreen.coralSolid,
                          DashboardScreen.coralGlow,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              DashboardScreen.coralGlow.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tier stat card  (Foundational / Intermediate / Advanced)
// ─────────────────────────────────────────────────────────────────────────────
class _TierStatCard extends StatelessWidget {
  const _TierStatCard({required this.title, required this.progress});

  final String title;
  final String progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: _cardDecoration(radius: 12, borderWidth: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: _orbitron(
              size: 10,
              letterSpacing: 1.2,
              color: DashboardScreen.mutedCrimson,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            progress,
            style: _orbitron(size: 20, weight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO: SYSTEM DIAGNOSTIC PRE-TEST
// Most visually dominant card — 1.5px metallic-red trim, pulsing outer glow.
// ─────────────────────────────────────────────────────────────────────────────
class _SystemDiagnosticHero extends StatefulWidget {
  const _SystemDiagnosticHero({required this.onStart});
  final VoidCallback onStart;

  @override
  State<_SystemDiagnosticHero> createState() => _SystemDiagnosticHeroState();
}

class _SystemDiagnosticHeroState extends State<_SystemDiagnosticHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_pulse.value);
        final glowOpacity = 0.45 + 0.35 * t;
        final spread = -1.0 + 4.0 * t;
        final blur = 22.0 + 16.0 * t;

        return Container(
          decoration: BoxDecoration(
            color: DashboardScreen.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.lerp(
                DashboardScreen.metallicRed,
                DashboardScreen.coralGlow,
                t,
              )!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: DashboardScreen.coralGlow.withOpacity(glowOpacity),
                blurRadius: blur,
                spreadRadius: spread,
              ),
              BoxShadow(
                color: DashboardScreen.coralSolid.withOpacity(0.15 * t),
                blurRadius: 40,
                spreadRadius: 6,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Shield / pulse icon
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    color: DashboardScreen.coralGlow.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: DashboardScreen.coralGlow.withOpacity(0.55),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            DashboardScreen.coralGlow.withOpacity(0.35),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.health_and_safety_rounded,
                    color: DashboardScreen.coralGlow,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM DIAGNOSTIC',
                        style: _orbitron(
                          size: 13,
                          weight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'PRE-TEST',
                        style: _orbitron(
                          size: 10,
                          weight: FontWeight.w600,
                          color: DashboardScreen.mutedCrimson,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Calibrate your operator profile. Identify knowledge gaps before '
              'engaging live targets.',
              style: _roboto(
                size: 11,
                color: Colors.white.withOpacity(0.78),
              ),
            ),
            const SizedBox(height: 12),
            // Solid coral pill button — bold black label
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DashboardScreen.coralSolid,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: const StadiumBorder(),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(
                    Colors.white.withOpacity(0.08),
                  ),
                ),
                child: Text(
                  'START DIAGNOSTIC',
                  style: _orbitron(
                    size: 11,
                    weight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recommended Mission — SQLi Login Bypass
// ─────────────────────────────────────────────────────────────────────────────
class _RecommendedMissionCard extends StatelessWidget {
  const _RecommendedMissionCard({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECOMMENDED MISSION',
            style: _orbitron(size: 13, letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on your performance, your next mission is:',
            style: _roboto(
              size: 11.5,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Database / server icon in glowing red square
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: DashboardScreen.coralGlow.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DashboardScreen.coralGlow.withOpacity(0.55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DashboardScreen.coralGlow.withOpacity(0.45),
                      blurRadius: 16,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: DashboardScreen.coralGlow,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SQLI LOGIN BYPASS',
                      style: _orbitron(
                        size: 15,
                        weight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'OWASP A03:2021 - Injection',
                      style: _roboto(
                        size: 11,
                        color: DashboardScreen.mutedCrimson,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Coral pill button — bold black label
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: DashboardScreen.coralSolid,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: const StadiumBorder(),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(
                  Colors.white.withOpacity(0.08),
                ),
              ),
              child: Text(
                'START MISSION',
                style: _orbitron(
                  size: 13,
                  weight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Links — VulnShop / VulnBot / Library
// ─────────────────────────────────────────────────────────────────────────────
class _QuickLinksRow extends StatelessWidget {
  const _QuickLinksRow({
    required this.onVulnShop,
    required this.onVulnBot,
    required this.onLibrary,
  });

  final VoidCallback onVulnShop;
  final VoidCallback onVulnBot;
  final VoidCallback onLibrary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkTile(
            icon: Icons.storefront_rounded,
            label: 'VulnShop',
            onTap: onVulnShop,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickLinkTile(
            imageAsset: 'assets/icons/VulnbotAI_LOGO.png',
            label: 'VulnBot',
            onTap: onVulnBot,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickLinkTile(
            icon: Icons.menu_book_rounded,
            label: 'Library',
            onTap: onLibrary,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({
    this.icon,
    this.imageAsset,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || imageAsset != null);

  final IconData? icon;
  final String? imageAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.08;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: _cardDecoration(radius: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: icon != null
                    ? Icon(icon,
                        color: DashboardScreen.coralGlow, size: iconSize * 0.85)
                    : Image.asset(
                        imageAsset!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.smart_toy_rounded,
                          color: DashboardScreen.coralGlow,
                          size: iconSize * 0.85,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: _orbitron(
                  size: 11,
                  weight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Footer — What is Ethical Hacking?
// ─────────────────────────────────────────────────────────────────────────────
class _EthicalHackingFooter extends StatelessWidget {
  const _EthicalHackingFooter({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: _cardDecoration(radius: 14, borderWidth: 1.0),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.1,
              height: screenWidth * 0.1,
              decoration: BoxDecoration(
                color: DashboardScreen.coralGlow.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: DashboardScreen.coralGlow.withOpacity(0.45),
                ),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: DashboardScreen.coralGlow,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHAT IS ETHICAL HACKING?',
                    style: _orbitron(
                      size: 13,
                      weight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The legal and responsible use of hacking techniques to '
                    'identify and fix security vulnerabilities.',
                    style: _roboto(
                      size: 11.5,
                      color: Colors.white.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: DashboardScreen.coralGlow.withOpacity(0.85),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circuit-board overlay
// Lightweight CustomPainter — avoids bundling an additional bitmap asset
// while still delivering the noir circuit-trace texture across the canvas.
// ─────────────────────────────────────────────────────────────────────────────
class _CircuitBoardOverlay extends StatelessWidget {
  const _CircuitBoardOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircuitBoardPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _CircuitBoardPainter extends CustomPainter {
  static const double _cell = 36.0;

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..color = DashboardScreen.coralGlow.withOpacity(0.05)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = DashboardScreen.coralGlow.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    // Deterministic pseudo-random pattern (seeded) so the texture is stable
    // across rebuilds.
    final rng = math.Random(7);

    for (double y = 0; y < size.height; y += _cell) {
      for (double x = 0; x < size.width; x += _cell) {
        final r = rng.nextInt(6);
        final cx = x + _cell / 2;
        final cy = y + _cell / 2;
        switch (r) {
          case 0:
            canvas.drawLine(
              Offset(x, cy),
              Offset(x + _cell, cy),
              tracePaint,
            );
            break;
          case 1:
            canvas.drawLine(
              Offset(cx, y),
              Offset(cx, y + _cell),
              tracePaint,
            );
            break;
          case 2:
            canvas.drawLine(Offset(x, cy), Offset(cx, cy), tracePaint);
            canvas.drawLine(Offset(cx, cy), Offset(cx, y + _cell),
                tracePaint);
            canvas.drawCircle(Offset(cx, cy), 1.2, nodePaint);
            break;
          case 3:
            canvas.drawLine(Offset(cx, y), Offset(cx, cy), tracePaint);
            canvas.drawLine(Offset(cx, cy), Offset(x + _cell, cy),
                tracePaint);
            canvas.drawCircle(Offset(cx, cy), 1.2, nodePaint);
            break;
          // case 4, 5: empty cell — keeps the texture sparse
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
