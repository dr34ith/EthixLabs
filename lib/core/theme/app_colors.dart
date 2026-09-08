import 'package:flutter/material.dart';

/// Single source of truth for color across the app. Physically defined
/// here; `lib/theme.dart` re-exports it so every existing `import
/// 'package:ethixlabs/theme.dart'` call site keeps compiling unchanged.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color crimson       = Color(0xFF8B0000);
  static const Color crimsonBright = Color(0xFFD32F2F);
  static const Color crimsonDark   = Color(0xFF5A0000);
  static const Color crimsonGlow   = Color(0xFFFF1744);

  // ── Backgrounds (RED-tinted, no blue) ──
  static const Color bgPrimary        = Color(0xFF0A0002);   // was 0xFF0A0A1A (blue)
  static const Color bgCard           = Color(0xFF150508);   // was 0xFF1A1A2E (blue)
  static const Color bgCardElevated   = Color(0xFF1E0A0F);   // was 0xFF22223A (blue)
  static const Color bgOverlay        = Color(0xFF100205);   // was 0xFF12121F (blue)

  // ── Borders ──
  static const Color borderSubtle = Color(0xFF2A0A14);   // was 0xFF2A2A3E (blue)
  static const Color borderMedium = Color(0xFF3A0A1A);   // was 0xFF3A3A4E (blue)

  // ── Text ──
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE8E8EC);
  static const Color textMuted     = Color(0xFFB0B0C0);
  static const Color textFaint     = Color(0xFF8E8E9E);
  static const Color textDisabled  = Color(0xFF6E6E7E);

  // ── Accents ──
  static const Color gold          = Color(0xFFB8860B);
  static const Color goldBright    = Color(0xFFFFD700);
  static const Color successGreen  = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFFA726);
  static const Color errorRed      = Color(0xFFEF5350);

  // ── Difficulty ──
  static const Color diffEasy   = Color(0xFF4CAF50);
  static const Color diffMedium = Color(0xFFFFA726);
  static const Color diffHard   = Color(0xFFEF5350);

  // ── Gradients ──
  static const LinearGradient crimsonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B0000), Color(0xFF5A0000)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF150508), Color(0xFF100205)],  // was blue-tinted
  );

  // ── Legacy aliases (kept byte-compatible for existing screens) ──
  static const Color background = Color(0xFF0A0002);   // was 0xFF121016
  static const Color surface    = Color(0xFF150508);   // was 0xFF1E1E2A (blue!)
  static const Color card       = Color(0xFF1E0A0F);   // was 0xFF22151A
  static const Color accent     = Color(0xFFE68C8C);
  static const Color accentSoft = Color(0xFFEEB3B3);
  static const Color glow       = Color(0xFFFF6B6B);
  static const Color muted      = Color(0xFFB6B6C0);
}

/// Text/button colors for screens with a light background.
class AppColorsOnLight {
  AppColorsOnLight._();

  static const Color bodyText     = Color(0xFF1A1A2E);
  static const Color sectionLabel = Color(0xFF8B0000);
  static const Color bulletText   = Color(0xFF2C2C3E);
  static const Color mutedText    = Color(0xFF5A5A6E);
  static const Color buttonBg     = Color(0xFF8B0000);
  static const Color buttonText   = Color(0xFFFFFFFF);
}