import 'package:flutter/material.dart';
import 'package:ethixlabs/main/main_layout.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';

class WorkflowScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String expertise;
  final String academicProfile;
  final String operator;
  
  const WorkflowScreen({
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

          // Dark overlay for text readability
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
                    'STRUCTURED LEARNING\nWORKFLOW',
                    textAlign: TextAlign.center,
                    style: CyberTypography.heading(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      height: 1.2,
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
                
                // ========== WORKFLOW LIST ==========
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildWorkflowCard(
                          'Learn',
                          'Read about the vulnerability before doing anything, understand what it is and why it exists.',
                          Icons.menu_book_outlined,
                          1,
                        ),
                        const SizedBox(height: 12),
                        _buildWorkflowCard(
                          'Observe',
                          'Read the interaction and observe where the weakness is located.',
                          Icons.visibility_outlined,
                          2,
                        ),
                        const SizedBox(height: 12),
                        _buildWorkflowCard(
                          'Test',
                          'Submit inputs and payloads to see how the vulnerable system responds.',
                          Icons.science_outlined,
                          3,
                        ),
                        const SizedBox(height: 12),
                        _buildWorkflowCard(
                          'Identify',
                          'Based on what you observed, select the correct vulnerability type.',
                          Icons.search_outlined,
                          4,
                        ),
                        const SizedBox(height: 12),
                        _buildWorkflowCard(
                          'Analyze',
                          'Then, assess the real world impact, what could an attacker do with the flow?',
                          Icons.analytics_outlined,
                          5,
                        ),
                        const SizedBox(height: 12),
                        _buildWorkflowCard(
                          'Apply the Remediation',
                          'Choose and confirm the correct fix to secure the vulnerability.',
                          Icons.build_outlined,
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
                      text: 'START YOUR JOURNEY',
                      icon: Icons.flash_on,
                      onPressed: () {
                        // Save user profile via AppProvider
                        final provider = context.read<AppProvider>();
                        provider.setName('$firstName $lastName');
                        provider.setHero(operator.toLowerCase());
                        provider.setDegree(academicProfile);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainLayout()),
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

  Widget _buildWorkflowCard(String title, String description, IconData icon, int stepNumber) {
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