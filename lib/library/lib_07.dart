import 'package:flutter/material.dart';

class MitigationTechniquesScreen extends StatelessWidget {
  const MitigationTechniquesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Mitigation Techniques',
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
                  // Main text
                  const Text(
                    'Every vulnerability has a corresponding defense — and for SQL Injection and Broken Access Control, those defenses are well-understood, well-documented, and not difficult to implement correctly.',
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
                      'assets/ref_lib/card07.png',
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

                  // Fixing SQL Injection Section
                  const Text(
                    'Fixing SQL Injection: Parameterized Queries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The root cause of SQL Injection is mixing SQL logic with user input. The fix is to keep them permanently separated using parameterized queries (also called prepared statements).',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vulnerable Code Example
                  _buildCodeBlock(
                    title: 'Vulnerable code (never do this):',
                    code: '// PHP — VULNERABLE\n\$query = "SELECT * FROM users WHERE username = \'" . \$_POST[\'username\'] . "\'";\n\n// If the user types:  \' OR \'1\'=\'1\n// The query becomes:  SELECT * FROM users WHERE username = \'\' OR \'1\'=\'1\'\n\n// Result: attacker is logged in as the first user in the database',
                    isVulnerable: true,
                  ),
                  const SizedBox(height: 16),

                  // Fixed Code Example - PHP
                  _buildCodeBlock(
                    title: 'Fixed code (parameterized query, always do this):',
                    code: '// PHP — SECURE (PDO)\n\$stmt = \$pdo->prepare("SELECT * FROM users WHERE username = ? AND password = ?");\n\$stmt->execute([\$_POST[\'username\'], \$_POST[\'password\']]);\n\$user = \$stmt->fetch();\n\n// The ? placeholders tell the database engine to treat the input as DATA only\n// SQL commands inside the input are never executed',
                    isVulnerable: false,
                  ),
                  const SizedBox(height: 16),

                  // Python Example
                  _buildCodeBlock(
                    title: 'Python — SECURE (sqlite3)',
                    code: 'cursor.execute("SELECT * FROM users WHERE username = ? AND password = ?",\n               (username, password))',
                    isVulnerable: false,
                  ),
                  const SizedBox(height: 16),

                  // Java Example
                  _buildCodeBlock(
                    title: 'Java — SECURE (JDBC PreparedStatement)',
                    code: 'PreparedStatement stmt = conn.prepareStatement(\n\t"SELECT * FROM users WHERE username = ? AND password = ?");\nstmt.setString(1, username);\nstmt.setString(2, password);\nResultSet rs = stmt.executeQuery();',
                    isVulnerable: false,
                  ),
                  const SizedBox(height: 24),

                  // The rule to remember
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C8C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.5),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.rule,
                          color: Color(0xFFE68C8C),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Every time your code builds a SQL query using a variable that came from user input (a form field, a URL parameter, an API request body), that variable must go through a parameterized query. No exceptions. One unparameterized query is enough for an attacker to compromise your entire database.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFFE68C8C).withOpacity(0.3),
                  ),
                  const SizedBox(height: 32),

                  // Fixing Broken Access Control Section
                  const Text(
                    'Fixing Broken Access Control: Server-Side Authorization Checks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD1D1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The root cause of Broken Access Control is trusting the client. URLs, form fields, cookies, and JSON bodies can all be modified by an attacker. The fix is to verify permissions on the server — every time, for every request, regardless of what the client sends.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vulnerable IDOR Code
                  _buildCodeBlock(
                    title: 'Vulnerable IDOR code (never do this):',
                    code: '// PHP — VULNERABLE\n// Trusts the id parameter from the URL without checking ownership\n\$order_id = \$_GET["order_id"];\n\$query = "SELECT * FROM orders WHERE id = ?";\n\n// Any logged-in user can view any order by changing the URL',
                    isVulnerable: true,
                  ),
                  const SizedBox(height: 16),

                  // Fixed Code - Server-side ownership check
                  _buildCodeBlock(
                    title: 'Fixed code (server-side ownership check):',
                    code: '// PHP — SECURE\n// Always filter by BOTH the object ID AND the session user ID\n\$order_id = \$_GET["order_id"];\n\$user_id = \$_SESSION["user_id"];   // From the server session — cannot be faked\n\$stmt = \$pdo->prepare(\n\t"SELECT * FROM orders WHERE id = ? AND user_id = ?");\n\$stmt->execute([\$order_id, \$user_id]);\n\$order = \$stmt->fetch();\nif (!\$order) { die("Access denied"); }',
                    isVulnerable: false,
                  ),
                  const SizedBox(height: 16),

                  // Middleware Pattern
                  _buildCodeBlock(
                    title: 'Fixing forced browsing and role tampering (Middleware pattern):',
                    code: '// Middleware pattern (any language or framework)\n// Run this check BEFORE every restricted page loads\nfunction requireRole(user, requiredRole) {\n\tif (user.role !== requiredRole) {\n    \treturn redirect(\'/access-denied\');\n\t}\n}\n\n// NEVER store the role in a URL or hidden form field\n// ALWAYS read the role from the server-side session\n// Server session: role = getFromDatabase(sessionId)',
                    isVulnerable: false,
                  ),
                  const SizedBox(height: 16),

                  // Best Practices Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Best Practices Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('✓ Always use parameterized queries for database access'),
                        _buildBulletPoint('✓ Never trust client-side data (URLs, form fields, cookies)'),
                        _buildBulletPoint('✓ Verify ownership on every server request (object ID + user ID)'),
                        _buildBulletPoint('✓ Store roles in server-side session, never in URL/hidden fields'),
                        _buildBulletPoint('✓ Implement middleware/guard checks for all restricted routes'),
                        _buildBulletPoint('✓ Log access denied attempts to detect attacks'),
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

  Widget _buildCodeBlock({
    required String title,
    required String code,
    required bool isVulnerable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isVulnerable ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isVulnerable
                  ? Colors.red.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
            ),
          ),
          child: SelectableText(
            code,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: Color(0xFFE68C8C),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white70,
        ),
      ),
    );
  }
}