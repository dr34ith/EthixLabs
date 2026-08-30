import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/core/theme/app_colors.dart';
import 'package:ethixlabs/theme.dart' as legacy_theme;

void main() {
  test('legacy color aliases stay byte-identical to the pre-unification palette', () {
    // Screens built before the design-system unification rely on these
    // exact values; if they drift, every existing screen's colors shift
    // unintentionally.
    expect(AppColors.background, const Color(0xFF121016));
    expect(AppColors.surface, const Color(0xFF1E1E2A));
    expect(AppColors.card, const Color(0xFF22151A));
    expect(AppColors.accent, const Color(0xFFE68C8C));
    expect(AppColors.accentSoft, const Color(0xFFEEB3B3));
    expect(AppColors.glow, const Color(0xFFFF6B6B));
    expect(AppColors.muted, const Color(0xFFB6B6C0));
  });

  test('lib/theme.dart resolves AppColors to the same core/theme declaration', () {
    // dashboard.dart imports package:ethixlabs/theme.dart and uses
    // AppColors.accent directly; this only compiles at all if theme.dart's
    // export points at the same class rather than declaring its own.
    expect(legacy_theme.AppColors.accent, AppColors.accent);
  });

  test('new canonical palette matches the design-system spec', () {
    expect(AppColors.crimson, const Color(0xFF8B0000));
    expect(AppColors.bgPrimary, const Color(0xFF0A0A1A));
    expect(AppColors.gold, const Color(0xFFB8860B));
  });

  test('AppColorsOnLight matches the light-background mission stage spec', () {
    expect(AppColorsOnLight.bodyText, const Color(0xFF1A1A2E));
    expect(AppColorsOnLight.sectionLabel, const Color(0xFF8B0000));
    expect(AppColorsOnLight.bulletText, const Color(0xFF2C2C3E));
    expect(AppColorsOnLight.mutedText, const Color(0xFF5A5A6E));
    expect(AppColorsOnLight.buttonBg, const Color(0xFF8B0000));
    expect(AppColorsOnLight.buttonText, const Color(0xFFFFFFFF));
  });
}
