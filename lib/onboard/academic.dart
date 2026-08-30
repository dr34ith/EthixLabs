import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/character.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class AcademicProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  
  const AcademicProfileScreen({
    super.key, 
    required this.firstName, 
    required this.lastName,
    required this.expertise,
  });

  @override
  State<AcademicProfileScreen> createState() => _AcademicProfileScreenState();
}

class _AcademicProfileScreenState extends State<AcademicProfileScreen> {
  String? selectedAcademicProfile;

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
                    const CyberProgressBar(currentStep: 3, totalSteps: 4),
                    const SizedBox(height: 40),

                    // ========== TITLE ==========
                    Text(
                      'ACADEMIC PROFILE',
                      textAlign: TextAlign.center,
                      style: CyberTypography.heading(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ========== OPTIONS ==========
                    CyberOptionCard(
                      title: 'BSCS',
                      subtitle: 'Bachelor of Science in Computer Science',
                      icon: Icons.computer,
                      isSelected: selectedAcademicProfile == 'BSCS',
                      onTap: () {
                        setState(() {
                          selectedAcademicProfile = 'BSCS';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CyberOptionCard(
                      title: 'BSIT',
                      subtitle: 'Bachelor of Science in Information Technology',
                      icon: Icons.devices,
                      isSelected: selectedAcademicProfile == 'BSIT',
                      onTap: () {
                        setState(() {
                          selectedAcademicProfile = 'BSIT';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CyberOptionCard(
                      title: 'Other Course',
                      subtitle: 'Different field of academic study',
                      icon: Icons.school_outlined,
                      isSelected: selectedAcademicProfile == 'Other Course',
                      onTap: () {
                        setState(() {
                          selectedAcademicProfile = 'Other Course';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CyberOptionCard(
                      title: 'Not a student',
                      subtitle: 'Working professional / other background',
                      icon: Icons.business_center_outlined,
                      isSelected: selectedAcademicProfile == 'Not a student',
                      onTap: () {
                        setState(() {
                          selectedAcademicProfile = 'Not a student';
                        });
                      },
                    ),

                    const SizedBox(height: 45),

                    // ========== CONTINUE BUTTON ==========
                    SizedBox(
                      width: 320,
                      child: CyberButton(
                        text: 'CONTINUE',
                        icon: Icons.arrow_forward,
                        onPressed: selectedAcademicProfile != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OperatorChoiceScreen(
                                      firstName: widget.firstName,
                                      lastName: widget.lastName,
                                      expertise: widget.expertise,
                                      academicProfile: selectedAcademicProfile!,
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