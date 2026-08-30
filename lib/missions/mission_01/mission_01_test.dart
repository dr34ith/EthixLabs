import 'package:ethixlabs/missions/mission_01/mission_01_identify.dart';
import 'package:ethixlabs/missions/step_layout.dart';
import 'package:flutter/material.dart';

class Mission01Test extends StatefulWidget {
  const Mission01Test({Key? key}) : super(key: key);

  @override
  State<Mission01Test> createState() => _Mission01TestState();
}

class _Mission01TestState extends State<Mission01Test> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _resultMessage = '';
  bool _isLoggedIn = false;

  void _testLogin() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.contains("' OR '1'='1") ||
        username.contains("' OR '1'='1' --")) {
      setState(() {
        _isLoggedIn = true;
        _resultMessage = '✅ LOGIN SUCCESSFUL!\n\n'
            'The payload \' OR \'1\'=\'1 worked! You bypassed the authentication.\n\n'
            'The SQL query became: SELECT * FROM users WHERE username = \'\' OR \'1\'=\'1\' AND password = \'\'';
      });
    } else if (username == 'admin' && password == 'password') {
      setState(() {
        _isLoggedIn = true;
        _resultMessage = '✅ Login successful with valid credentials.';
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _resultMessage = '❌ Login Failed.\n\n'
            'Try entering: \' OR \'1\'=\'1 in the username field and leave password blank.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 2 OF 5',
      stepTitle: 'Test the Vulnerability',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission01Identify()),
        );
      },
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
            const Center(
              child: Text(
                'VulnShop Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE68C8C),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Color(0xFFE68C8C)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE68C8C)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.lock, color: Color(0xFFE68C8C)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE68C8C)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE68C8C),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_resultMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isLoggedIn
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isLoggedIn ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  _resultMessage,
                  style: TextStyle(
                    color: _isLoggedIn ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}