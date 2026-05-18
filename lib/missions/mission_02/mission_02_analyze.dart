import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'mission_02_apply.dart';

class Mission02Analyze extends StatelessWidget {
  const Mission02Analyze({Key? key}) : super(key: key);

  Widget _buildImpactCard(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white38.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE68C8C), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE68C8C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 4 OF 5',
      stepTitle: 'Analyze the Impact',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission02Apply()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE68C8C).withOpacity(0.15),
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE68C8C).withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impact Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE68C8C),
              ),
            ),
            const SizedBox(height: 16),
            _buildImpactCard(
              'What can an attacker do?',
              'Comment syntax can truncate queries, bypassing authentication. Attackers can use this even when the original query structure is unknown.',
              Icons.warning,
            ),
            const SizedBox(height: 12),
            _buildImpactCard(
              'Consequences',
              '• Unauthorized admin access\n• Data theft\n• Account takeover\n• Complete system compromise',
              Icons.security,
            ),
            const SizedBox(height: 12),
            _buildImpactCard(
              'CVSS Score',
              '9.8 (Critical)',
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }
}