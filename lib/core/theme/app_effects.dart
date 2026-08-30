import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable box-shadow presets for the cyberpunk red-glow look.
class AppEffects {
  AppEffects._();

  /// Subtle glow for cards.
  static List<BoxShadow> softGlow({
    Color color = AppColors.crimsonGlow,
    double intensity = 0.3,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  /// Medium glow for interactive elements.
  static List<BoxShadow> mediumGlow({
    Color color = AppColors.crimsonGlow,
    double intensity = 0.5,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ];
  }

  /// Strong glow for CTAs and level-ups.
  static List<BoxShadow> strongGlow({
    Color color = AppColors.crimsonGlow,
    double intensity = 0.7,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 30,
        spreadRadius: 4,
      ),
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 60,
        spreadRadius: 8,
      ),
    ];
  }

  /// Depth shadow for elevated cards.
  static List<BoxShadow> depthShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
