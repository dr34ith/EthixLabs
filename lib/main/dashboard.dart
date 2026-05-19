import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/main/library.dart';
import 'package:test_vuln/main/mission.dart';
import 'package:test_vuln/main/shop.dart';
import 'package:test_vuln/pretest/pretest_screen.dart';
import 'package:test_vuln/services/hive_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color bg         = Color(0xFF0D0D0D);
  static const Color surface    = Color(0xFF1A1A1D);
  static const Color coralGlow  = Color(0xFFFF8A8A);
  static const Color coralSolid = Color(0xFFFF5F5F);
  static const Color metallicRed= Color(0xFFB23A48);
  static const Color mutedCrimson= Color(0xFFE68C8C);

  static List<BoxShadow> get minimalGlow => [
    BoxShadow(color: const Color(0x33FF8A8A), blurRadius: 6.0, spreadRadius: 0.5)];

  late Map<String, dynamic> _summary;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reload();
  }

  void _reload() {
    setState(() => _summary = HiveService.getProgressSummary());
  }

  String get _userName   => _summary['userName']          as String? ?? 'Ethical Hacker';
  int    get _completed  => _summary['completedMissions'] as int?    ?? 0;
  double get _fraction   => (_summary['progressFraction'] as num?)?.toDouble() ?? 0.0;
  int    get _flags      => _summary['flags']             as int?    ?? 0;

  int _tierCount(String tier) {
    try {
      return HiveService.getAllMissions()
          .where((m) => m['tier'] == tier && HiveService.isMissionCompleted(m['id'] as String))
          .length;
    } catch (_) { return 0; }
  }

  String _recommendedTitle() {
    try {
      final next = HiveService.getAllMissions().firstWhere(
        (m) => !HiveService.isMissionCompleted(m['id'] as String),
        orElse: () => HiveService.getAllMissions().first);
      return next['title'] as String? ?? 'All missions complete!';
    } catch (_) { return 'SQLi Login Bypass'; }
  }

  String _recommendedDesc() {
    try {
      final next = HiveService.getAllMissions().firstWhere(
        (m) => !HiveService.isMissionCompleted(m['id'] as String),
        orElse: () => HiveService.getAllMissions().first);
      return next['description'] as String? ?? '';
    } catch (_) { return 'Use a tautology payload to bypass authentication.'; }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final hp = sw * 0.05;
    final vs = sh * 0.02;

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/images/bg3_noLogo.jpg', fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.15))),
        SafeArea(child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: hp, vertical: vs),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Welcome
            Column(children: [
              Text('WELCOME BACK, ${_userName.toUpperCase()}',
                style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text('Your journey to becoming an ethical hacker continues.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 11, color: Colors.white.withOpacity(0.65))),
            ]),
            SizedBox(height: vs),

            // Mission Progress
            _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('MISSION PROGRESS', style: GoogleFonts.orbitron(fontSize: 14, letterSpacing: 1.2, color: Colors.white)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('$_completed / 15 missions completed',
                  style: GoogleFonts.roboto(fontSize: 11, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
                Row(children: [
                  const Icon(Icons.flag_rounded, size: 14, color: coralGlow),
                  const SizedBox(width: 4),
                  Text('$_flags / 15',
                    style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9))),
                ]),
              ]),
              const SizedBox(height: 14),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                child: Stack(children: [
                  Container(height: 8, color: Colors.white.withOpacity(0.08)),
                  FractionallySizedBox(
                    widthFactor: _fraction.clamp(0.0, 1.0),
                    child: Container(height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [coralSolid, coralGlow]),
                        boxShadow: [BoxShadow(color: coralGlow.withOpacity(0.6), blurRadius: 8, spreadRadius: -1)]))),
                ])),
            ])),
            SizedBox(height: vs * 0.6),

            // Tier cards
            Row(children: [
              Expanded(child: _tierCard('Foundational', _tierCount('Foundational'), 5)),
              const SizedBox(width: 12),
              Expanded(child: _tierCard('Intermediate', _tierCount('Intermediate'), 5)),
              const SizedBox(width: 12),
              Expanded(child: _tierCard('Advanced', _tierCount('Advanced'), 5)),
            ]),
            SizedBox(height: vs * 0.6),

            // System Diagnostic Hero
            _SystemDiagnosticHero(onStart: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PreTestScreen()))),
            SizedBox(height: vs * 0.6),

            // Recommended mission
            _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('RECOMMENDED MISSION',
                style: GoogleFonts.orbitron(fontSize: 13, letterSpacing: 1.2, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Based on your performance, your next mission is:',
                style: GoogleFonts.roboto(fontSize: 11.5, color: Colors.white.withOpacity(0.65))),
              const SizedBox(height: 14),
              Row(children: [
                Container(
                  width: sw * 0.12, height: sw * 0.12,
                  decoration: BoxDecoration(
                    color: coralGlow.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: coralGlow.withOpacity(0.55)),
                    boxShadow: [BoxShadow(color: coralGlow.withOpacity(0.45), blurRadius: 16, spreadRadius: -2)]),
                  child: const Icon(Icons.storage_rounded, color: coralGlow, size: 26)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_recommendedTitle().toUpperCase(),
                    style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white)),
                  Text(_recommendedDesc(),
                    style: GoogleFonts.roboto(fontSize: 11, color: mutedCrimson, fontWeight: FontWeight.w500)),
                ])),
              ]),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MissionsScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coralSolid, foregroundColor: Colors.black,
                    elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: const StadiumBorder()),
                  child: Text('START MISSION',
                    style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.w800,
                      color: Colors.black, letterSpacing: 1.2)))),
            ])),
            SizedBox(height: vs * 0.6),

            // Quick links
            Row(children: [
              Expanded(child: _quickLink(icon: Icons.storefront_rounded, label: 'VulnShop',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())))),
              const SizedBox(width: 12),
              Expanded(child: _quickLink(imageAsset: 'assets/icons/VulnbotAI_LOGO.png', label: 'VulnBot',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tap the VulnBot tab below!'), backgroundColor: coralGlow)))),
              const SizedBox(width: 12),
              Expanded(child: _quickLink(icon: Icons.menu_book_rounded, label: 'Library',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LibraryScreen())))),
            ]),
            SizedBox(height: vs * 0.6),

            // Footer
            _card(child: Row(children: [
              Container(
                width: sw * 0.1, height: sw * 0.1,
                decoration: BoxDecoration(
                  color: coralGlow.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: coralGlow.withOpacity(0.45))),
                child: const Icon(Icons.shield_outlined, color: coralGlow, size: 22)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('WHAT IS ETHICAL HACKING?',
                  style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.white)),
                const SizedBox(height: 4),
                Text('The legal and responsible use of hacking techniques to identify and fix security vulnerabilities.',
                  style: GoogleFonts.roboto(fontSize: 11.5, color: Colors.white.withOpacity(0.72))),
              ])),
              Icon(Icons.chevron_right_rounded, color: coralGlow.withOpacity(0.85), size: 24),
            ])),
            SizedBox(height: vs * 1.2),
          ]),
        )),
      ]),
    );
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: surface, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white38, width: 1.0),
      boxShadow: minimalGlow),
    child: child);

  Widget _tierCard(String title, int done, int total) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: surface, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white38, width: 1.0),
      boxShadow: minimalGlow),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(),
        style: GoogleFonts.orbitron(fontSize: 10, letterSpacing: 1.2, color: mutedCrimson),
        overflow: TextOverflow.ellipsis),
      const SizedBox(height: 8),
      Text('$done/$total', style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
    ]));

  Widget _quickLink({IconData? icon, String? imageAsset, required String label, required VoidCallback onTap}) {
    final iconSize = MediaQuery.of(context).size.width * 0.08;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: surface, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white38, width: 1.0),
            boxShadow: minimalGlow),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: iconSize, height: iconSize,
              child: icon != null
                ? Icon(icon, color: coralGlow, size: iconSize * 0.85)
                : Image.asset(imageAsset!, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(Icons.smart_toy_rounded, color: coralGlow, size: iconSize * 0.85))),
            const SizedBox(height: 10),
            Text(label, style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0, color: Colors.white)),
          ]),
        )));
  }
}

