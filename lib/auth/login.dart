import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_vuln/auth/signup.dart';
import 'package:test_vuln/main/main_layout.dart';
import 'package:test_vuln/services/hive_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose(); _passwordCtrl.dispose(); super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameCtrl.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username.'), backgroundColor: Colors.redAccent));
      return;
    }
    // If no name saved yet, use the username as display name
    final stored = HiveService.getUserName();
    if (stored == null || stored == 'Ethical Hacker') {
      await HiveService.setUserName(username);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green));
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLayout()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                        const Text('Please enter your credentials',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        const Text('By proceeding, you agree to our Terms of Service and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.white70)),
                        const SizedBox(height: 20),
                        _field('Username', _usernameCtrl),
                        const SizedBox(height: 16),
                        _field('Password', _passwordCtrl, obscure: true),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A8A),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 8),
                          child: Text('LOG-IN',
                            style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.0))),
                        const SizedBox(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text("Don't have an account? ",
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Sign-up',
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

  Widget _field(String label, TextEditingController ctrl, {bool obscure = false}) =>
    TextField(
      controller: ctrl, obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: label, hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        filled: true, fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white38)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white38)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFFFFF26), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)));
}
