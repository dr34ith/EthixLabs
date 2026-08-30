import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/flashcards/data/flashcard_repository.dart';
import 'package:ethixlabs/features/flashcards/domain/streak_tracker.dart';

void main() {
  test('first ever review starts a streak of 1', () {
    const streak = FlashcardStreakData();
    final result =
        StreakTracker.recordReview(streak, today: DateTime(2026, 1, 1));

    expect(result.currentStreak, 1);
    expect(result.longestStreak, 1);
    expect(result.lastReviewDate, '2026-01-01');
  });

  test('reviewing again on the same day is a no-op', () {
    const streak = FlashcardStreakData(
      currentStreak: 3,
      longestStreak: 5,
      lastReviewDate: '2026-01-01',
    );
    final result =
        StreakTracker.recordReview(streak, today: DateTime(2026, 1, 1));

    expect(result.currentStreak, 3);
    expect(result.longestStreak, 5);
  });

  test('reviewing on the next consecutive day increments the streak', () {
    const streak = FlashcardStreakData(
      currentStreak: 3,
      longestStreak: 3,
      lastReviewDate: '2026-01-01',
    );
    final result =
        StreakTracker.recordReview(streak, today: DateTime(2026, 1, 2));

    expect(result.currentStreak, 4);
    expect(result.longestStreak, 4);
  });

  test('missing a day resets the current streak to 1 but keeps the longest',
      () {
    const streak = FlashcardStreakData(
      currentStreak: 6,
      longestStreak: 6,
      lastReviewDate: '2026-01-01',
    );
    final result =
        StreakTracker.recordReview(streak, today: DateTime(2026, 1, 5));

    expect(result.currentStreak, 1);
    expect(result.longestStreak, 6);
  });
}
