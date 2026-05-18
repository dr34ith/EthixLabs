import 'package:flutter/material.dart';

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Reference Glossary',
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
                  // Header text
                  const Text(
                    'Every technical term used in EthixLabs missions is defined here in plain language. Return to this section whenever you encounter an unfamiliar word.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table Header
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C8C).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Term',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Definition',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Glossary Rows
                  _buildGlossaryRow(
                    term: 'Authentication',
                    definition: 'The process of proving your identity. Logging in with a username and password is authentication.',
                  ),
                  _buildGlossaryRow(
                    term: 'Authorization',
                    definition: 'The process of checking whether you have permission to do something. Even after logging in, the system must verify what you are allowed to access.',
                  ),
                  _buildGlossaryRow(
                    term: 'Broken Access Control (BAC)',
                    definition: 'A vulnerability where a user can perform actions or access data they are not supposed to, because the application fails to verify their permissions properly.',
                  ),
                  _buildGlossaryRow(
                    term: 'CVSS Score',
                    definition: 'Common Vulnerability Scoring System — a number from 0 to 10 that rates how severe a vulnerability is. A score above 7 is considered High or Critical.',
                  ),
                  _buildGlossaryRow(
                    term: 'CWE',
                    definition: 'Common Weakness Enumeration — a community-maintained list of software weakness types. Used by developers to classify and discuss vulnerability categories.',
                  ),
                  _buildGlossaryRow(
                    term: 'Flag',
                    definition: 'In EthixLabs, a flag is a reward you earn for successfully completing a mission stage. It confirms you demonstrated the skill correctly.',
                  ),
                  _buildGlossaryRow(
                    term: 'Forced Browsing',
                    definition: 'Directly typing a URL to access a page that was never linked to you — bypassing the application\'s navigation controls.',
                  ),
                  _buildGlossaryRow(
                    term: 'IDOR',
                    definition: 'Insecure Direct Object Reference — a type of BAC where changing an identifier (like an ID number in a URL) lets you access another user\'s data.',
                  ),
                  _buildGlossaryRow(
                    term: 'Injection',
                    definition: 'A category of attacks where the attacker inserts code or commands into an input that is then executed by the system. SQL Injection is the most common type.',
                  ),
                  _buildGlossaryRow(
                    term: 'OWASP',
                    definition: 'Open Web Application Security Project — a nonprofit that publishes free security research, tools, and the Top 10 list of most critical web application risks.',
                  ),
                  _buildGlossaryRow(
                    term: 'Parameterized Query',
                    definition: 'A way of writing database queries that keeps SQL logic and user input permanently separated, making SQL Injection impossible.',
                  ),
                  _buildGlossaryRow(
                    term: 'Payload',
                    definition: 'A specially crafted input designed to trigger a vulnerability. In EthixLabs, payloads are the inputs you type into VulnShop forms to test for SQL Injection and BAC.',
                  ),
                  _buildGlossaryRow(
                    term: 'Privilege Escalation',
                    definition: 'Gaining a higher level of access than you are supposed to have — for example, a student account gaining admin-level permissions.',
                  ),
                  _buildGlossaryRow(
                    term: 'RA 10175',
                    definition: 'Republic Act 10175, the Philippines\' Cybercrime Prevention Act of 2012. Makes unauthorized access to computer systems a criminal offense.',
                  ),
                  _buildGlossaryRow(
                    term: 'Role Parameter Tampering',
                    definition: 'Modifying a role-related value (in a URL, form, or API request) to attempt to gain higher privileges than your account is authorized for.',
                  ),
                  _buildGlossaryRow(
                    term: 'Session',
                    definition: 'A temporary record the server keeps of who you are after you log in. Your role and permissions should always be read from the server-side session — never from the URL or a cookie value you send.',
                  ),
                  _buildGlossaryRow(
                    term: 'SQL',
                    definition: 'Structured Query Language — the language used to communicate with databases. Every SELECT, INSERT, UPDATE, and DELETE operation on a database is written in SQL.',
                  ),
                  _buildGlossaryRow(
                    term: 'SQL Injection (SQLi)',
                    definition: 'A vulnerability where an attacker inserts SQL commands into an input field, causing the database to execute those commands.',
                  ),
                  _buildGlossaryRow(
                    term: 'Vulnerability',
                    definition: 'A weakness in software, hardware, or a process that an attacker can exploit to cause harm or gain unauthorized access.',
                  ),
                  _buildGlossaryRow(
                    term: 'VulnShop',
                    definition: 'The simulated vulnerable e-commerce application inside EthixLabs where you practice all missions. It does not connect to any real database or network.',
                  ),

                  const SizedBox(height: 16),

                  // Note about glossary
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
                        Icon(Icons.book, color: Color(0xFFE68C8C), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bookmark this glossary! You can come back anytime you see a term you don\'t recognize during missions.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
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

  Widget _buildGlossaryRow({
    required String term,
    required String definition,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE68C8C).withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              term,
              style: const TextStyle(
                color: Color(0xFFE68C8C),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              definition,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}