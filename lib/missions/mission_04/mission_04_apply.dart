import 'package:flutter/material.dart';
import 'package:test_vuln/missions/mission_04/mission_04.dart';
import 'package:test_vuln/missions/mission_05/mission_05.dart';
import 'package:test_vuln/services/hive_service.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/main/main_layout.dart';
import 'package:test_vuln/widgets/mission_complete_modal.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

class Mission04Apply extends StatefulWidget {
  const Mission04Apply({Key? key}) : super(key: key);

  @override
  State<Mission04Apply> createState() => _Mission04ApplyState();
}

class _Mission04ApplyState extends State<Mission04Apply> {
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _flagShown = false;

  void _checkAnswer() {
    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == 'check_url';
    });
  }

  void _showFlagDialog() {
    showMissionCompleteModal(
      context: context,
      flag: 'ETHIX{PHISH_URL_SPOOF}',
      xpReward: 150,
      nextMission: 'Mission 05',
      accuracy: 1.0,
      attempts: 1,
      hintsUsed: 0,
      onContinue: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Mission_05()), 
        );
      },
      onReturnToDashboard: () {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );
      },
    );
  }

  void _completeMission() async {
    if (!_flagShown) {
      await HiveService.completeMission('bac_phish_01', stars: 1);
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
      onNextPressed: null, // Mission ends via flag dialog
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CyberTheme.primaryAccent.withOpacity(0.15),
              CyberTheme.background.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CyberTheme.primaryAccent.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is the most reliable way to avoid falling for this phishing attack?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildAnswerOption('Never click any link in any email', 'never_click'),
            const SizedBox(height: 12),
            _buildAnswerOption(
              'Always check the URL in the address bar before entering credentials',
              'check_url',
            ),
            const SizedBox(height: 12),
            _buildAnswerOption('Use a password manager', 'password_manager'),
            const SizedBox(height: 12),
            _buildAnswerOption('Report the email to IT after clicking', 'report_after'),
            const SizedBox(height: 24),
            if (!_isAnswered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedAnswer != null ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CyberTheme.primaryAccent,
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
                      'The correct answer is: Always check the URL in the address bar before entering credentials. This is the most reliable way because you can verify you\'re on the legitimate website before submitting sensitive information.',
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
                          backgroundColor: CyberTheme.primaryAccent,
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
                      '✅ Always verify the URL in the address bar before entering credentials. Look for HTTPS, correct domain spelling, and be suspicious of unusual domains or misspellings. When in doubt, type the URL manually or use a saved bookmark.',
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
              ? CyberTheme.primaryAccent.withOpacity(0.3)
              : CyberTheme.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAnswer == value
                ? CyberTheme.primaryAccent
                : CyberTheme.primaryAccent.withOpacity(0.3),
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
              activeColor: CyberTheme.primaryAccent,
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