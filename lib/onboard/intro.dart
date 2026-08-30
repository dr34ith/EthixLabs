import 'package:ethixlabs/onboard/welcome.dart';
import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ========== BACKGROUND PHOTO ==========
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1_noLogo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ========== MAIN CONTENT ==========
                    Column(
                      children: [
                        Text(
                          'LEARN SECURITY\nBY DOING',
                          textAlign: TextAlign.center,
                          style: CyberTypography.heading(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI-powered app to find & fix vulnerabilities',
                          textAlign: TextAlign.center,
                          style: CyberTypography.monospace(
                            fontSize: 12,
                            color: CyberColors.textDim,
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // START MISSION Button
                        CyberButton(
                          text: 'START THE MISSION',
                          icon: Icons.shield_outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            );
                          },
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // ========== BOTTOM LOGO WITH DATE ==========
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/EthixLabs_LOGO.png',
                          height: 70,
                          width: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.apps, size: 40);
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© 2026',
                          style: CyberTypography.monospace(
                            fontSize: 11,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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