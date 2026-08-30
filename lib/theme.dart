import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';

export 'core/theme/app_colors.dart' show AppColors;

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      primaryColor: AppColors.accent,
      colorScheme: ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentSoft,
        background: AppColors.bgPrimary,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgPrimary,
        selectedItemColor: const Color(0xFFE68C8C),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
