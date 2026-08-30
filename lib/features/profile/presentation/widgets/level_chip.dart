import 'package:flutter/material.dart';

import '../../domain/user_level.dart';
import 'level_badge.dart' show kLevelCrimson;

/// Small "[icon] Lv N" chip shown beside the username on Home/Missions.
class LevelChip extends StatelessWidget {
  final UserLevel level;

  const LevelChip({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kLevelCrimson.withOpacity(0.2),
        border: Border.all(color: kLevelCrimson),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(level.icon, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          Text(
            'Lv ${level.level}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
