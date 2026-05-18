import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CyberTheme {
  // Color constants (Updated Design Tokens)
  static const Color background = Color(0xFF0D0D0D); // Pure Obsidian
  static const Color surface = Color(0xFF1A1A1D); // Deep Charcoal
  static const Color navigationBackground = Color(0xFF2D142C); // Dark Plum
  static const Color primaryAccent = Color(0xFFFF8A8A); // Soft Coral Red
  static const Color secondaryAccent = Color(0xFF8A2BE2); // Neon Purple
  static const Color borderGlow = Color(0x4DFF0000); // #FF0000 with 0.3 opacity
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color textMuted = Color(0xFF95A5A6); // Grey

  // Legacy colors for backward compatibility
  static const Color legacyPink = Color(0xFFE68C8C);
  static const Color legacyCoral = Color(0xFFFF5F5F);

  // Text styles (Updated with new design tokens)
  static TextStyle get headerStyle => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 1.5,
      );

  static TextStyle get welcomeStyle => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 1.5,
      );

  static TextStyle get bodyStyle => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textMuted,
      );

  static TextStyle get bodyStyleWhite => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      );

  static TextStyle get captionStyle => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMuted,
      );

  static TextStyle get monospaceStyle => GoogleFonts.robotoMono(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryAccent,
        letterSpacing: 1,
  );

  // Primary heading style for ALL CAPS headers
  static TextStyle get primaryHeading => GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: 1.2,
  );

  // Custom glow box decoration (Updated Glow Logic)
  static BoxDecoration glowBoxDecoration({
    Color? accent,
    double borderRadius = 12,
    Color? backgroundColor,
  }) {
    final accentColor = accent ?? primaryAccent;
    
    return BoxDecoration(
      color: backgroundColor ?? surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: accentColor,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFFF4D4D).withOpacity(0.4),
          blurRadius: 25,
          spreadRadius: -5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // High-intensity glow for cards
  static BoxDecoration highIntensityGlowDecoration({
    Color? accent,
    double borderRadius = 16,
    Color? backgroundColor,
  }) {
    final accentColor = accent ?? primaryAccent;
    
    return BoxDecoration(
      color: backgroundColor ?? surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: accentColor,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: accentColor.withOpacity(0.6),
          blurRadius: 30,
          spreadRadius: -5,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: accentColor.withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Card decoration with gradient
  static BoxDecoration gradientCardDecoration({
    Color? startColor,
    Color? endColor,
    double borderRadius = 16,
  }) {
    final start = startColor ?? primaryAccent.withOpacity(0.15);
    final end = endColor ?? surface.withOpacity(0.8);
    
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [start, end],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: primaryAccent.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }

  // Button decoration with glow
  static BoxDecoration glowButtonDecoration({
    Color? accent,
    double borderRadius = 12,
  }) {
    final accentColor = accent ?? primaryAccent;
    
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [accentColor, accentColor.withOpacity(0.8)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: accentColor.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Complete ThemeData for MaterialApp
  static ThemeData get themeData {
    return ThemeData(
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: primaryAccent,
        secondary: secondaryAccent,
        surface: surface,
        background: background,
        error: Colors.red,
      ),

      // Scaffold background
      scaffoldBackgroundColor: background,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: navigationBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: headerStyle.copyWith(fontSize: 20),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: primaryAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Color(0xFFFF0000), width: 2.0),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ).copyWith(
          shadowColor: MaterialStateProperty.all(const Color(0xFFFF0000)),
          elevation: MaterialStateProperty.all(0),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryAccent,
          side: BorderSide(color: primaryAccent, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryAccent.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryAccent.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        hintStyle: captionStyle,
        labelStyle: bodyStyle,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: headerStyle.copyWith(fontSize: 32, letterSpacing: 1.2),
        displayMedium: headerStyle.copyWith(fontSize: 28, letterSpacing: 1.2),
        displaySmall: headerStyle.copyWith(fontSize: 24, letterSpacing: 1.2),
        headlineLarge: headerStyle.copyWith(fontSize: 22, letterSpacing: 1.2),
        headlineMedium: headerStyle.copyWith(fontSize: 20, letterSpacing: 1.2),
        headlineSmall: headerStyle.copyWith(fontSize: 18, letterSpacing: 1.2),
        titleLarge: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleSmall: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: bodyStyle.copyWith(fontSize: 16),
        bodyMedium: bodyStyle.copyWith(fontSize: 14),
        bodySmall: bodyStyle.copyWith(fontSize: 12),
        labelLarge: bodyStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: captionStyle,
        labelSmall: captionStyle.copyWith(fontSize: 11),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryAccent,
        size: 24,
      ),
    );
  }
}
