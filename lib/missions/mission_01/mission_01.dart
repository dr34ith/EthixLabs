import 'package:flutter/material.dart';
import 'mission_01_observe.dart';
import 'mission_01_test.dart';
import 'mission_01_identify.dart';
import 'mission_01_analyze.dart';
import 'mission_01_apply.dart';

class Mission_01 extends StatelessWidget {
  const Mission_01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar with back button on left and logo on right
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Returns to missions page
          },
          tooltip: 'Back to Missions',
        ),
        title: null, // No title to give space for logo
        centerTitle: false,
        actions: [
          // Logo photo on the right side
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/icons/vulnShop.png',
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image, color: Colors.white, size: 30),
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
              colors: [Color(0xFFE68C8C), Color(0xFFC76B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // Body with background image
      body: Stack(
        children: [
          // Background image
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

          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Scrollable content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission Title & Description Card
                _buildMissionInfoCard(),
                const SizedBox(height: 25),

                // 5 Step Cards Section Title
                const Text(
                  'MISSION STEPS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE68C8C),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 15),

                // Step 1: Observe (using base pink color)
                _buildStepCard(
                  context: context,
                  stepNumber: 1,
                  title: 'OBSERVE',
                  description: 'Analyze the target application and identify potential SQL injection entry points.',
                  icon: Icons.visibility,
                  color: const Color(0xFFE68C8C), // Base pink
                ),

                const SizedBox(height: 15),

                // Step 2: Test (using darker pink)
                _buildStepCard(
                  context: context,
                  stepNumber: 2,
                  title: 'TEST',
                  description: 'Test the identified entry points with SQL injection payloads.',
                  icon: Icons.science,
                  color: const Color(0xFFE68C8C), // Same base pink
                ),

                const SizedBox(height: 15),

                // Step 3: Identify (using slightly lighter pink)
                _buildStepCard(
                  context: context,
                  stepNumber: 3,
                  title: 'IDENTIFY',
                  description: 'Identify the vulnerability type and confirm SQL injection exists.',
                  icon: Icons.search,
                  color: const Color(0xFFE68C8C), // Same base pink
                ),

                const SizedBox(height: 15),

                // Step 4: Analyze (using medium pink)
                _buildStepCard(
                  context: context,
                  stepNumber: 4,
                  title: 'ANALYZE',
                  description: 'Analyze the database structure and extract useful information.',
                  icon: Icons.analytics,
                  color: const Color(0xFFE68C8C), // Same base pink
                ),

                const SizedBox(height: 15),

                // Step 5: Apply (using original pink)
                _buildStepCard(
                  context: context,
                  stepNumber: 5,
                  title: 'APPLY',
                  description: 'Apply your knowledge to bypass authentication and complete the mission.',
                  icon: Icons.check_circle,
                  color: const Color(0xFFE68C8C), // Same base pink
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mission Info Card Widget
  Widget _buildMissionInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFE68C8C).withOpacity(0.15), Colors.black.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE68C8C).withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mission badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE68C8C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'MISSION 01',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Title
          const Text(
            'The Unlocked Door (SQLi – Login Bypass)',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          const Text(
            'Learn how SQL injection works by bypassing authentication mechanisms. '
                'Use tautology payloads like "OR \'1\'=\'1" to access admin accounts without credentials.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),

          // Difficulty indicator
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFFE68C8C), size: 16),
              const SizedBox(width: 5),
              const Text(
                'Difficulty: ',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFE68C8C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFE68C8C).withOpacity(0.5)),
                ),
                child: const Text(
                  'BEGINNER',
                  style: TextStyle(
                    color: Color(0xFFE68C8C),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step Card Widget (with uniform pink color for all steps)
  Widget _buildStepCard({
    required BuildContext context,
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color, // Now using the same pink for all steps
  }) {
    return GestureDetector(
      onTap: () {
        if (stepNumber == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission01Observe()));
        } else if (stepNumber == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission01Test()));
        } else if (stepNumber == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission01Identify()));
        } else if (stepNumber == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission01Analyze()));
        } else if (stepNumber == 5) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission01Apply()));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Step number and icon with pink gradient
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(height: 2),
                  Text(
                    '0$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),

            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color, // Pink text color
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),


            // Arrow icon with pink color
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}