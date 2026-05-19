import 'package:flutter/material.dart';
import 'package:test_vuln/services/hive_service.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/main/main_layout.dart';

class Mission03Apply extends StatefulWidget {
  const Mission03Apply({Key? key}) : super(key: key);

  @override
  State<Mission03Apply> createState() => _Mission03ApplyState();
}

class _Mission03ApplyState extends State<Mission03Apply> {
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _flagShown = false;

  void _checkAnswer() {
    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == 'verify';
    });
  }

  void _showFlagDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white38, width: 2),
          ),
          title: const Column(
            children: [
              Icon(Icons.flag, color: Color(0xFFE68C8C), size: 50),
              SizedBox(height: 10),
              Text(
                'FLAG EARNED!',
                style: TextStyle(
                  color: Color(0xFFE68C8C),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: const Text(
                    'ETHIX{BAC_IDOR_ORDER}',
                    style: TextStyle(
                      color: Color(0xFFE68C8C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Congratulations! You have successfully completed Mission 03!',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                      (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE68C8C),
              ),
              child: const Text('Back to Dashboard'),
            ),
          ],
        );
      },
    );
  }

  void _completeMission() async {
    if (!_flagShown) {
      await HiveService.completeMission('bac_01', stars: 1);
      setState(() {
        _flagShown = true;
      });
      _showFlagDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 5 OF 5',
      stepTitle: 'Apply Your Knowledge',
      onNextPressed: null,
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
              'How should the server prevent IDOR on the order detail endpoint?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildAnswerOption('Hide the ID in a hidden form field', 'hide'),
            const SizedBox(height: 12),
            _buildAnswerOption(
              'Verify that the order\'s customer_id matches the logged-in user',
              'verify',
            ),
            const SizedBox(height: 12),
            _buildAnswerOption('Use longer, unpredictable IDs', 'longer'),
            const SizedBox(height: 12),
            _buildAnswerOption('Encrypt the ID in the URL', 'encrypt'),
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
                    'Submit Answer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_isAnswered && !_isCorrect)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Incorrect',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The correct answer is: Verify that the order\'s customer_id matches the logged-in user. This ensures proper ownership validation before returning sensitive data.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAnswered = false;
                            _selectedAnswer = null;
                            _isCorrect = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE68C8C),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Try Again'),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isAnswered && _isCorrect)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Correct!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '✅ Proper access control requires verifying that the requested resource belongs to the authenticated user. This is typically done by checking that order.customer_id matches session.user_id before returning data.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _completeMission,
                        icon: const Icon(Icons.flag),
                        label: const Text('Complete Mission & Claim Flag'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

  Widget _buildAnswerOption(String text, String value) {
    return GestureDetector(
      onTap: _isAnswered
          ? null
          : () {
        setState(() {
          _selectedAnswer = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedAnswer == value
              ? const Color(0xFFE68C8C).withOpacity(0.3)
              : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAnswer == value
                ? const Color(0xFFE68C8C)
                : const Color(0xFFE68C8C).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: _selectedAnswer,
              onChanged: _isAnswered
                  ? null
                  : (val) {
                setState(() {
                  _selectedAnswer = val as String?;
                });
              },
              activeColor: const Color(0xFFE68C8C),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _selectedAnswer == value ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}