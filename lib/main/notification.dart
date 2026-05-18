import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  // List of flags (static)
  final List<String> _flags = const [
    'ETHIX{SQLI_LOGIN_BYPASS}',
    'ETHIX{SQLI_COMMENT_BYPASS}',
    'ETHIX{BAC_IDOR_ORDER}',
    'ETHIX{PHISH_URL_SPOOF}',
    'ETHIX{BAC_ADMIN_URL_ACCESS}',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2A),
      appBar: AppBar(
        title: const Text(
          'Claimed Flags',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2F1121),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _flags.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE68C8C).withOpacity(0.15),
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE68C8C).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
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
                  child: const Icon(
                    Icons.flag,
                    color: Color(0xFFE68C8C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _flags[index],
                    style: const TextStyle(
                      color: Color(0xFFE68C8C),
                      fontSize: 14,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}