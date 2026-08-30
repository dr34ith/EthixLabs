/// Daily-streak counters for the flashcards feature (single row, id = 1
/// in the `flashcard_streak` table).
class FlashcardStreakData {
  final int currentStreak;
  final int longestStreak;
  final String? lastReviewDate; // ISO date string (yyyy-MM-dd)

  const FlashcardStreakData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastReviewDate,
  });

  FlashcardStreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastReviewDate,
  }) {
    return FlashcardStreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    );
  }

  factory FlashcardStreakData.fromMap(Map<String, Object?> map) {
    return FlashcardStreakData(
      currentStreak: map['current_streak'] as int? ?? 0,
      longestStreak: map['longest_streak'] as int? ?? 0,
      lastReviewDate: map['last_review_date'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': 1,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_review_date': lastReviewDate,
    };
  }
}
