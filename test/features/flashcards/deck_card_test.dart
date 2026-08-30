import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/flashcards/domain/deck.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/deck_card.dart';

void main() {
  testWidgets('DeckCard displays title, icon, difficulty and card count',
      (tester) async {
    const deck = Deck(
      id: 1,
      title: 'Broken Access Control',
      icon: '🔓',
      categoryCode: 'A01',
      difficulty: 'Medium',
      cardCount: 15,
      estimatedMinutes: 8,
      sortOrder: 1,
    );

    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeckCard(deck: deck, onTap: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Broken Access Control'), findsOneWidget);
    expect(find.text('🔓'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('15 cards'), findsOneWidget);
    expect(find.text('~8 min'), findsOneWidget);

    await tester.tap(find.byType(DeckCard));
    expect(tapped, true);
  });
}
