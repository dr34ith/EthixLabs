import 'package:flutter/material.dart';

import '../../domain/user_level_service.dart';
import 'level_badge.dart' show kLevelCrimson;

/// Progress toward the next level: label, animated fill bar, and a
/// "Next: [icon] [Title]" preview line.
class LevelProgressBar extends StatelessWidget {
  final LevelProgress progress;

  const LevelProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final next = progress.nextLevel;

    if (next == null) {
      return const Text(
        '🏆 Maximum level achieved',
        style: TextStyle(fontSize: 13, color: Color(0xFFB0B0C0)),
      );
    }

    final label = progress.isPostTestGate
        ? 'Pass the post-test with 80%+ to become a ${next.title}'
        : '${progress.completedMissions} of ${next.minMissions} missions to next level';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFFB0B0C0)),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.ratio),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: const Color(0xFF2A2A3E),
                valueColor: const AlwaysStoppedAnimation<Color>(kLevelCrimson),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Next: ${next.icon} ${next.title}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8E8E9E),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
