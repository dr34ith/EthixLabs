import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiagnosticResultsScreen extends StatelessWidget {
  final int score;
  final int totalPoints;

  const DiagnosticResultsScreen({
    Key? key,
    required this.score,
    required this.totalPoints,
  }) : super(key: key);

  String _getPerformanceMessage() {
    final percentage = score / totalPoints;
    if (percentage >= 0.9) {
      return 'Excellent! You have strong foundational knowledge.';
    } else if (percentage >= 0.7) {
      return 'Great job! You have a good understanding of the concepts.';
    } else if (percentage >= 0.5) {
      return 'Good effort! There\'s room for improvement through the missions.';
    } else {
      return 'Don\'t worry! The missions will help you build these skills.';
    }
  }

  Color _getScoreColor() {
    final percentage = score / totalPoints;
    if (percentage >= 0.7) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage >= 0.5) {
      return const Color(0xFFFFC107); // Amber
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalPoints * 100).toInt();
    final scoreColor = _getScoreColor();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    scoreColor.withOpacity(0.3),
                    scoreColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: scoreColor,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.assessment,
                size: 64,
                color: scoreColor,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Diagnostic Results',
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Pre-Test Assessment',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),

            // Score Display
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: scoreColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.orbitron(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/ $totalPoints',
                        style: GoogleFonts.orbitron(
                          fontSize: 32,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$percentage%',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Performance Message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE68C8C).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFE68C8C),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getPerformanceMessage(),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE68C8C),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue to Dashboard',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Disclaimer
            Text(
              'Remember: This assessment does not affect your mission access. It\'s designed to track your learning progress.',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
