import 'package:flutter/material.dart';

class ThreeTypesOfHackersScreen extends StatelessWidget {
  const ThreeTypesOfHackersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'The Three Types of Hackers',
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
                    'Not all hackers are criminals — the key difference is permission and intent.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtitle: White Hat, Black Hat, and Grey Hat
                  const Text(
                    'White Hat, Black Hat, and Grey Hat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The security community uses color metaphors to describe hacker types. Understanding the difference matters because it defines what is legal, ethical, and professional.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/ref_lib/card02.png',
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

                  // Comparison Table
                  const Text(
                    'Comparison Table',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),

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
                              'Type',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Permission',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Intent',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD1D1),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Legal?',
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

                  // Row 1: White Hat
                  _buildTableRow(
                    type: 'White Hat',
                    typeColor: Colors.green,
                    permission: 'Always has written authorization',
                    intent: 'Find and report flaws to help the owner',
                    legal: 'Yes',
                    legalColor: Colors.green,
                  ),

                  // Row 2: Black Hat
                  _buildTableRow(
                    type: 'Black Hat',
                    typeColor: Colors.red,
                    permission: 'No authorization whatsoever',
                    intent: 'Steal data, extort money, cause damage',
                    legal: 'No, criminal offense',
                    legalColor: Colors.red,
                  ),

                  // Row 3: Grey Hat
                  _buildTableRow(
                    type: 'Grey Hat',
                    typeColor: Colors.orange,
                    permission: 'Tests without permission, then discloses',
                    intent: 'Often no malicious intent, but irresponsible',
                    legal: 'Still illegal in most jurisdictions',
                    legalColor: Colors.orange,
                  ),

                  const SizedBox(height: 24),

                  // Philippine legal context
                  const Text(
                    'Philippine legal context',
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
                      'Republic Act 10175 (Cybercrime Prevention Act of 2012) makes unauthorized access to any computer system a criminal offense, even if you do not steal anything or cause damage. The penalty can include imprisonment of up to 12 years and fines. In EthixLabs, you are always authorized because all testing happens inside a simulated app on your own device.',
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

  Widget _buildTableRow({
    required String type,
    required Color typeColor,
    required String permission,
    required String intent,
    required String legal,
    required Color legalColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE68C8C).withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: typeColor,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              permission,
              style: TextStyle(
                color: typeColor,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              intent,
              style: TextStyle(
                color: typeColor,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              legal,
              style: TextStyle(
                color: legalColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}