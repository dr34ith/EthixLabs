import 'package:flutter/material.dart';
import 'package:ethixlabs/onboard/expertise.dart';
import 'package:ethixlabs/onboard/cyber_components.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_validateInputs);
    lastNameController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _canContinue = firstNameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty;
    });
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
                    const CyberProgressBar(currentStep: 1, totalSteps: 4),
                    const SizedBox(height: 50),

                    // ========== TITLE ==========
                    Text(
                      'WELCOME,\nETHICAL HACKER',
                      textAlign: TextAlign.center,
                      style: CyberTypography.heading(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ========== SUBTITLE ==========
                    Text(
                      'Please enter your full name. This will appear on\nyour official Certificate of Completion.',
                      textAlign: TextAlign.center,
                      style: CyberTypography.monospace(
                        fontSize: 12,
                        color: CyberColors.textDim,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ========== FIRST NAME FIELD ==========
                    SizedBox(
                      width: 320,
                      child: CyberTextField(
                        controller: firstNameController,
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========== LAST NAME FIELD ==========
                    SizedBox(
                      width: 320,
                      child: CyberTextField(
                        controller: lastNameController,
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // ========== CONTINUE BUTTON ==========
                    SizedBox(
                      width: 320,
                      child: CyberButton(
                        text: 'CONTINUE',
                        icon: Icons.arrow_forward,
                        onPressed: _canContinue
                            ? () {
                                String firstName = firstNameController.text.trim();
                                String lastName = lastNameController.text.trim();
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpertiseScreen(
                                      firstName: firstName,
                                      lastName: lastName,
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