// lib/auth/auth_layout.dart
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ========== BACKGROUND PHOTO ==========
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1_noLogo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // ========== CONTENT ==========
          SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main content (Login or Signup form)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: child,
                      ),
                    ),
                  ),

                  // ========== FOOTER (Logo & Year) ==========
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/EthixLabs_LOGO.png',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '@2026',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}