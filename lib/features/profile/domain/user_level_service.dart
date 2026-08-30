import '../data/user_level_data.dart';
import 'user_level.dart';

/// How close the user is to their next level, for the progress bar.
class LevelProgress {
  final UserLevel currentLevel;
  final UserLevel? nextLevel; // null once at max level (10)
  final double ratio; // 0..1
  final int completedMissions;
  /// True when [nextLevel] is Level 10 (Legend), which is gated by the
  /// post-test score rather than mission count.
  final bool isPostTestGate;

  const LevelProgress({
    required this.currentLevel,
    required this.nextLevel,
    required this.ratio,
    required this.completedMissions,
    this.isPostTestGate = false,
  });
}

/// Rules:
/// - Levels 1-9 unlock purely by completed mission count (see
///   user_level_data.dart for the thresholds).
/// - Level 10 ("EthixLabs Legend") additionally requires the post-test
///   score to be >= 80%, even though its mission threshold (25) is the
///   same as Level 9 ("Ethical Master") — so completing all 25 missions
///   alone caps the user at Level 9 until they also pass the post-test.
class UserLevelService {
  const UserLevelService._();

  static UserLevel calculateLevel({
    required int completedMissions,
    required double? postTestScore,
  }) {
    if (completedMissions >= 25 &&
        postTestScore != null &&
        postTestScore >= 80.0) {
      return userLevels[9]; // Legend
    }
    for (final level in userLevels.reversed) {
      if (level.level == 10) continue;
      if (completedMissions >= level.minMissions) return level;
    }
    return userLevels[0]; // Recruit
  }

  static LevelProgress progressToNextLevel({
    required int completedMissions,
    required double? postTestScore,
  }) {
    final current = calculateLevel(
      completedMissions: completedMissions,
      postTestScore: postTestScore,
    );

    if (current.level == 10) {
      return LevelProgress(
        currentLevel: current,
        nextLevel: null,
        ratio: 1.0,
        completedMissions: completedMissions,
      );
    }

    final nextIndex = userLevels.indexWhere((l) => l.level == current.level + 1);
    if (nextIndex == -1) {
      return LevelProgress(
        currentLevel: current,
        nextLevel: null,
        ratio: 1.0,
        completedMissions: completedMissions,
      );
    }
    final next = userLevels[nextIndex];

    if (next.level == 10) {
      final score = postTestScore ?? 0.0;
      final ratio = (score / 80.0).clamp(0.0, 1.0);
      return LevelProgress(
        currentLevel: current,
        nextLevel: next,
        ratio: ratio,
        completedMissions: completedMissions,
        isPostTestGate: true,
      );
    }

    final ratio = next.minMissions == 0
        ? 1.0
        : (completedMissions / next.minMissions).clamp(0.0, 1.0);
    return LevelProgress(
      currentLevel: current,
      nextLevel: next,
      ratio: ratio,
      completedMissions: completedMissions,
    );
  }
}
