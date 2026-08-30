import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/theme.dart';

class PretestScreen extends StatefulWidget {
  const PretestScreen({Key? key}) : super(key: key);

  @override
  State<PretestScreen> createState() => _PretestScreenState();
}

class _PretestScreenState extends State<PretestScreen> {
  int _currentQ = 0;
  int _score = 0;
  final Map<int, int> _answers = {};
  bool _submitted = false;

  static const _questions = [
    {
      'q': 'What does SQL Injection allow an attacker to do?',
      'options': [
        'Execute JavaScript in the victim\'s browser',
        'Manipulate database queries to bypass authentication or extract data',
        'Intercept network traffic between client and server',
        'Access files on the web server directly',
      ],
      'correct': 1,
    },
    {
      'q': 'Which OWASP 2025 category covers unauthorized access to other users\' resources?',
      'options': ['A02 — Security Misconfiguration', 'A04 — Cryptographic Failures', 'A01 — Broken Access Control', 'A07 — Authentication Failures'],
      'correct': 2,
    },
    {
      'q': 'What is IDOR?',
      'options': [
        'Injecting malicious SQL into a query',
        'Accessing objects by manipulating predictable references like IDs',
        'Intercepting data transmitted over HTTP',
        'Exploiting weak password hashing algorithms',
      ],
      'correct': 1,
    },
    {
      'q': 'Which is the most secure password storage method?',
      'options': ['MD5 with a salt', 'SHA-256 without salt', 'bcrypt or Argon2id with a unique salt', 'AES-256 encryption'],
      'correct': 2,
    },
    {
      'q': 'Stored XSS differs from Reflected XSS because:',
      'options': [
        'Stored XSS only affects the attacker',
        'Stored XSS is saved in the database and affects all page visitors',
        'Reflected XSS requires database access',
        'Stored XSS only works over HTTPS',
      ],
      'correct': 1,
    },
    {
      'q': 'What is the primary risk of verbose error messages?',
      'options': [
        'They crash the application',
        'They reveal internal architecture, file paths, and database details to attackers',
        'They slow down the web server',
        'They expose user passwords',
      ],
      'correct': 1,
    },
    {
      'q': 'Which HTTP method is most commonly used for form submission that modifies server data?',
      'options': ['GET', 'HEAD', 'POST', 'OPTIONS'],
      'correct': 2,
    },
    {
      'q': 'What does HTTPS protect against?',
      'options': [
        'SQL injection attacks',
        'Cross-site scripting',
        'Interception and modification of data in transit',
        'Brute force password attacks',
      ],
      'correct': 2,
    },
    {
      'q': 'A tautology SQL injection payload like \' OR \'1\'=\'1 works because:',
      'options': [
        'It deletes the users table',
        'It makes the SQL WHERE clause always evaluate to true',
        'It extracts data using UNION SELECT',
        'It causes a database error revealing the schema',
      ],
      'correct': 1,
    },
    {
      'q': 'Under Philippine law (RA 10175), unauthorized access to a computer system is:',
      'options': [
        'Legal if you report the vulnerability afterwards',
        'Only illegal if data is actually stolen',
        'A criminal offense even without malicious intent',
        'Legal for security researchers',
      ],
      'correct': 2,
    },
  ];

  void _selectAnswer(int optionIndex) {
    if (_answers.containsKey(_currentQ)) return;
    setState(() {
      _answers[_currentQ] = optionIndex;
      final correct = _questions[_currentQ]['correct'] as int;
      if (optionIndex == correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (_currentQ < _questions.length - 1) {
        setState(() => _currentQ++);
      } else {
        setState(() => _submitted = true);
      }
    });
  }

  void _finishTest() {
    final percentage = (_score / _questions.length * 100).round();
    context.read<AppProvider>().completePretestWith(percentage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Pre-Test Assessment', style: GoogleFonts.orbitron(fontSize: 14)),
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: Colors.white,
        leading: _submitted ? null : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: !_submitted,
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
          // Progress
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
              Text('${_currentQ + 1}/${_questions.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),

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
          const SizedBox(height: 20),

          ...options.asMap().entries.map((entry) {
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
          }),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final percentage = (_score / _questions.length * 100).round();
    final passed = percentage >= 60;

    return Padding(
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
          Text('Pre-Test Complete!', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$_score/${_questions.length} correct answers', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.vpn_key, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Key #5 Earned!', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold)),
                      const Text('Pre-test completed — Chest 5 unlocked!', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              child: Text('START MISSIONS', style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
