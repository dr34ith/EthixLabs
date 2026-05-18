import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/missions/mission_04/mission_04_identify.dart';

class Mission04Test extends StatefulWidget {
  const Mission04Test({Key? key}) : super(key: key);

  @override
  State<Mission04Test> createState() => _Mission04TestState();
}

class _Mission04TestState extends State<Mission04Test> {
  bool _hasClickedLink = false;
  bool _hasEnteredCredentials = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _resultMessage = '';

  void _clickLink() {
    setState(() {
      _hasClickedLink = true;
      _resultMessage = '';
    });
  }

  void _submitCredentials() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _hasEnteredCredentials = true;
        _resultMessage = '⚠️ CREDENTIALS STOLEN!\n\n'
            'Username: $username\n'
            'Password: $password\n\n'
            'The attacker now has your real VulnShop credentials!\n\n'
            'This is a phishing attack. The fake login page captured your '
            'information and can now access your actual VulnShop account, '
            'make purchases, or steal your payment information.';
      });
    } else {
      setState(() {
        _resultMessage = 'Please enter both username and password.';
      });
    }
  }

  void _reset() {
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _hasClickedLink = false;
      _hasEnteredCredentials = false;
      _resultMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 2 OF 5',
      stepTitle: 'Test the Vulnerability',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission04Identify()),
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
            if (!_hasClickedLink)
              Column(
                children: [
                  // Email header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Red warning banner
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This email was not sent from VulnShop\'s real domain. Be cautious!',
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email from
                        const Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.white54, size: 20),
                            SizedBox(width: 12),
                            Text(
                              'From:',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'security@vulnshop-support.com',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Email to
                        const Row(
                          children: [
                            Icon(Icons.arrow_forward, color: Colors.white54, size: 20),
                            SizedBox(width: 12),
                            Text(
                              'To:',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'your_email@example.com',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Email subject (red, urgent)
                        const Row(
                          children: [
                            Icon(Icons.mark_email_read, color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Text(
                              'Subject:',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'URGENT: Your account will be suspended in 24 hours',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Divider(color: Colors.grey),
                        const SizedBox(height: 16),

                        // Email body
                        const Text(
                          'Dear Customer,',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'We detected suspicious activity on your account. '
                              'To avoid permanent suspension, please verify your identity immediately.',
                          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 20),

                        // Phishing link button
                        Center(
                          child: GestureDetector(
                            onTap: _clickLink,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE68C8C),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE68C8C).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.link, color: Colors.black, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Verify Your Account Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Hover warning
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.red, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '⚠️ Actual link destination: http://vulnshop-verify.xyz (not vulnshop.com)',
                                  style: TextStyle(color: Colors.red, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Red flags list
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🔍 Red Flags:',
                                style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text('• Suspicious sender domain: vulnshop-support.com', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              Text('• Urgent/scare tactic language', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              Text('• Link domain mismatch', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              Text('• No HTTPS on the link', style: TextStyle(color: Colors.white54, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            if (_hasClickedLink && !_hasEnteredCredentials)
              Column(
                children: [
                  // Browser/URL bar simulation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // Browser toolbar
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.lock_open, color: Colors.red, size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              'Not Secure',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // URL bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.dangerous, color: Colors.red, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'http://vulnshop-verify.xyz/verify',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fake login page
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white38.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // Fake logo/branding
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE68C8C).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Color(0xFFE68C8C),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'VulnShop',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE68C8C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Account Verification Required',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Warning about fake site
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'This is NOT the real VulnShop website!',
                                  style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login form
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'VulnShop Username / Email',
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
                            onPressed: _submitCredentials,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE68C8C),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'VERIFY IDENTITY',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            if (_resultMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _hasEnteredCredentials
                      ? Colors.red.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hasEnteredCredentials ? Colors.red : Colors.orange,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _resultMessage,
                      style: TextStyle(
                        color: _hasEnteredCredentials ? Colors.red : Colors.orange,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    if (_hasEnteredCredentials) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Start Over'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE68C8C),
                            side: const BorderSide(color: Color(0xFFE68C8C)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            if (!_hasClickedLink && _resultMessage.isEmpty)
              const SizedBox(height: 16),
            if (!_hasClickedLink && _resultMessage.isEmpty)
              const Text(
                'Click the "Verify Your Account Now" link in the email to continue...',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}