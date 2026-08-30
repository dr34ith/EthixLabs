import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/flashcards/presentation/widgets/flip_card.dart';

void main() {
  testWidgets('tapping the FlipCard toggles between front and back content',
      (tester) async {
    bool flipped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: FlipCard(
                isFlipped: flipped,
                front: const Text('FRONT CONTENT'),
                back: const Text('BACK CONTENT'),
                onTap: () => setState(() => flipped = !flipped),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('FRONT CONTENT'), findsOneWidget);
    expect(find.text('BACK CONTENT'), findsNothing);

    await tester.tap(find.byType(FlipCard));
    await tester.pumpAndSettle();

    expect(find.text('BACK CONTENT'), findsOneWidget);
    expect(find.text('FRONT CONTENT'), findsNothing);

    await tester.tap(find.byType(FlipCard));
    await tester.pumpAndSettle();

    expect(find.text('FRONT CONTENT'), findsOneWidget);
    expect(find.text('BACK CONTENT'), findsNothing);
  });
}
