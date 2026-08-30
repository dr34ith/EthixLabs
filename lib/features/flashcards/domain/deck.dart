class Deck {
  final int id;
  final String title;
  final String icon;
  final String categoryCode;
  final String difficulty;
  final int cardCount;
  final int estimatedMinutes;
  final int sortOrder;

  const Deck({
    required this.id,
    required this.title,
    required this.icon,
    required this.categoryCode,
    required this.difficulty,
    required this.cardCount,
    required this.estimatedMinutes,
    required this.sortOrder,
  });

  factory Deck.fromMap(Map<String, Object?> map) {
    return Deck(
      id: map['id'] as int,
      title: map['title'] as String,
      icon: map['icon'] as String,
      categoryCode: map['category_code'] as String,
      difficulty: map['difficulty'] as String,
      cardCount: map['card_count'] as int,
      estimatedMinutes: map['estimated_minutes'] as int,
      sortOrder: map['sort_order'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'category_code': categoryCode,
      'difficulty': difficulty,
      'card_count': cardCount,
      'estimated_minutes': estimatedMinutes,
      'sort_order': sortOrder,
    };
  }
}
