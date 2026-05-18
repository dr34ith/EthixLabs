import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question_model.dart';
import 'diagnostic_results_screen.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({Key? key}) : super(key: key);

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedOptionIndex;
  bool hasAnswered = false;
  bool showIntroModal = true;

  final List<Question> questions = [
    // Q1 (1pt): Ethical Hacking definition (Correct: B)
    Question(
      question: 'What is the primary goal of ethical hacking?',
      options: [
        'A. To cause damage to systems',
        'B. To identify and fix security vulnerabilities',
        'C. To steal sensitive data',
        'D. To spread malware',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q2 (1pt): Plain text password principle (Correct: B)
    Question(
      question: 'Why is storing passwords in plain text a security risk?',
      options: [
        'A. It takes up too much storage space',
        'B. If the database is compromised, passwords are immediately readable',
        'C. It slows down login processes',
        'D. It is difficult to implement',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q3 (1pt): White/Gray/Black Hat types (Correct: B)
    Question(
      question: 'Which type of hacker operates with permission to test systems?',
      options: [
        'A. Black Hat',
        'B. White Hat',
        'C. Gray Hat',
        'D. Script Kiddie',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q4 (1pt): SQLi login bypass input (Correct: B)
    Question(
      question: 'Which SQL injection payload is commonly used to bypass login authentication?',
      options: [
        'A. \' OR \'1\'=\'2\'',
        'B. \' OR \'1\'=\'1\'',
        'C. \' AND \'1\'=\'1\'',
        'D. \' UNION SELECT NULL',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q5 (1pt): Most effective SQLi prevention (Correct: C)
    Question(
      question: 'What is the most effective method to prevent SQL injection attacks?',
      options: [
        'A. Using input validation only',
        'B. Encrypting the database',
        'C. Using parameterized queries/prepared statements',
        'D. Using a web application firewall',
      ],
      correctAnswerIndex: 2, // C
      points: 1,
    ),
    // Q6 (1pt): IDOR identification scenario (Correct: C)
    Question(
      question: 'In which scenario is Insecure Direct Object Reference (IDOR) most likely to occur?',
      options: [
        'A. When using HTTPS',
        'B. When implementing rate limiting',
        'C. When accessing user data using sequential IDs without proper authorization checks',
        'D. When using session tokens',
      ],
      correctAnswerIndex: 2, // C
      points: 1,
    ),
    // Q7 (1pt): Auth vs. Auth difference (Correct: B)
    Question(
      question: 'What is the difference between Authentication and Authorization?',
      options: [
        'A. They are the same thing',
        'B. Authentication verifies identity, Authorization determines access rights',
        'C. Authorization verifies identity, Authentication determines access rights',
        'D. Neither is related to security',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q8 (1pt): #1 OWASP 2021 ranking (Correct: C)
    Question(
      question: 'Which vulnerability ranked #1 in the OWASP Top 10 2021?',
      options: [
        'A. Cross-Site Scripting (XSS)',
        'B. Security Misconfiguration',
        'C. Broken Access Control',
        'D. Injection',
      ],
      correctAnswerIndex: 2, // C
      points: 1,
    ),
    // Q9 (1pt): Unauthorized admin access type (Correct: B)
    Question(
      question: 'What type of attack allows an attacker to gain unauthorized access to admin functionality?',
      options: [
        'A. Cross-Site Request Forgery (CSRF)',
        'B. Broken Access Control / Privilege Escalation',
        'C. Distributed Denial of Service (DDoS)',
        'D. Man-in-the-Middle (MitM)',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
    // Q10 (1pt): Union-based SQLi identification (Correct: B)
    Question(
      question: 'Which SQL injection technique uses the UNION operator to combine results from multiple queries?',
      options: [
        'A. Error-based SQLi',
        'B. Union-based SQLi',
        'C. Blind SQLi',
        'D. Time-based SQLi',
      ],
      correctAnswerIndex: 1, // B
      points: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            _showExitConfirmationDialog();
          },
        ),
      ),
      body: Stack(
        children: [
          // Question content (always rendered)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    'Pre-Test: Web Application Security Knowledge Assessment',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Progress Bar
                  _buildProgressBar(),
                  const SizedBox(height: 32),

                  // Question Container
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE68C8C).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Question
                        Text(
                          'Question ${currentQuestionIndex + 1} of ${questions.length}',
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            color: const Color(0xFFE68C8C),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          currentQuestion.question,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Options
                        ...List.generate(currentQuestion.options.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildOption(
                              option: currentQuestion.options[index],
                              index: index,
                              isSelected: selectedOptionIndex == index,
                              isCorrect: hasAnswered && index == currentQuestion.correctAnswerIndex,
                              isWrong: hasAnswered && selectedOptionIndex == index && index != currentQuestion.correctAnswerIndex,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Next Button
                  if (hasAnswered)
                    SizedBox(
                      width: 300,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentQuestionIndex < questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                              selectedOptionIndex = null;
                              hasAnswered = false;
                            });
                          } else {
                            _navigateToResults();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE68C8C),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex < questions.length - 1
                              ? 'Next Question'
                              : 'View Results',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Intro modal (conditionally rendered on top)
          if (showIntroModal)
            _buildIntroModal(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currentQuestionIndex + 1}/${questions.length}',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              '${(questions[currentQuestionIndex].points)} pts',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color(0xFFE68C8C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE68C8C)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required String option,
    required int index,
    required bool isSelected,
    required bool isCorrect,
    required bool isWrong,
  }) {
    Color backgroundColor = Colors.grey[900]!;
    Color borderColor = Colors.grey[700]!;
    Color textColor = Colors.white;

    if (hasAnswered) {
      if (isCorrect) {
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.2);
        borderColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
      } else if (isWrong) {
        backgroundColor = const Color(0xFFF44336).withOpacity(0.2);
        borderColor = const Color(0xFFF44336);
        textColor = const Color(0xFFF44336);
      } else {
        backgroundColor = Colors.grey[900]!;
        borderColor = Colors.grey[700]!;
        textColor = Colors.white54;
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFFE68C8C).withOpacity(0.2);
      borderColor = Colors.white38;
      textColor = const Color(0xFFE68C8C);
    }

    return GestureDetector(
      onTap: hasAnswered
          ? null
          : () {
              setState(() {
                selectedOptionIndex = index;
                hasAnswered = true;
                if (index == questions[currentQuestionIndex].correctAnswerIndex) {
                  userScore += questions[currentQuestionIndex].points;
                }
              });
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor.withOpacity(0.2),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroModal() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE68C8C),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 64,
                color: const Color(0xFFE68C8C),
              ),
              const SizedBox(height: 24),
              Text(
                'Pre-Test Instructions',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This assessment consists of 10 questions covering web application security concepts.',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Important: Your results do NOT affect your access to missions. This test is designed to track your learning progress.',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color(0xFFE68C8C),
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Total possible score: 10 points',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showIntroModal = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE68C8C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Begin Assessment',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white38.withOpacity(0.5)),
        ),
        title: Text(
          'Exit Pre-Test?',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your progress will be lost. Are you sure you want to exit?',
          style: GoogleFonts.roboto(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE68C8C),
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Exit',
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosticResultsScreen(
          score: userScore,
          totalPoints: 10,
        ),
      ),
    );
  }
}
