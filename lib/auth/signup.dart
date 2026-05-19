import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/auth/login.dart';
import 'package:test_vuln/info/info1.dart';
import 'package:test_vuln/services/hive_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _usernameCtrl  = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();
  bool _isAgreed = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose(); _lastNameCtrl.dispose();
    _usernameCtrl.dispose();  _passwordCtrl.dispose();
    _confirmCtrl.dispose();   super.dispose();
  }

  Future<void> _handleSignup() async {
    final first = _firstNameCtrl.text.trim();
    final last  = _lastNameCtrl.text.trim();
    if (first.isEmpty || last.isEmpty) { _snack('Enter your first and last name.'); return; }
    if (_usernameCtrl.text.trim().isEmpty) { _snack('Create a username.'); return; }
    if (_passwordCtrl.text.length < 8) { _snack('Password must be 8+ characters.'); return; }
    if (_passwordCtrl.text != _confirmCtrl.text) { _snack('Passwords do not match.'); return; }
    if (!_isAgreed) { _snack('Please agree to the Terms of Service.'); return; }

    // Save student name to Hive — used on the certificate of completion
    await HiveService.setUserName('$first $last');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Account created! Welcome to EthixLabs.'),
      backgroundColor: Colors.green,
    ));
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        automaticallyImplyLeading: false
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1_noLogo.jpg'), fit: BoxFit.cover)),
        child: Container(
          color: Colors.black.withOpacity(0.15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('WELCOME, FUTURE\nETHICAL HACKER',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: Colors.white, letterSpacing: 1.5,
                      shadows: const [Shadow(color: Color(0xFFFF8A8A), blurRadius: 15)])),
                  const SizedBox(height: 20),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF8A8A), width: 1),
                      boxShadow: [BoxShadow(color: const Color(0x4DFF8A8A), blurRadius: 12, spreadRadius: 1)]),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Create an Account', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 6),
                        const Text('Use your real name — it appears on your Certificate of Completion.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white60)),
                        const SizedBox(height: 16),
                        _field('First Name',        _firstNameCtrl),           const SizedBox(height: 12),
                        _field('Last Name',          _lastNameCtrl),            const SizedBox(height: 12),
                        _field('Create a Username',  _usernameCtrl),            const SizedBox(height: 12),
                        _field('Create a Password',  _passwordCtrl, obscure: true, hint: '8+ characters'),
                        const SizedBox(height: 12),
                        _field('Confirm Password',   _confirmCtrl,  obscure: true),
                        Row(children: [
                          Checkbox(value: _isAgreed,
                            onChanged: (v) => setState(() => _isAgreed = v ?? false),
                            activeColor: const Color(0xFFFF8A8A), checkColor: Colors.black),
                          const Expanded(child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: TextStyle(fontSize: 9, color: Colors.white70))),
                        ]),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A8A),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 8,
                            shadowColor: const Color(0xFFFF8A8A).withOpacity(0.5)),
                          child: Text('CONFIRM & PROCEED',
                            style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.0))),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text('Already have an account? ',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Log-in',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Image.asset('assets/icons/EthixLabs_LOGO.png', height: 100, width: 100),
                  const SizedBox(height: 8),
                  const Text('@2026', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {bool obscure = false, String? hint}) =>
    TextField(
      controller: ctrl, obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        helperText: hint, helperStyle: const TextStyle(color: Colors.white54, fontSize: 9.5),
        filled: true, fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white38)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white38)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFFFF26), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)));
}
