import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'mission_02_identify.dart';

class Mission02Test extends StatefulWidget {
  const Mission02Test({Key? key}) : super(key: key);

  @override
  State<Mission02Test> createState() => _Mission02TestState();
}

class _Mission02TestState extends State<Mission02Test> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _resultMessage = '';
  bool _isLoggedIn = false;

  void _testLogin() {
    String username = _usernameController.text;

    if (username.contains("'--") || username.contains("' --")) {
      setState(() {
        _isLoggedIn = true;
        _resultMessage = '✅ LOGIN SUCCESSFUL!\n\n'
            'The payload admin\'-- worked! The comment syntax (--) commented out the rest of the SQL query.\n\n'
            'The SQL query became: SELECT * FROM users WHERE username = \'admin\' -- AND password = \'\'\n\n'
            'Everything after -- is ignored by the database!';
      });
    } else if (username == 'admin' && _passwordController.text == 'password') {
      setState(() {
        _isLoggedIn = true;
        _resultMessage = '✅ Login successful with valid credentials.';
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _resultMessage = '❌ Login Failed.\n\n'
            'Try entering: admin\'-- in the username field and leave password blank.\n\n'
            'The -- sequence comments out the password check!';
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
          MaterialPageRoute(builder: (context) => const Mission02Identify()),
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
                  borderSide: const BorderSide(color: Colors.white38),
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
                  borderSide: const BorderSide(color: Colors.white38),
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