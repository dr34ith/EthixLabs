import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/message.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class OperatorChoiceScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  final String academicProfile;

  const OperatorChoiceScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.expertise,
    required this.academicProfile,
  });

  @override
  State<OperatorChoiceScreen> createState() => _OperatorChoiceScreenState();
}

class _OperatorChoiceScreenState extends State<OperatorChoiceScreen> {
  String? selectedOperator;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Card width: roughly half the screen minus margins
    final cardWidth = (size.width - 24 * 2 - 20) / 2;
    // Image height: tall enough to show full body
    final imageHeight = size.height * 0.42;

    return Scaffold(
      body: Stack(
        children: [
          // ── BACKGROUND ──
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.50)),

          // ── CONTENT ──
          SafeArea(
            child: Column(
              children: [
                // Progress bar
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: CyberProgressBar(currentStep: 4, totalSteps: 4),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'CHOOSE YOUR CHARACTER',
                    textAlign: TextAlign.center,
                    style: CyberTypography.heading(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── CHARACTER CARDS (fills remaining space) ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hero 1
                        Expanded(
                          child: _buildOperatorCard(
                            name: 'Vanta',
                            imagePath: 'assets/pixel_images/hero1.jpg',
                            role: 'Junior Ethical Hacker',
                            imageHeight: imageHeight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Hero 2
                        Expanded(
                          child: _buildOperatorCard(
                            name: 'Cipher',
                            imagePath: 'assets/pixel_images/hero2.jpg',
                            role: 'Security Apprentice',
                            imageHeight: imageHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── CONTINUE BUTTON ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CyberButton(
                      text: 'CONTINUE',
                      icon: Icons.arrow_forward,
                      onPressed: selectedOperator != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    expertise: widget.expertise,
                                    academicProfile: widget.academicProfile,
                                    operator: selectedOperator!,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorCard({
    required String name,
    required String imagePath,
    required String role,
    required double imageHeight,
  }) {
    final isSelected = selectedOperator == name;

    return GestureDetector(
      onTap: () => setState(() => selectedOperator = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? CyberColors.primaryGlow
                : CyberColors.primaryGlow.withOpacity(0.25),
            width: isSelected ? 3 : 1.5,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    CyberColors.primaryNeon.withOpacity(0.22),
                    CyberColors.primaryGlow.withOpacity(0.06),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.35),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CyberColors.primaryNeon.withOpacity(0.45),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // ── Full-body character image ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.person, color: Colors.white38, size: 80),
                  ),
                ),
              ),
            ),

            // ── Name + Role ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    name.toUpperCase(),
                    style: CyberTypography.heading(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : CyberColors.textRose,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    role,
                    textAlign: TextAlign.center,
                    style: CyberTypography.monospace(
                      fontSize: 9,
                      color: isSelected ? Colors.white70 : CyberColors.textDim,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: CyberColors.primaryNeon,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: CyberColors.primaryNeon.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        '✓  SELECTED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}