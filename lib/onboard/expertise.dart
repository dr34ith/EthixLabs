import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/academic.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class ExpertiseScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  
  const ExpertiseScreen({
    super.key, 
    required this.firstName, 
    required this.lastName
  });

  @override
  State<ExpertiseScreen> createState() => _ExpertiseScreenState();
}

class _ExpertiseScreenState extends State<ExpertiseScreen> {
  String? selectedExpertise;

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

          // Dark overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Progress Bar
                    const CyberProgressBar(currentStep: 2, totalSteps: 4),
                    const SizedBox(height: 50),

                    // ========== QUESTION ==========
                    Text(
                      'How would you describe your\ncybersecurity experience?',
                      textAlign: TextAlign.center,
                      style: CyberTypography.heading(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ========== OPTIONS ==========
                    CyberOptionCard(
                      title: 'Novice',
                      subtitle: 'Brand new to cybersecurity, ready to learn concepts.',
                      icon: Icons.rocket_launch_outlined,
                      isSelected: selectedExpertise == 'Novice',
                      onTap: () {
                        setState(() {
                          selectedExpertise = 'Novice';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CyberOptionCard(
                      title: 'Beginner',
                      subtitle: 'Understand the basics, looking for hands-on labs.',
                      icon: Icons.school_outlined,
                      isSelected: selectedExpertise == 'Beginner',
                      onTap: () {
                        setState(() {
                          selectedExpertise = 'Beginner';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CyberOptionCard(
                      title: 'Experienced',
                      subtitle: 'Familiar with exploits, looking for advanced tests.',
                      icon: Icons.psychology_outlined,
                      isSelected: selectedExpertise == 'Experienced',
                      onTap: () {
                        setState(() {
                          selectedExpertise = 'Experienced';
                        });
                      },
                    ),

                    const SizedBox(height: 50),

                    // ========== CONTINUE BUTTON ==========
                    SizedBox(
                      width: 320,
                      child: CyberButton(
                        text: 'CONTINUE',
                        icon: Icons.arrow_forward,
                        onPressed: selectedExpertise != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AcademicProfileScreen(
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      expertise: selectedExpertise!,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
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