class Flashcard {
  final int id;
  final int deckId;
  final String front;
  final String back;
  final int? sourceMission;
  final int sortOrder;

  const Flashcard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.sourceMission,
    required this.sortOrder,
  });

  factory Flashcard.fromMap(Map<String, Object?> map) {
    return Flashcard(
      id: map['id'] as int,
      deckId: map['deck_id'] as int,
      front: map['front'] as String,
      back: map['back'] as String,
      sourceMission: map['source_mission'] as int?,
      sortOrder: map['sort_order'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'deck_id': deckId,
      'front': front,
      'back': back,
      'source_mission': sourceMission,
      'sort_order': sortOrder,
    };
  }
}

/// Per-card spaced-repetition state (Leitner box) and bookmark flag.
class FlashcardProgress {
  final int cardId;
  final int leitnerBox; // 1..5
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final int timesSeen;
  final bool isBookmarked;

  const FlashcardProgress({
    required this.cardId,
    this.leitnerBox = 1,
    this.lastReviewedAt,
    this.nextReviewAt,
    this.timesSeen = 0,
    this.isBookmarked = false,
  });

  FlashcardProgress copyWith({
    int? leitnerBox,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    int? timesSeen,
    bool? isBookmarked,
  }) {
    return FlashcardProgress(
      cardId: cardId,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      timesSeen: timesSeen ?? this.timesSeen,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  factory FlashcardProgress.fromMap(Map<String, Object?> map) {
    return FlashcardProgress(
      cardId: map['card_id'] as int,
      leitnerBox: map['leitner_box'] as int? ?? 1,
      lastReviewedAt: map['last_reviewed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_reviewed_at'] as int)
          : null,
      nextReviewAt: map['next_review_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['next_review_at'] as int)
          : null,
      timesSeen: map['times_seen'] as int? ?? 0,
      isBookmarked: (map['is_bookmarked'] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'card_id': cardId,
      'leitner_box': leitnerBox,
      'last_reviewed_at': lastReviewedAt?.millisecondsSinceEpoch,
      'next_review_at': nextReviewAt?.millisecondsSinceEpoch,
      'times_seen': timesSeen,
      'is_bookmarked': isBookmarked ? 1 : 0,
    };
  }

  factory FlashcardProgress.initial(int cardId) =>
      FlashcardProgress(cardId: cardId);
}

/// Composite used by the card viewer UI: the static card content plus its
/// live progress state.
class FlashcardWithProgress {
  final Flashcard card;
  final FlashcardProgress progress;

  const FlashcardWithProgress({required this.card, required this.progress});

  FlashcardWithProgress copyWith({FlashcardProgress? progress}) {
    return FlashcardWithProgress(
      card: card,
      progress: progress ?? this.progress,
    );
  }
}
