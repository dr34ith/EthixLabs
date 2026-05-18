import 'package:flutter/material.dart';
import 'package:test_vuln/theme/cyber_theme.dart';
import 'package:test_vuln/widgets/premium_button.dart';

class StepLayout extends StatelessWidget {
  final String stepNumber;
  final String stepTitle;
  final Widget child;
  final VoidCallback? onNextPressed;
  final String? nextButtonText;

  const StepLayout({
    Key? key,
    required this.stepNumber,
    required this.stepTitle,
    required this.child,
    this.onNextPressed,
    this.nextButtonText = 'Next Step',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/icons/vulnShop.png',
              height: 45,
              width: 45,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image, color: Colors.white, size: 25),
                );
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [CyberTheme.primaryAccent, CyberTheme.secondaryAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Background image — fills the entire screen including behind AppBar
            Positioned.fill(
              child: Image.asset(
                'assets/images/mission_bg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade900, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dark overlay for readability
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

            // Scrollable content — padded so it starts below the AppBar
            SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: CyberTheme.primaryAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: CyberTheme.primaryAccent),
                  ),
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CyberTheme.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Step title
                Text(
                  stepTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Page-specific content
                child,

                const SizedBox(height: 30),

                // Next button
                if (onNextPressed != null)
                  PremiumButton(
                    text: nextButtonText!,
                    icon: Icons.arrow_forward,
                    onPressed: onNextPressed,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}