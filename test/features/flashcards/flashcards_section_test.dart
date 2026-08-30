import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/features/flashcards/presentation/controllers/flashcard_controller.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/deck_card.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/flashcards_section.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    initTestDatabaseFactory();
  });

  testWidgets('renders all 5 deck cards when filter is All', (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<FlashcardController>.value(
        value: controller,
        child: const MaterialApp(
          home: Scaffold(body: FlashcardsSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.selectedFilter, kAllDecksFilter);
    expect(find.byType(DeckCard), findsNWidgets(5));
  });

  testWidgets('selecting a filter chip narrows the deck row', (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<FlashcardController>.value(
        value: controller,
        child: const MaterialApp(
          home: Scaffold(body: FlashcardsSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('LLM01'));
    await tester.pumpAndSettle();

    expect(find.byType(DeckCard), findsOneWidget);
  });
}
