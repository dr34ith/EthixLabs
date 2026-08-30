import 'flashcard_streak.dart';

/// Pure daily-streak logic, kept free of any I/O so it can be unit tested
/// without a database.
///
/// Rule: rating at least one card on a calendar day counts as "reviewed
/// today". Reviewing on the day immediately after the last reviewed day
/// extends the streak; reviewing again on the same day is a no-op; any
/// larger gap resets the streak to 1 (today's review starts a new streak).
class StreakTracker {
  const StreakTracker._();

  static String dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  static FlashcardStreakData recordReview(
    FlashcardStreakData current, {
    required DateTime today,
  }) {
    final todayKey = dateKey(today);
    if (current.lastReviewDate == todayKey) {
      return current; // already counted today
    }

    final yesterdayKey = dateKey(today.subtract(const Duration(days: 1)));
    final isConsecutive = current.lastReviewDate == yesterdayKey;
    final newStreak = isConsecutive ? current.currentStreak + 1 : 1;

    return current.copyWith(
      currentStreak: newStreak,
      longestStreak:
          newStreak > current.longestStreak ? newStreak : current.longestStreak,
      lastReviewDate: todayKey,
    );
  }
}
