import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/auth/signup.dart';
import '../auth/login.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ========== BACKGROUND IMAGE ==========
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1_noLogo.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // ========== HACKER FRAME HUD OVERLAY ==========
          Positioned.fill(
            child: CustomPaint(
              painter: _HackerFramePainter(),
            ),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ========== MAIN CONTENT ==========
                    Text(
                      'LEARN SECURITY\nBY DOING.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFDC7C7),
                        letterSpacing: 1.5,
                        shadows: [
                          const Shadow(
                            color: Color(0xFFFF8A8A),
                            blurRadius: 12,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'AI-powered app to find &\nfix vulnerabilities',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ========== GRADIENT CTA BUTTON ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8A8A), Color(0xFFFF5F5F)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A8A).withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: Text(
                                  'START THE MISSION',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1A1D),
                                    letterSpacing: 1.8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ========== FOOTER ==========
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/EthixLabs_LOGO.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '@2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hacker Frame HUD Painter
// Draws a thin technical border around the screen edges with glowing corners
// ─────────────────────────────────────────────────────────────────────────────
class _HackerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double inset = 16.0;
    final double cornerLen = 40.0;
    final double cornerRadius = 4.0;

    // Outer frame paint — coral red with glow
    final framePaint = Paint()
      ..color = const Color(0xFFFF8A8A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Inner technical detail paint — subtle cyan/white
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Glow paint for corners
    final glowPaint = Paint()
      ..color = const Color(0xFFFF8A8A).withOpacity(0.4)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final Rect outerRect = Rect.fromLTRB(inset, inset, size.width - inset, size.height - inset);
    final Rect innerRect = outerRect.deflate(6);

    // Draw corner accents with glow
    _drawCorners(canvas, outerRect, cornerLen, glowPaint);
    _drawCorners(canvas, outerRect, cornerLen, framePaint);

    // Draw inner technical frame (subtle)
    _drawCorners(canvas, innerRect, cornerLen * 0.6, innerPaint);

    // Draw small tick marks along edges
    _drawEdgeTicks(canvas, outerRect, innerPaint);
  }

  void _drawCorners(Canvas canvas, Rect rect, double len, Paint paint) {
    final path = Path();

    // Top-left corner
    path.moveTo(rect.left, rect.top + len);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + len, rect.top);

    // Top-right corner
    path.moveTo(rect.right - len, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + len);

    // Bottom-right corner
    path.moveTo(rect.right, rect.bottom - len);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - len, rect.bottom);

    // Bottom-left corner
    path.moveTo(rect.left + len, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - len);

    canvas.drawPath(path, paint);
  }

  void _drawEdgeTicks(Canvas canvas, Rect rect, Paint paint) {
    final double tickLen = 6.0;
    final double spacing = 30.0;

    // Top edge ticks
    for (double x = rect.left + 60; x < rect.right - 60; x += spacing) {
      canvas.drawLine(
        Offset(x, rect.top),
        Offset(x, rect.top + tickLen),
        paint,
      );
    }

    // Bottom edge ticks
    for (double x = rect.left + 60; x < rect.right - 60; x += spacing) {
      canvas.drawLine(
        Offset(x, rect.bottom),
        Offset(x, rect.bottom - tickLen),
        paint,
      );
    }

    // Left edge ticks
    for (double y = rect.top + 60; y < rect.bottom - 60; y += spacing) {
      canvas.drawLine(
        Offset(rect.left, y),
        Offset(rect.left + tickLen, y),
        paint,
      );
    }

    // Right edge ticks
    for (double y = rect.top + 60; y < rect.bottom - 60; y += spacing) {
      canvas.drawLine(
        Offset(rect.right, y),
        Offset(rect.right - tickLen, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}