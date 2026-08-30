import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';

class PosttestScreen extends StatefulWidget {
  const PosttestScreen({Key? key}) : super(key: key);

  @override
  State<PosttestScreen> createState() => _PosttestScreenState();
}

class _PosttestScreenState extends State<PosttestScreen> {
  int _currentQ = 0;
  int _score = 0;
  final Map<int, int> _answers = {};
  bool _submitted = false;

  static const _questions = [
    {'q': 'What is the root cause of SQL Injection vulnerabilities?', 'options': ['Weak passwords', 'Concatenating user input into SQL queries without parameterization', 'Missing HTTPS', 'Insecure session tokens'], 'correct': 1},
    {'q': 'IDOR (Insecure Direct Object Reference) can be prevented by:', 'options': ['Using random IDs instead of sequential ones', 'Server-side authorization checks verifying ownership', 'Encrypting object IDs', 'Rate limiting API requests'], 'correct': 1},
    {'q': 'Which attack type stores the malicious payload in the database?', 'options': ['Reflected XSS', 'DOM-based XSS', 'Stored XSS', 'CSRF'], 'correct': 2},
    {'q': 'The correct modern algorithm for password hashing is:', 'options': ['MD5', 'SHA-1', 'bcrypt or Argon2id', 'AES-256'], 'correct': 2},
    {'q': 'Forced browsing exploits:', 'options': ['SQL vulnerabilities', 'Missing server-side access controls on unlinked URLs', 'Weak session tokens', 'Unencrypted HTTP traffic'], 'correct': 1},
    {'q': 'What does a tautology SQL injection payload do to the WHERE clause?', 'options': ['Deletes all records', 'Makes the condition always evaluate to true', 'Extracts data via UNION', 'Causes a timeout'], 'correct': 1},
    {'q': 'Content Security Policy (CSP) primarily protects against:', 'options': ['SQL injection', 'Cross-Site Scripting (XSS)', 'IDOR', 'Brute force attacks'], 'correct': 1},
    {'q': 'Session tokens should be stored in:', 'options': ['URL query parameters', 'Local storage', 'HttpOnly Secure cookies', 'The page title'], 'correct': 2},
    {'q': 'What does A02 — Security Misconfiguration include?', 'options': ['SQL injection attacks', 'Verbose error messages, exposed files, default credentials left unchanged', 'Weak cryptographic algorithms', 'Missing authentication'], 'correct': 1},
    {'q': 'Prompt Injection (LLM01) allows attackers to:', 'options': ['Inject SQL into LLM-powered databases', 'Override an AI model\'s instructions to perform unauthorized actions', 'Steal training data', 'Break the AI model permanently'], 'correct': 1},
    {'q': 'HTTPS prevents which attack?', 'options': ['SQL injection', 'XSS', 'Man-in-the-Middle (MITM) interception of data in transit', 'IDOR'], 'correct': 2},
    {'q': 'Privilege escalation via parameter tampering occurs when:', 'options': ['An attacker guesses admin passwords', 'The server trusts client-submitted role or permission values', 'SQL injection grants admin access', 'A CSRF attack changes user roles'], 'correct': 1},
    {'q': 'What is the CVSS base score for a critical SQL injection with full authentication bypass?', 'options': ['3.1', '5.3', '7.5', '9.8'], 'correct': 3},
    {'q': 'Blind SQL injection differs from standard SQL injection because:', 'options': ['It only works on blind users', 'The database returns no error messages, and the attacker infers results from behavioral differences', 'It doesn\'t affect the database', 'It requires special tools'], 'correct': 1},
    {'q': 'The .env file should be:', 'options': ['Stored in the web root for easy access', 'Outside the web root and blocked by server configuration', 'Encrypted and stored in the database', 'Shared with all developers'], 'correct': 1},
    {'q': 'Under Philippine law (RA 10175), the ethical hacker MUST have:', 'options': ['A CS/IT degree', 'Written authorization from the system owner before testing', 'A government license', 'More than 3 years experience'], 'correct': 1},
    {'q': 'UNION-based SQL injection requires that both SELECT queries:', 'options': ['Run on the same database', 'Return the same number of columns with compatible types', 'Use the same table', 'Execute within 1 second'], 'correct': 1},
    {'q': 'Account lockout prevents which type of attack?', 'options': ['SQL injection', 'XSS', 'Brute force and credential stuffing', 'IDOR'], 'correct': 2},
    {'q': 'Which OWASP 2025 category covers SQL injection AND XSS?', 'options': ['A01 — Broken Access Control', 'A02 — Security Misconfiguration', 'A04 — Cryptographic Failures', 'A05 — Injection'], 'correct': 3},
    {'q': 'After completing all 25 missions and passing the post-test with 80%+, which reward is earned?', 'options': ['Key #3 and Chest #3', 'Key #6, Key #7, Chest #6, Chest #7, and Certificate', 'Only the graduation badge', 'The CAPYX hero'], 'correct': 1},
  ];

