import 'package:flutter/material.dart';

class EthicalHackingScreen extends StatelessWidget {
  const EthicalHackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'What is Ethical Hacking?',
          style: TextStyle(
            color: Color(0xFFFFD1D1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE68C8C)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE68C8C).withOpacity(0.3),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE68C8C).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main text
                  const Text(
                    'Ethical hacking means finding security weaknesses in a system with the owner\'s permission so they can be fixed before a real attacker finds them.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Paragraph 2
                  const Text(
                    'Every digital system you interact with — your school portal, your GCash app, your online banking — has code written by developers who, like all humans, occasionally make mistakes. Those mistakes can become security weaknesses called vulnerabilities. A vulnerability is like a broken lock on a door: it exists whether or not anyone knows about it.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Paragraph 3
                  const Text(
                    'An ethical hacker\'s job is to find those broken locks first. The key word is permission. Without written permission from the system owner, probing a system for vulnerabilities is illegal under the Philippines\' Republic Act 10175 (Cybercrime Prevention Act of 2012) — even if you never actually break anything.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image - FIXED
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/ref_lib/card01.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.black.withOpacity(0.6),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: Color(0xFFE68C8C),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subtitle: What ethical hackers do
                  const Text(
                    'What ethical hackers do',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const BulletPoint(text: 'Test systems, apps, and networks for security weaknesses'),
                  const BulletPoint(text: 'Document every finding clearly and honestly'),
                  const BulletPoint(text: 'Report vulnerabilities to the owner, not exploit them for personal gain'),
                  const BulletPoint(text: 'Suggest and verify fixes'),
                  const BulletPoint(text: 'Never steal data, cause damage, or access systems beyond what was agreed'),
                  const SizedBox(height: 24),

                  // Subtitle: Real-world example
                  const Text(
                    'Real-world example and Why this matters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C8C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'In 2023, a Filipino university\'s student portal was found to expose grade records of thousands of students simply by changing a number in the URL. A responsible student who discovered this reported it to the IT department. That student acted as an ethical hacker. The university fixed the vulnerability before any malicious actor exploited it.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subtitle: Your role
                  const Text(
                    'Your role in EthixLabs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C8C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'In EthixLabs, you are assigned as an Ethical Hacker auditing VulnShop, a simulated e-commerce application. Everything you test exists only inside the app. No real systems are involved. Your goal in each mission is to find a vulnerability, understand why it exists, and learn how to fix it — following the same process a professional security tester would use.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable bullet point widget
class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: Color(0xFFE68C8C),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}