import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/learning.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  final String academicProfile;
  final String operator;
  
  const LetterScreen({
    super.key, 
    required this.firstName, 
    required this.lastName,
    required this.expertise,
    required this.academicProfile,
    required this.operator,
  });

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _scannerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ========== BACKGROUND IMAGE ==========
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Status Header Icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: CyberColors.primaryNeon.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: CyberColors.primaryNeon, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: CyberColors.primaryNeon.withOpacity(0.3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.terminal,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        'CLASSIFIED MISSION BRIEFING',
                        textAlign: TextAlign.center,
                        style: CyberTypography.heading(
                          fontSize: 13,
                          color: CyberColors.primaryGlow,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'DECRYPTED CHANNEL',
                        textAlign: TextAlign.center,
                        style: CyberTypography.heading(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ========== THE TERMINAL CARD ==========
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 420),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: CyberColors.primaryGlow.withOpacity(0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: CyberColors.primaryNeon.withOpacity(0.1),
                                  blurRadius: 20,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // System connection logs
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'SECURE_CHANNEL_ONLINE',
                                          style: GoogleFonts.robotoMono(
                                            color: Colors.green,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'LEVEL: SECURE',
                                      style: GoogleFonts.robotoMono(
                                        color: CyberColors.textRose,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24, height: 20),
                                
                                Text(
                                  'TO: AGENT ${widget.firstName.toUpperCase()} ${widget.lastName.toUpperCase()}',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CyberColors.secondaryGlow,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: CyberColors.primaryNeon.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: CyberColors.primaryNeon.withOpacity(0.6)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.shield, color: Colors.greenAccent, size: 12),
                                          const SizedBox(width: 4),
                                          Text('HACKER\'S CODE', style: GoogleFonts.robotoMono(fontSize: 9, color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Text(
                                  'Your mission: audit VulnShop — a fake online store packed with real vulnerabilities. Find the bugs, exploit them safely, then fix them before any real attacker does.\n\nEach mission follows six steps: Learn → Observe → Test → Identify → Analyze → Apply. Earn flags, stars, and badges along the way.\n\nEverything stays in the sandbox. No real systems. No real risk. Just real learning.',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12.5,
                                    height: 1.6,
                                    color: const Color(0xFFE5D5D5),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  '[CRITICAL]: Sandbox active. No external networks or live production systems are targeted during these scenarios.',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: CyberColors.primaryGlow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                const Divider(color: Colors.white24, height: 24),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '— VULNSHOP SECURITY OPS',
                                          style: GoogleFonts.orbitron(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: CyberColors.secondaryGlow,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.security,
                                              color: Colors.white60,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'STAY ETHICAL. SECURE THE CODE.',
                                              style: GoogleFonts.robotoMono(
                                                fontSize: 9,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Animated Glowing Scanner Line
                          Positioned.fill(
                            child: IgnorePointer(
                              child: AnimatedBuilder(
                                animation: _scannerAnimation,
                                builder: (context, child) {
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      final double topOffset = constraints.maxHeight * _scannerAnimation.value;
                                      return Stack(
                                        children: [
                                          Positioned(
                                            top: topOffset,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 2.5,
                                              decoration: BoxDecoration(
                                                color: CyberColors.primaryGlow,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: CyberColors.primaryNeon,
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                  BoxShadow(
                                                    color: CyberColors.primaryGlow,
                                                    blurRadius: 4,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 35),
                      
                      // ========== UNDERSTAND BUTTON ==========
                      SizedBox(
                        width: 300,
                        child: CyberButton(
                          text: 'I UNDERSTAND',
                          icon: Icons.shield_outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LearningPathScreen(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  expertise: widget.expertise,
                                  academicProfile: widget.academicProfile,
                                  operator: widget.operator,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}