// ── Pulsing hero card ──
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
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_pulse.value);
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1D),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.lerp(const Color(0xFFB23A48), const Color(0xFFFF8A8A), t)!, width: 1.5),
            boxShadow: [
              BoxShadow(color: const Color(0xFFFF8A8A).withOpacity(0.45 + 0.35 * t),
                blurRadius: 22.0 + 16.0 * t, spreadRadius: -1.0 + 4.0 * t),
            ]),
          child: child);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A8A).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFF8A8A).withOpacity(0.55)),
                boxShadow: [BoxShadow(color: const Color(0xFFFF8A8A).withOpacity(0.35), blurRadius: 10, spreadRadius: -2)]),
              child: const Icon(Icons.health_and_safety_rounded, color: Color(0xFFFF8A8A), size: 22)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('SYSTEM DIAGNOSTIC',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: 1.5)),
              Text('PRE-TEST',
                style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.w600,
                  color: const Color(0xFFE68C8C), letterSpacing: 2.0)),
            ])),
          ]),
          const SizedBox(height: 10),
          Text('Calibrate your operator profile. Identify knowledge gaps before engaging live targets.',
            style: GoogleFonts.roboto(fontSize: 11, color: Colors.white.withOpacity(0.78))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5F5F), foregroundColor: Colors.black,
                elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10),
                shape: const StadiumBorder()),
              child: Text('START DIAGNOSTIC',
                style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.w900,
                  color: Colors.black, letterSpacing: 1.8)))),
        ]),
      ),
    );
  }
}
