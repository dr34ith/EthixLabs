import 'package:flutter/material.dart';

class SecureCodingScreen extends StatelessWidget {
  const SecureCodingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Secure Coding for Developers',
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
            // Main Card Container
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
                  // Main definition
                  const Text(
                    'Secure coding means writing code that assumes attackers will try to break it — and that still works correctly when they do.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/ref_lib/card08.png',
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

                  // The five principles section
                  const Text(
                    'The five principles every beginner developer needs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Principle 1: Never trust user input
                  _buildPrincipleCard(
                    number: '01',
                    title: 'Never trust user input',
                    description: 'Treat every value that comes from a browser, app, or API as potentially malicious. Validate it, sanitize it, and use it only through parameterized queries or safe APIs.',
                    icon: Icons.input,
                  ),
                  const SizedBox(height: 12),

                  // Principle 2: Enforce authorization server-side
                  _buildPrincipleCard(
                    number: '02',
                    title: 'Enforce authorization server-side',
                    description: 'Every restricted page, API endpoint, and data record must be protected by a server-side permission check. Never hide buttons on the frontend and assume that is enough — attackers skip the UI entirely.',
                    icon: Icons.security,
                  ),
                  const SizedBox(height: 12),

                  // Principle 3: Least privilege
                  _buildPrincipleCard(
                    number: '03',
                    title: 'Use the principle of least privilege',
                    description: 'Give every user account and every database account only the minimum permissions they need. Your web app\'s database account should never have DROP TABLE permission.',
                    icon: Icons.verified_user,
                  ),
                  const SizedBox(height: 12),

                  // Principle 4: Keep secrets out of code
                  _buildPrincipleCard(
                    number: '04',
                    title: 'Keep secrets out of your code',
                    description: 'Database passwords, API keys, and session secrets must never be hardcoded in source code. Use environment variables or a secrets manager.',
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 12),

                  // Principle 5: Fail securely
                  _buildPrincipleCard(
                    number: '05',
                    title: 'Fail securely',
                    description: 'When something goes wrong, show the user a generic error message. Never display database error messages, stack traces, or SQL query text to the user — these give attackers free information.',
                    icon: Icons.error_outline,
                  ),
                  const SizedBox(height: 24),

                  // For BSIT/BSCS students section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE68C8C).withOpacity(0.15),
                          const Color(0xFFE68C8C).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE68C8C).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'For BSIT/BSCS students entering the workforce',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD1D1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'These five principles are not theoretical. When you join a software team, your code will be reviewed for exactly these issues. Companies doing ISO 27001 certification, government ICT projects following DICT guidelines, and any company with international clients will require these practices as a baseline. Knowing them now puts you ahead of most fresh graduates.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick reference card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.quick_contacts_dialer,
                              color: Color(0xFFE68C8C),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Quick Reference Checklist',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE68C8C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildChecklistItem('✓ Validate all user input on the server side'),
                        _buildChecklistItem('✓ Use parameterized queries for every database call'),
                        _buildChecklistItem('✓ Implement authorization checks for every restricted resource'),
                        _buildChecklistItem('✓ Never store passwords, keys, or secrets in source code'),
                        _buildChecklistItem('✓ Use environment variables for configuration'),
                        _buildChecklistItem('✓ Show generic error messages to users, log details internally'),
                        _buildChecklistItem('✓ Apply least privilege to all database and service accounts'),
                      ],
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

  Widget _buildPrincipleCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE68C8C).withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE68C8C).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE68C8C).withOpacity(0.5),
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD1D1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: const Color(0xFFE68C8C),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white70,
        ),
      ),
    );
  }
}