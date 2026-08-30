import 'flashcard.dart';
import 'review_status.dart';

/// Pure Leitner-box spaced-repetition logic, kept free of any I/O so it can
/// be unit tested in isolation from the SQLite repository.
///
/// Box range is 1..5. Rating rules:
/// - Hard  -> reset to box 1, next review in 1 day.
/// - Okay  -> stay in the current box, next review in 3 days.
/// - Easy  -> move up one box (capped at 5), next review interval scales
///            with the new box (1/3/7/14/30 days for boxes 1..5).
class LeitnerAlgorithm {
  const LeitnerAlgorithm._();

  static const int minBox = 1;
  static const int maxBox = 5;

  static const Map<int, int> _easyIntervalDays = {
    1: 1,
    2: 3,
    3: 7,
    4: 14,
    5: 30,
  };

  static FlashcardProgress applyRating(
    FlashcardProgress progress,
    ReviewStatus rating, {
    required DateTime now,
  }) {
    assert(
      rating == ReviewStatus.hard ||
          rating == ReviewStatus.okay ||
          rating == ReviewStatus.easy,
      'applyRating requires a Hard/Okay/Easy rating',
    );

    int newBox;
    Duration interval;
    switch (rating) {
      case ReviewStatus.hard:
        newBox = minBox;
        interval = const Duration(days: 1);
        break;
      case ReviewStatus.okay:
        newBox = progress.leitnerBox;
        interval = const Duration(days: 3);
        break;
      case ReviewStatus.easy:
        newBox = (progress.leitnerBox + 1).clamp(minBox, maxBox).toInt();
        interval = Duration(days: _easyIntervalDays[newBox]!);
        break;
      case ReviewStatus.unseen:
        newBox = progress.leitnerBox;
        interval = const Duration(days: 1);
        break;
    }

    return progress.copyWith(
      leitnerBox: newBox,
      lastReviewedAt: now,
      nextReviewAt: now.add(interval),
      timesSeen: progress.timesSeen + 1,
    );
  }
}
