import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/letter.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class MessageScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  final String academicProfile;
  final String operator;
  
  const MessageScreen({
    super.key, 
    required this.firstName, 
    required this.lastName,
    required this.expertise,
    required this.academicProfile,
    required this.operator,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
                image: AssetImage('assets/images/onboarding_BG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'YOU RECEIVED A MESSAGE',
                      textAlign: TextAlign.center,
                      style: CyberTypography.heading(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${widget.firstName.toUpperCase()} ${widget.lastName.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: CyberTypography.monospace(
                        fontSize: 16,
                        color: CyberColors.textRose,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // ========== PULSING ENVELOPE IMAGE ==========
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CyberColors.primaryNeon.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Image.asset(
                          'assets/pixel_images/ENVELOPE.png',
                          width: 170,
                          height: 170,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.mail_outline,
                              size: 100,
                              color: CyberColors.textRose,
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),

                    // ========== OPEN MESSAGE BUTTON ==========
                    SizedBox(
                      width: 300,
                      child: CyberButton(
                        text: 'OPEN MESSAGE',
                        icon: Icons.mail_outline,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LetterScreen(
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