import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown in place of the Flashcards section when no SQLite backend is
/// available on the current platform (e.g. running in a browser).
///
/// No CTA button: there's no real app-store link to send users to yet, and
/// a button that goes nowhere would be worse than no button.
class FlashcardsWebPlaceholder extends StatelessWidget {
  const FlashcardsWebPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎴', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                'Best on Mobile',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Flashcards are optimized for the EthixLabs Android app. '
                'Open the app on your phone to review anywhere, anytime — '
                'even offline.',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                  fontSize: 14,
                  color: const Color(0xFFB0B0C0),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
