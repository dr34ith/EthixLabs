import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:test_vuln/widgets/success_screen.dart';

/// Backward-compatible wrapper that delegates to the unified SuccessScreen.
/// Prefer using [SuccessScreen] directly for new code.
class MissionCompleteModal extends StatelessWidget {
  final String flag;
  final int xpReward;
  final String nextMission;
  final double accuracy;
  final int attempts;
  final int hintsUsed;
  final VoidCallback? onContinue;
  final VoidCallback? onReturnToDashboard;

  const MissionCompleteModal({
    Key? key,
    required this.flag,
    this.xpReward = 150,
    this.nextMission = 'Mission 02',
    this.accuracy = 1.0,
    this.attempts = 1,
    this.hintsUsed = 0,
    this.onContinue,
    this.onReturnToDashboard,
  }) : super(key: key);

  int _calculateStarRating() {
    double score = accuracy;
    score -= (attempts - 1) * 0.1;
    score -= hintsUsed * 0.15;
    int stars = (score * 3).round();
    return stars.clamp(1, 3);
  }

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      title: 'MISSION COMPLETE!',
      subtitle: 'Congratulations, Ethical Hacker!',
      resultLabel: 'FLAG CAPTURED',
      resultValue: flag,
      xpReward: xpReward,
      nextItemLabel: '$nextMission Unlocked',
      starRating: _calculateStarRating(),
      metadata:
          'Accuracy: ${(accuracy * 100).toInt()}% | Attempts: $attempts | Hints: $hintsUsed',
      primaryLabel: 'Continue to Next Mission',
      secondaryLabel: 'Return to Dashboard',
      onPrimary: onContinue,
      onSecondary: onReturnToDashboard,
      icon: Icons.flag_rounded,
    );
  }
}

// Static show method outside the class
void showMissionCompleteModal({
  required BuildContext context,
  required String flag,
  int xpReward = 150,
  String nextMission = 'Mission 02',
  double accuracy = 1.0,
  int attempts = 1,
  int hintsUsed = 0,
  VoidCallback? onContinue,
  VoidCallback? onReturnToDashboard,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) => BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: MissionCompleteModal(
        flag: flag,
        xpReward: xpReward,
        nextMission: nextMission,
        accuracy: accuracy,
        attempts: attempts,
        hintsUsed: hintsUsed,
        onContinue: onContinue,
        onReturnToDashboard: onReturnToDashboard,
      ),
    ),
  );
}
