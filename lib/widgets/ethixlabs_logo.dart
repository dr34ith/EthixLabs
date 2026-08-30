import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ethixlabs/theme.dart';

class EthixLabsLogo extends StatelessWidget {
  final double width;
  const EthixLabsLogo({Key? key, this.width = 140}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/EthixLabs_LOGO.png',
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        'ETHIXLABS',
        style: GoogleFonts.orbitron(
          fontSize: 18,
          color: AppColors.accent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
