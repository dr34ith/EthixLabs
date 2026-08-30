import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/features/flashcards/presentation/controllers/flashcard_controller.dart';
import 'package:ethixlabs/features/flashcards/presentation/screens/deck_detail_screen.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/flip_card.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    initTestDatabaseFactory();
  });

  testWidgets('swiping left on the card advances to the next card',
      (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<FlashcardController>.value(
        value: controller,
        child: const MaterialApp(
          home: DeckDetailScreen(deckId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Card 1 of'), findsOneWidget);

    await tester.fling(find.byType(FlipCard), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.textContaining('Card 2 of'), findsOneWidget);
  });
}
