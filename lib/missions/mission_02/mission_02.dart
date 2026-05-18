import 'package:flutter/material.dart';
import 'mission_02_observe.dart';
import 'mission_02_test.dart';
import 'mission_02_identify.dart';
import 'mission_02_analyze.dart';
import 'mission_02_apply.dart';

class Mission_02 extends StatelessWidget {
  const Mission_02({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: null,
        centerTitle: false,
        actions: [
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
      body: Stack(
        children: [
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
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMissionInfoCard(),
                const SizedBox(height: 25),
                _buildStartMissionButton(context),
                const SizedBox(height: 25),
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
                _buildStepCard(
                  context: context,
                  stepNumber: 1,
                  title: 'OBSERVE',
                  description: 'Analyze the SQL query structure and understand how comments could be used to bypass password checks.',
                  icon: Icons.visibility,
                  color: const Color(0xFFE68C8C),
                ),
                const SizedBox(height: 15),
                _buildStepCard(
                  context: context,
                  stepNumber: 2,
                  title: 'TEST',
                  description: 'Test comment injection payloads like admin\'-- to bypass authentication.',
                  icon: Icons.science,
                  color: const Color(0xFFE68C8C),
                ),
                const SizedBox(height: 15),
                _buildStepCard(
                  context: context,
                  stepNumber: 3,
                  title: 'IDENTIFY',
                  description: 'Identify the comment injection technique and understand how it works.',
                  icon: Icons.search,
                  color: const Color(0xFFE68C8C),
                ),
                const SizedBox(height: 15),
                _buildStepCard(
                  context: context,
                  stepNumber: 4,
                  title: 'ANALYZE',
                  description: 'Analyze the impact of comment-based SQL injection attacks.',
                  icon: Icons.analytics,
                  color: const Color(0xFFE68C8C),
                ),
                const SizedBox(height: 15),
                _buildStepCard(
                  context: context,
                  stepNumber: 5,
                  title: 'APPLY',
                  description: 'Apply your knowledge to complete the mission and claim your flag.',
                  icon: Icons.check_circle,
                  color: const Color(0xFFE68C8C),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE68C8C).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33FF8A8A),
            blurRadius: 6.0,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE68C8C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'MISSION 02',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'The Comment Trick (SQLi – Login Bypass with Comments)',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Learn how SQL comment syntax can truncate queries and bypass authentication. '
            'Use payloads like "admin\'--" to neutralize password verification.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
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
                  border: Border.all(color: Colors.white38.withOpacity(0.5)),
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

  Widget _buildStartMissionButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) {
          // Scale down effect on tap
        },
        onTapUp: (_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Mission02Observe()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9B4DCA), Color(0xFFE68C8C)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0x33FF8A8A),
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: const Offset(0, 0),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'START MISSION',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required BuildContext context,
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (stepNumber == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission02Observe()));
        } else if (stepNumber == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission02Test()));
        } else if (stepNumber == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission02Identify()));
        } else if (stepNumber == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission02Analyze()));
        } else if (stepNumber == 5) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Mission02Apply()));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x33FF8A8A),
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
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