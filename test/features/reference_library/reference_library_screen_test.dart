import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ethixlabs/features/reference_library/presentation/controllers/reference_controller.dart';
import 'package:ethixlabs/features/reference_library/presentation/screens/reference_library_screen.dart';
import 'package:ethixlabs/features/reference_library/presentation/widgets/library_card.dart';

import 'test_helpers.dart';

void main() {
  setUpAll(() {
    initTestDatabaseFactory();
  });

  testWidgets('renders all 6 curated cards when unfiltered', (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<ReferenceController>.value(
        value: controller,
        child: const MaterialApp(home: Scaffold(body: ReferenceLibraryScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LibraryCard), findsNWidgets(6));
    expect(find.text('What is Ethical Hacking?'), findsOneWidget);
    expect(find.text('The Three Types of Hackers'), findsOneWidget);
    expect(find.text('Payloads'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('OWASP Top 10:2025'), findsOneWidget);
    expect(find.text('Reference Glossary'), findsOneWidget);
  });

  testWidgets('search narrows the visible cards in real time', (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<ReferenceController>.value(
        value: controller,
        child: const MaterialApp(home: Scaffold(body: ReferenceLibraryScreen())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'glossary');
    await tester.pumpAndSettle();

    expect(find.byType(LibraryCard), findsOneWidget);
    expect(find.text('Reference Glossary'), findsOneWidget);
  });

  testWidgets('the Foundations filter chip shows only Foundations cards',
      (tester) async {
    final controller = await createTestController();

    await tester.pumpWidget(
      ChangeNotifierProvider<ReferenceController>.value(
        value: controller,
        child: const MaterialApp(home: Scaffold(body: ReferenceLibraryScreen())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foundations'));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryCard), findsNWidgets(2));
    expect(find.text('What is Ethical Hacking?'), findsOneWidget);
    expect(find.text('The Three Types of Hackers'), findsOneWidget);
  });
}
