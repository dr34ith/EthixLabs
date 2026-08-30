import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/profile/domain/user_level_service.dart';

void main() {
  group('UserLevelService.calculateLevel', () {
    final cases = <int, String>{
      0: 'Recruit',
      1: 'Cadet',
      4: 'Cadet',
      5: 'Apprentice',
      9: 'Apprentice',
      10: 'Operative',
      14: 'Operative',
      15: 'Analyst',
      19: 'Analyst',
      20: 'Cryptographer',
      22: 'Cryptographer',
      23: 'AI Hunter',
      24: 'Elite Hacker',
    };

    cases.forEach((missions, expectedTitle) {
      test('$missions completed missions -> $expectedTitle', () {
        final level = UserLevelService.calculateLevel(
          completedMissions: missions,
          postTestScore: null,
        );
        expect(level.title, expectedTitle);
      });
    });

    test('25 missions without a passing post-test caps at Ethical Master', () {
      final level = UserLevelService.calculateLevel(
        completedMissions: 25,
        postTestScore: null,
      );
      expect(level.title, 'Ethical Master');
      expect(level.level, 9);
    });

    test('25 missions with post-test below 80% caps at Ethical Master', () {
      final level = UserLevelService.calculateLevel(
        completedMissions: 25,
        postTestScore: 79.9,
      );
      expect(level.title, 'Ethical Master');
    });

    test('25 missions with post-test >= 80% unlocks EthixLabs Legend', () {
      final level = UserLevelService.calculateLevel(
        completedMissions: 25,
        postTestScore: 80.0,
      );
      expect(level.title, 'EthixLabs Legend');
      expect(level.level, 10);
    });

    test('more than 25 completed missions still resolves (defensive)', () {
      final level = UserLevelService.calculateLevel(
        completedMissions: 30,
        postTestScore: 100,
      );
      expect(level.level, 10);
    });
  });

  group('UserLevelService.progressToNextLevel', () {
    test('12 of 15 missions to Analyst reports an 80% ratio', () {
      final progress = UserLevelService.progressToNextLevel(
        completedMissions: 12,
        postTestScore: null,
      );
      expect(progress.currentLevel.title, 'Operative');
      expect(progress.nextLevel?.title, 'Analyst');
      expect(progress.completedMissions, 12);
      expect(progress.ratio, closeTo(0.8, 0.0001));
      expect(progress.isPostTestGate, false);
    });

    test('at 25 missions, progressing toward Legend is gated by post-test score', () {
      final progress = UserLevelService.progressToNextLevel(
        completedMissions: 25,
        postTestScore: 40.0,
      );
      expect(progress.currentLevel.title, 'Ethical Master');
      expect(progress.nextLevel?.title, 'EthixLabs Legend');
      expect(progress.isPostTestGate, true);
      expect(progress.ratio, closeTo(0.5, 0.0001)); // 40/80
    });

    test('at max level (Legend), there is no next level', () {
      final progress = UserLevelService.progressToNextLevel(
        completedMissions: 25,
        postTestScore: 90.0,
      );
      expect(progress.currentLevel.title, 'EthixLabs Legend');
      expect(progress.nextLevel, isNull);
      expect(progress.ratio, 1.0);
    });
  });
}
