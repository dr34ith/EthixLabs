import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/workflow.dart'; 
import 'package:ethixlabs/onboard/cyber_components.dart';
import 'package:google_fonts/google_fonts.dart';

class LearningPathScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  final String academicProfile;
  final String operator;
  
  const LearningPathScreen({
    super.key, 
    required this.firstName, 
    required this.lastName,
    required this.expertise,
    required this.academicProfile,
    required this.operator,
  });

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
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // ========== HEADER ==========
                Center(
                  child: Text(
                    'LEARNING PATH',
                    textAlign: TextAlign.center,
                    style: CyberTypography.heading(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Welcome message
                Center(
                  child: Text(
                    'Welcome, ${firstName.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: CyberTypography.monospace(
                      fontSize: 12,
                      color: CyberColors.primaryGlow,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // ========== LEARNING PATH LIST ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildPathCard(
                          'Pre-Test',
                          'Assess your baseline knowledge before starting any mission.',
                          Icons.assignment_outlined,
                          1,
                        ),
                        const SizedBox(height: 12),
                        _buildPathCard(
                          'Basics',
                          'Get familiar with the app, VulnShop, and your role as an Ethical Hacker.',
                          Icons.school_outlined,
                          2,
                        ),
                        const SizedBox(height: 12),
                        _buildPathCard(
                          'Foundational',
                          'Learn and practice common web application vulnerabilities from scratch.',
                          Icons.psychology_outlined,
                          3,
                        ),
                        const SizedBox(height: 12),
                        _buildPathCard(
                          'Intermediate',
                          'Tackle more complex attack scenarios that require deeper analysis.',
                          Icons.trending_up_outlined,
                          4,
                        ),
                        const SizedBox(height: 12),
                        _buildPathCard(
                          'Advanced',
                          'Train unique vulnerabilities together to perform reconnaissance attacks.',
                          Icons.flash_on_outlined,
                          5,
                        ),
                        const SizedBox(height: 12),
                        _buildPathCard(
                          'Post Test and Certification',
                          'Prove your growth and pass the final test to earn your completion certificate.',
                          Icons.verified_outlined,
                          6,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // ========== CONTINUE BUTTON ==========
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: 300,
                    child: CyberButton(
                      text: 'START LEARNING',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkflowScreen(
                              firstName: firstName,
                              lastName: lastName,
                              expertise: expertise,
                              academicProfile: academicProfile,
                              operator: operator,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathCard(String title, String description, IconData icon, int stepNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CyberColors.primaryGlow.withOpacity(0.2),
          width: 1,
        ),
        color: Colors.black.withOpacity(0.55),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Step number circle with neon gradient
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [CyberColors.primaryNeon, CyberColors.primaryGlow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: CyberColors.primaryNeon,
                  blurRadius: 8,
                  spreadRadius: -2,
                )
              ],
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: CyberColors.secondaryGlow,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.orbitron(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: CyberColors.textRose,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    color: CyberColors.textDim,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Arrow icon
          const Icon(
            Icons.arrow_forward_ios,
            color: CyberColors.primaryGlow,
            size: 14,
          ),
        ],
      ),
    );
  }
}