import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/library/lib_01.dart';
import 'package:test_vuln/library/lib_02.dart';
import 'package:test_vuln/library/lib_03.dart';
import 'package:test_vuln/library/lib_04.dart';
import 'package:test_vuln/library/lib_05.dart';
import 'package:test_vuln/library/lib_06.dart';
import 'package:test_vuln/library/lib_07.dart';
import 'package:test_vuln/library/lib_08.dart';
import 'package:test_vuln/library/lib_09.dart';
import 'package:test_vuln/library/lib_10.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

/// ============================================================================
/// REFERENCE LIBRARY DASHBOARD
/// ----------------------------------------------------------------------------
/// Dark-noir aesthetic. Pure obsidian (#0D0D0D) background, deep charcoal
/// (#1A1A1D) cards with a high-intensity Coral Red (#FF8A8A) pulsing outer
/// glow. Each section ships its own cyber icon. PAYLOADS and MITIGATION
/// TECHNIQUES are surfaced first, directly under the page title.
/// ============================================================================
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static const Color _bg = Color(0xFF0D0D0D);

  @override
  Widget build(BuildContext context) {
    final cards = <_LibraryCardData>[
      // ── Priority #1: PAYLOADS ─────────────────────────────────────────────
      _LibraryCardData(
        title: 'Common Test Payloads',
        category: 'Exploitation Techniques',
        description:
            'Common payload types: reverse shells, bind shells, web shells, and more.',
        icon: _CyberIcons.terminal,
        builder: (_) => const PayloadsScreen(),
      ),
      // ── Priority #2: MITIGATION TECHNIQUES ────────────────────────────────
      _LibraryCardData(
        title: 'Mitigation Techniques',
        category: 'Defense Strategies',
        description:
            'Input validation, parameterized queries, access controls, and security headers.',
        icon: _CyberIcons.firewall,
        builder: (_) => const MitigationTechniquesScreen(),
      ),
      // ── Standard sections (moved below the priority cards) ────────────────
      _LibraryCardData(
        title: 'What is Ethical Hacking?',
        category: 'Foundation',
        description:
            'Understanding ethical hacking, white hat methodologies, and legal penetration testing.',
        icon: _CyberIcons.codeBlock,
        builder: (_) => const EthicalHackingScreen(),
      ),
      _LibraryCardData(
        title: 'The Three Types of Hackers',
        category: 'White Hat • Black Hat • Grey Hat',
        description:
            'Learn the differences between ethical, malicious, and grey hat hackers.',
        icon: _CyberIcons.shield,
        builder: (_) => const ThreeTypesOfHackersScreen(),
      ),
      _LibraryCardData(
        title: 'What is OWASP?',
        category: 'Open Web Application Security Project',
        description:
            'Understanding OWASP and its importance in web application security.',
        icon: _CyberIcons.web,
        builder: (_) => const OWASPScreen(),
      ),
      _LibraryCardData(
        title: 'SQL Injection',
        category: 'OWASP A03:2021 — Injection',
        description:
            'How SQL injection works, types, and real-world attack examples.',
        icon: _CyberIcons.codeBlock,
        builder: (_) => const SQLInjectionScreen(),
      ),
      _LibraryCardData(
        title: 'Broken Access Control',
        category: 'OWASP A01:2021',
        description:
            'IDOR, privilege escalation, and access control vulnerabilities.',
        icon: _CyberIcons.brokenLock,
        builder: (_) => const BrokenAccessControlScreen(),
      ),
      _LibraryCardData(
        title: 'Secure Coding',
        category: 'Developer Best Practices',
        description:
            'Writing secure code to prevent vulnerabilities at the source.',
        icon: _CyberIcons.codeBlock,
        builder: (_) => const SecureCodingScreen(),
      ),
      _LibraryCardData(
        title: 'OWASP Top 10:2021',
        category: 'External Resources',
        description:
            'Complete list of the most critical web application security risks.',
        icon: _CyberIcons.web,
        builder: (_) => const ExternalResourcesScreen(),
      ),
      _LibraryCardData(
        title: 'Reference Glossary',
        category: 'Cybersecurity Terms',
        description:
            'Comprehensive definitions of security terminology and concepts.',
        icon: _CyberIcons.shield,
        builder: (_) => const GlossaryScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg3_noLogo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Page header (no underbar) ──────────────────────────────────
                  Text(
                    'REFERENCE LIBRARY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comprehensive security learning materials and resources',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.55),
                      letterSpacing: 0.4,
                    ),
                  ),
                  // 24px vertical padding after the title block
                  const SizedBox(height: 24),

                  // ── Card list ──────────────────────────────────────────────────
                  for (int i = 0; i < cards.length; i++) ...[
                    _ReferenceCard(
                      data: cards[i],
                      // Stagger the pulse slightly across cards so the dashboard
                      // breathes instead of throbbing in lockstep.
                      phaseOffset: (i % 4) * 0.25,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: cards[i].builder),
                      ),
                    ),
                    if (i != cards.length - 1) const SizedBox(height: 16),
                  ],
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
// Card data model
// ─────────────────────────────────────────────────────────────────────────────
class _LibraryCardData {
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final WidgetBuilder builder;

  const _LibraryCardData({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.builder,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Reference Card — deep charcoal surface, pulsing coral-red outer glow
// ─────────────────────────────────────────────────────────────────────────────
class _ReferenceCard extends StatefulWidget {
  const _ReferenceCard({
    required this.data,
    required this.onTap,
    this.phaseOffset = 0.0,
  });

  final _LibraryCardData data;
  final VoidCallback onTap;
  final double phaseOffset;

  @override
  State<_ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<_ReferenceCard>
    with SingleTickerProviderStateMixin {
  static const Color _surface = Color(0xFF1A1A1D);
  static const Color _coral = Color(0xFFFF8A8A);
  static const Color _mutedCrimson = Color(0xFFE68C8C);

  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
      // Apply phase offset so cards don't pulse in perfect unison.
      value: widget.phaseOffset.clamp(0.0, 1.0),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFF8A8A).withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: const Color(0x66FF8A8A),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Title / category / description ──────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.data.category,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.data.description,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // ── Soft red trailing chevron ───────────────────────────────
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cyber icon mapping — one focused glyph per card category.
// Material Symbols already ships purpose-built cybersecurity icons, so we
// avoid bundling additional asset packs.
// ─────────────────────────────────────────────────────────────────────────────
class _CyberIcons {
  // Terminal prompt — Payloads
  static const IconData terminal = Icons.terminal_rounded;
  // Firewall / shield — Mitigation Techniques
  static const IconData firewall = Icons.shield_moon_rounded;
  // Web / server — OWASP family
  static const IconData web = Icons.public_rounded;
  // Broken padlock — Broken Access Control
  static const IconData brokenLock = Icons.lock_open_rounded;
  // Generic shield — fallback / glossary
  static const IconData shield = Icons.shield_rounded;
  // Code block — coding & foundation pieces
  static const IconData codeBlock = Icons.code_rounded;
}

// Suppress unused import warning; CyberTheme tokens are referenced by sibling
// screens and kept here for design-system continuity.
// ignore: unused_element
final _kThemeAnchor = CyberTheme.primaryAccent;
