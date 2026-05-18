import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/missions/mission_05/mission_05_test.dart';

class Mission05Observe extends StatelessWidget {
  const Mission05Observe({Key? key}) : super(key: key);

  Widget _buildObservationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFE68C8C), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 1 OF 5',
      stepTitle: 'Observe the Target',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission05Test()),
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
            const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Color(0xFFE68C8C), size: 24),
                SizedBox(width: 12),
                Text(
                  'Scenario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE68C8C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'You are logged into VulnShop as a regular user. The navigation menu shows only customer options. However, you suspect the admin dashboard might be accessible via a direct URL without proper role verification.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Observations:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE68C8C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildObservationItem('Logged in as regular user'),
                  _buildObservationItem('No admin links in navigation'),
                  _buildObservationItem('Admin dashboard likely exists at /admin/dashboard'),
                  _buildObservationItem('Application may rely on "security through obscurity"'),
                  _buildObservationItem('No visible access control on backend'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}