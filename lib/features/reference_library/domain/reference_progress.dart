/// Per-card read/bookmark state, persisted in the `reference_progress`
/// SQLite table (card_id is a String id like 'ethical_hacking', not an
/// integer row id).
class ReferenceProgress {
  final String cardId;
  final bool isRead;
  final bool isBookmarked;
  final DateTime? lastOpenedAt;

  const ReferenceProgress({
    required this.cardId,
    this.isRead = false,
    this.isBookmarked = false,
    this.lastOpenedAt,
  });

  ReferenceProgress copyWith({
    bool? isRead,
    bool? isBookmarked,
    DateTime? lastOpenedAt,
  }) {
    return ReferenceProgress(
      cardId: cardId,
      isRead: isRead ?? this.isRead,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  factory ReferenceProgress.fromMap(Map<String, Object?> map) {
    return ReferenceProgress(
      cardId: map['card_id'] as String,
      isRead: (map['is_read'] as int? ?? 0) == 1,
      isBookmarked: (map['is_bookmarked'] as int? ?? 0) == 1,
      lastOpenedAt: map['last_opened_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_opened_at'] as int)
          : null,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'card_id': cardId,
      'is_read': isRead ? 1 : 0,
      'is_bookmarked': isBookmarked ? 1 : 0,
      'last_opened_at': lastOpenedAt?.millisecondsSinceEpoch,
    };
  }

  factory ReferenceProgress.initial(String cardId) =>
      ReferenceProgress(cardId: cardId);
}
