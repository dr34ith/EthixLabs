import 'package:flutter/material.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

class LoginCard extends StatelessWidget {
  final Widget child;

  const LoginCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: CyberTheme.highIntensityGlowDecoration(
        backgroundColor: CyberTheme.surface,
        borderRadius: 24,
      ),
      child: child,
    );
  }
}

// Filled input decoration for login fields
class CyberInputDecoration extends InputDecoration {
  CyberInputDecoration({
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextEditingController? controller,
  }) : super(
          filled: true,
          fillColor: const Color(0xFF121214),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: CyberTheme.primaryAccent)
              : null,
          labelStyle: CyberTheme.captionStyle,
          hintStyle: CyberTheme.captionStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: CyberTheme.primaryAccent,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        );
}
