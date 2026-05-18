import 'package:flutter/material.dart';

class SQLInjectionScreen extends StatelessWidget {
  const SQLInjectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'SQL Injection',
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
                    'SQL Injection happens when an attacker is able to insert their own database commands into an input field that was not properly protected.',
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
                      'assets/ref_lib/card05.png',
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

                  // What is SQL?
                  const Text(
                    'What is SQL?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SQL (Structured Query Language) is the language databases use to store and retrieve information. When you log in to a website, the site runs a SQL query something like this:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Code block 1
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE68C8C),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'SQL Query Example',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFFD1D1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const SelectableText(
                          'SELECT * FROM users\nWHERE username = \'alex\'\nAND password = \'mypassword\';',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'monospace',
                            color: Color(0xFFE68C8C),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This query asks the database: "Does a user named alex with this password exist?" If the answer is yes, you are logged in.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // How the attack works
                  const Text(
                    'How the attack works',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The vulnerability appears when a developer builds that query by directly pasting in whatever the user typed, without checking it first. An attacker can type a specially crafted input — called a payload — that changes the meaning of the SQL query.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Attack example box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C8C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFE68C8C),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Attack Example',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'If the attacker types the following into the username field:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const SelectableText(
                            '\' OR \'1\'=\'1',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                              color: Color(0xFFE68C8C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'The query the database receives becomes:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const SelectableText(
                            'SELECT * FROM users\nWHERE username = \'\' OR \'1\'=\'1\'\nAND password = \'anything\';',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: Color(0xFFE68C8C),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE68C8C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE68C8C).withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFFE68C8C),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'The condition \'1\'=\'1\' is always true. The database returns the first user in the table, usually the administrator — and the attacker is logged in without knowing any password.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visual representation of the attack flow
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildFlowStep('1', 'User Input', '\' OR \'1\'=\'1'),
                        _buildArrow(),
                        _buildFlowStep('2', 'Vulnerable Code', 'Direct concatenation without sanitization'),
                        _buildArrow(),
                        _buildFlowStep('3', 'Modified Query', 'WHERE username = \'\' OR \'1\'=\'1\''),
                        _buildArrow(),
                        _buildFlowStep('4', 'Result', 'Returns admin user → Unauthorized login'),
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

  Widget _buildFlowStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFE68C8C).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFFFFD1D1),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD1D1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_downward,
            color: Color(0xFFE68C8C),
            size: 16,
          ),
        ],
      ),
    );
  }
}