import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ambient_background_glow.dart';
import '../../domain/user_level.dart';
import 'level_badge.dart';

/// Tracks the highest level a level-up modal has already been shown for,
/// so a transition only celebrates once even across app restarts.
class LevelUpTracker {
  const LevelUpTracker._();

  static const _prefsKey = 'level_up_last_shown';

  static Future<bool> shouldShow(int newLevel) async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(_prefsKey) ?? 1;
    return newLevel > lastShown;
  }

  static Future<void> markShown(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt(_prefsKey) ?? 1;
    if (level > lastShown) {
      await prefs.setInt(_prefsKey, level);
    }
  }
}

/// Full-screen "LEVEL UP!" celebration, shown from the mission-completion
/// flow (never on Profile screen load) when a mission completion pushes
/// the user into a new level.
class LevelUpModal extends StatefulWidget {
  final UserLevel newLevel;

  const LevelUpModal({Key? key, required this.newLevel}) : super(key: key);

  static Future<void> show(BuildContext context, UserLevel newLevel) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) => LevelUpModal(newLevel: newLevel),
    );
  }

  @override
  State<LevelUpModal> createState() => _LevelUpModalState();
}

class _LevelUpModalState extends State<LevelUpModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burstCtrl;

  @override
  void initState() {
    super.initState();
    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _burstCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: AmbientBackgroundGlow(
      glowColor: AppColors.crimsonGlow,
      glowAlignment: Alignment.center,
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _burstCtrl,
              builder: (context, _) => _StarBurst(progress: _burstCtrl.value),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'LEVEL UP!',
                    style: TextStyle(
                      color: kLevelGold,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LevelBadge(level: widget.newLevel),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLevelCrimson,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// Lightweight radiating-star effect — avoids pulling in a confetti
/// package for a one-off animation.
class _StarBurst extends StatelessWidget {
  final double progress;
  static const int _starCount = 12;

  const _StarBurst({required this.progress});

  @override
  Widget build(BuildContext context) {
    final opacity = (1 - progress).clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.center,
      children: List.generate(_starCount, (i) {
        final angle = (2 * math.pi / _starCount) * i;
        final distance = 160 * progress;
        final dx = math.cos(angle) * distance;
        final dy = math.sin(angle) * distance;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(
            opacity: opacity,
            child: Icon(Icons.star, color: kLevelGold, size: 18 + (i % 3) * 4),
          ),
        );
      }),
    );
  }
}
