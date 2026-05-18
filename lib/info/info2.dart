// lib/mission/mission_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/main/main_layout.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg1_noLogo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text(
                  'LEARNING PATH',
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      const Shadow(
                        color: Color(0xFFFF8A8A),
                        blurRadius: 15,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main Mission Card
                Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1D),
                    borderRadius: BorderRadius.circular(12),
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
                        color: const Color(0x33FF8A8A),
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Learning path text
                      const Text(
                        'Complete 15 structured mission across three difficulty levels: Foundational, Intermediate, and Advanced',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Use VulnBot for guidance, explore the Reference Library for learning materials, and earn your certification upon completion.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Start Learning Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainLayout(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A8A),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            shadowColor: const Color(0xFFFF8A8A).withOpacity(0.5),
                          ),
                          child: Text(
                            'START LEARNING',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
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