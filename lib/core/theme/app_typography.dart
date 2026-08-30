import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized text styles. Screens should reach for these instead of
/// defining ad-hoc TextStyles.
///
/// Font usage guide:
/// - Orbitron (`display*`, `label*`): screen titles, section headers,
///   primary CTA labels, uppercase category codes, app bar titles.
/// - Jersey 10 (`gamified*`): FLAG tokens, level titles, difficulty
///   indicators, badges, points/star counters, "MISSION COMPLETE",
///   flashcard deck titles.
/// - System sans-serif (`body*`): long-form reading content, mission
///   descriptions, flashcard front/back, Q&A text, settings/profile info.
/// - Monospace (`monoRegular`): payload strings, code examples, URLs/file
///   paths in technical contexts, regex patterns.
///
/// These are getters, not `const` fields, because both Orbitron and
/// Jersey 10 are loaded through `google_fonts` (runtime-fetched/cached,
/// same mechanism already used everywhere else in this app) rather than
/// bundled font asset files — `GoogleFonts.orbitron()` isn't a const
/// constructor.
class AppTypography {
  AppTypography._();

  // ============ DISPLAY (Orbitron) — hero titles, screen headers ============
  static TextStyle get displayLarge => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: Colors.white,
      );

  static TextStyle get displayMedium => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: Colors.white,
      );

  static TextStyle get displaySmall => GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Colors.white,
      );

  // ============ GAMIFIED (Jersey 10) — flags, levels, badges, mission titles ============
  static TextStyle get gamifiedLarge => GoogleFonts.jersey10(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: Colors.white,
      );

  static TextStyle get gamifiedMedium => GoogleFonts.jersey10(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.0,
        color: Colors.white,
      );

  static TextStyle get gamifiedSmall => GoogleFonts.jersey10(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.8,
        color: Colors.white,
      );

  // ============ BODY (System sans-serif) — long-form readable content ============
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: Color(0xFFE8E8EC),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFFE8E8EC),
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Color(0xFFB0B0C0),
  );

  // ============ LABELS — chips, badges, small UI text ============
  static TextStyle get labelLarge => GoogleFonts.orbitron(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: const Color(0xFF8B0000),
      );

  static TextStyle get labelMedium => GoogleFonts.orbitron(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: const Color(0xFFB0B0C0),
      );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Color(0xFF8E8E9E),
  );

  // ============ MONOSPACE — payloads, code snippets ============
  static const TextStyle monoRegular = TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE0E0E0),
    letterSpacing: 0.3,
  );
}
