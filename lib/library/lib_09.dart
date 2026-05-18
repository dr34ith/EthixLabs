import 'package:flutter/material.dart';

class ExternalResourcesScreen extends StatelessWidget {
  const ExternalResourcesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'External Resources',
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
                    'Official references, community labs, and cheat sheets for the latest OWASP standard.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card 1: OWASP Top 10:2025 (Official)
                  _buildResourceCard(
                    number: '1',
                    resource: 'OWASP Top 10:2025 (Official)',
                    description: 'The authoritative source for the top ten web application security risks. Read the full description of A01 and A03 to deepen your understanding beyond EthixLabs missions.',
                    link: 'owasp.org/Top10',
                  ),
                  const SizedBox(height: 16),

                  // Card 2: TCM Security
                  _buildResourceCard(
                    number: '2',
                    resource: 'OWASP Top 10:2025 Explained — TCM Security',
                    description: 'A beginner-friendly breakdown of each OWASP category with real examples. Particularly clear explanations of Broken Access Control and Injection.',
                    link: 'tcm-sec.com',
                  ),
                  const SizedBox(height: 16),

                  // Card 3: CWE Top 25 (2025) — MITRE
                  _buildResourceCard(
                    number: '3',
                    resource: 'CWE Top 25 (2025) — MITRE',
                    description: 'The Common Weakness Enumeration list used by developers and security engineers to map vulnerabilities to code-level weaknesses. Essential for connecting OWASP risks to actual code patterns.',
                    link: 'cwe.mitre.org',
                  ),
                  const SizedBox(height: 16),

                  // Card 4: PayloadsAllTheThings
                  _buildResourceCard(
                    number: '4',
                    resource: 'PayloadsAllTheThings — GitHub',
                    description: 'A community-maintained repository of real-world test payloads for SQL Injection, IDOR, and dozens of other vulnerability types. Use as a reference after completing EthixLabs missions.',
                    link: 'github.com/swisskyrepo/PayloadsAllTheThings',
                  ),
                  const SizedBox(height: 16),

                  // Card 5: PortSwigger Web Security Academy
                  _buildResourceCard(
                    number: '5',
                    resource: 'PortSwigger Web Security Academy',
                    description: 'Completely free, hands-on web security labs covering every OWASP category. The SQL Injection and Access Control learning paths are particularly well-structured for beginners. Requires internet.',
                    link: 'portswigger.net/web-security',
                  ),
                  const SizedBox(height: 16),

                  // Card 6: DICT Cybersecurity Roadmap
                  _buildResourceCard(
                    number: '6',
                    resource: 'DICT Cybersecurity Roadmap (Philippines)',
                    description: 'The Department of Information and Communications Technology\'s national cybersecurity strategy. Relevant for Filipino students entering the government or public sector ICT workforce.',
                    link: 'dict.gov.ph',
                  ),
                  const SizedBox(height: 16),

                  // Note about resources
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
                        Icon(Icons.info_outline, color: Color(0xFFE68C8C), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'These external resources are free to access and will help you go beyond the basics covered in EthixLabs.',
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

  Widget _buildResourceCard({
    required String number,
    required String resource,
    required String description,
    required String link,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE68C8C).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Header with number and resource
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE68C8C).withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE68C8C).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Color(0xFFFFD1D1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    resource,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body with description and link
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What you will find there:',
                  style: TextStyle(
                    color: Color(0xFFE68C8C),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE68C8C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.link,
                        color: Color(0xFFE68C8C),
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        link,
                        style: const TextStyle(
                          color: Color(0xFFE68C8C),
                          fontSize: 11,
                          decoration: TextDecoration.underline,
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
    );
  }
}