  void _selectAnswer(int optionIndex) {
    if (_answers.containsKey(_currentQ)) return;
    setState(() {
      _answers[_currentQ] = optionIndex;
      final correct = _questions[_currentQ]['correct'] as int;
      if (optionIndex == correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_currentQ < _questions.length - 1) {
        setState(() => _currentQ++);
      } else {
        setState(() => _submitted = true);
      }
    });
  }

  void _finishTest() {
    final percentage = (_score / _questions.length * 100).round();
    context.read<AppProvider>().completePosttestWith(percentage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Post-Test Assessment', style: GoogleFonts.orbitron(fontSize: 14)),
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: !_submitted,
        leading: _submitted ? null : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _submitted ? _buildResults() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_currentQ];
    final options = q['options'] as List<String>;
    final correct = q['correct'] as int;
    final answered = _answers.containsKey(_currentQ);
    final selectedAnswer = _answers[_currentQ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentQ + 1) / _questions.length,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE68C8C)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${_currentQ + 1}/${_questions.length}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Score: $_score', style: GoogleFonts.robotoMono(color: AppColors.accent, fontSize: 11)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E0A12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            ),
            child: Text(
              'Q${_currentQ + 1}. ${q['q'] as String}',
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              children: options.asMap().entries.map((entry) {
                final i = entry.key;
                final isSelected = selectedAnswer == i;
                final isCorrect = i == correct;
                Color borderColor = AppColors.accent.withOpacity(0.3);
                Color bgColor = const Color(0xFF1E0A12);

                if (answered) {
                  if (isCorrect) { borderColor = Colors.green; bgColor = Colors.green.withOpacity(0.1); }
                  else if (isSelected) { borderColor = Colors.red; bgColor = Colors.red.withOpacity(0.1); }
                } else if (isSelected) {
                  borderColor = AppColors.accent;
                  bgColor = AppColors.accent.withOpacity(0.1);
                }

                return GestureDetector(
                  onTap: answered ? null : () => _selectAnswer(i),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: answered && isCorrect ? Colors.green : (answered && isSelected ? Colors.red : Colors.transparent),
                              border: Border.all(color: answered && isCorrect ? Colors.green : (answered && isSelected ? Colors.red : Colors.white38), width: 2),
                            ),
                            child: Center(child: Text(
                              answered && isCorrect ? '✓' : (answered && isSelected ? '✗' : String.fromCharCode(65 + i)),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.value, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4))),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final percentage = (_score / _questions.length * 100).round();
    final passed = percentage >= 80;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed ? Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
              border: Border.all(color: passed ? Colors.green : Colors.orange, width: 2),
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: GoogleFonts.orbitron(color: passed ? Colors.green : Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Post-Test Complete!', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$_score/${_questions.length} correct', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            passed ? '🎉 You passed! Certificate unlocked!' : 'Score 80%+ to earn your certificate.',
            style: TextStyle(color: passed ? Colors.green : Colors.orange, fontSize: 13, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          if (passed) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keys #6 & #7 Earned!', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold)),
                          const Text('Chests #6 & #7 unlocked!', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.purple, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Certificate Generated!', style: GoogleFonts.orbitron(color: Colors.purple, fontSize: 13, fontWeight: FontWeight.bold)),
                          const Text('Graduate badge earned!', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finishTest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('FINISH', style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
