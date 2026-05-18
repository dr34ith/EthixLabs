import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/missions/mission_01/mission_01_analyze.dart';

class Mission01Identify extends StatefulWidget {
  const Mission01Identify({Key? key}) : super(key: key);

  @override
  State<Mission01Identify> createState() => _Mission01IdentifyState();
}

class _Mission01IdentifyState extends State<Mission01Identify> {
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;

  void _checkAnswer() {
    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == 'B';
    });
  }

  void _resetQuiz() {
    setState(() {
      _selectedAnswer = null;
      _isAnswered = false;
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 3 OF 5',
      stepTitle: 'Identify the Vulnerability',
      onNextPressed: _isCorrect
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission01Analyze()),
        );
      }
          : null,
      nextButtonText: _isCorrect ? 'Next: Analyze' : 'Answer Correctly First',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE68C8C).withOpacity(0.15),
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE68C8C).withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What type of vulnerability did you just exploit?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuizOption('A', 'Cross‐Site Scripting (XSS)'),
            const SizedBox(height: 12),
            _buildQuizOption('B', 'SQL Injection (Login Bypass)'),
            const SizedBox(height: 12),
            _buildQuizOption('C', 'Insecure Direct Object Reference (IDOR)'),
            const SizedBox(height: 12),
            _buildQuizOption('D', 'Path Traversal'),
            const SizedBox(height: 24),
            if (!_isAnswered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedAnswer != null ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE68C8C),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT ANSWER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_isAnswered)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE68C8C),
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (_isAnswered) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isCorrect ? 'Correct!' : 'Incorrect',
                          style: TextStyle(
                            color: _isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isCorrect
                          ? '✅ SQL Injection (Login Bypass) is correct! The payload manipulated the SQL query structure, making the WHERE condition always true.'
                          : '❌ The correct answer is B) SQL Injection (Login Bypass). The payload manipulated the SQL query structure, making the WHERE condition always true. This bypassed authentication.',
                      style: const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuizOption(String letter, String text) {
    return GestureDetector(
      onTap: _isAnswered
          ? null
          : () {
        setState(() {
          _selectedAnswer = letter;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedAnswer == letter
              ? const Color(0xFFE68C8C).withOpacity(0.3)
              : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAnswer == letter
                ? const Color(0xFFE68C8C)
                : const Color(0xFFE68C8C).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedAnswer == letter
                    ? const Color(0xFFE68C8C)
                    : Colors.transparent,
                border: Border.all(
                  color: const Color(0xFFE68C8C),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: _selectedAnswer == letter ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}