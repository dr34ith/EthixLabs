import 'package:flutter/material.dart';

import '../../domain/user_level.dart';
import '../../../../core/widgets/breathing_glow.dart';

const Color kLevelCrimson = Color(0xFF8B0000);
const Color kLevelNavy = Color(0xFF0A0A1A);
const Color kLevelGold = Color(0xFFB8860B);

/// Large centerpiece badge showing the user's current level.
class LevelBadge extends StatelessWidget {
  final UserLevel level;

  const LevelBadge({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BreathingGlow(
      color: kLevelCrimson,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kLevelCrimson, Color(0xFF5A0000)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 1,
              spreadRadius: -1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(level.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              'LEVEL ${level.level} · ${level.title.toUpperCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
