import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/reference_library/domain/reference_card.dart';
import 'package:ethixlabs/features/reference_library/presentation/widgets/library_card.dart';

void main() {
  testWidgets('LibraryCard displays title, category, description, and reading time',
      (tester) async {
    const card = ReferenceCard(
      id: 'test_card',
      title: 'What is Ethical Hacking?',
      categoryLabel: 'Foundations',
      icon: '🎓',
      description: 'Understanding ethical hacking and legal testing',
      readingMinutes: 4,
      difficulty: 'Easy',
      section: ReferenceSection.foundations,
    );

    var tapped = false;
    var bookmarkToggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryCard(
            card: card,
            isRead: false,
            isBookmarked: false,
            onTap: () => tapped = true,
            onToggleBookmark: () => bookmarkToggled = true,
          ),
        ),
      ),
    );

    expect(find.text('What is Ethical Hacking?'), findsOneWidget);
    expect(find.text('FOUNDATIONS'), findsOneWidget);
    expect(find.text('Understanding ethical hacking and legal testing'),
        findsOneWidget);
    expect(find.text('4 min'), findsOneWidget);
    expect(find.text('Read'), findsNothing);

    await tester.tap(find.byType(LibraryCard));
    expect(tapped, true);

    await tester.tap(find.byIcon(Icons.favorite_border));
    expect(bookmarkToggled, true);
  });

  testWidgets('shows the Read badge once the card has been opened',
      (tester) async {
    const card = ReferenceCard(
      id: 'test_card',
      title: 'Reference Glossary',
      categoryLabel: 'Cybersecurity Terms',
      icon: '📖',
      description: 'Definitions',
      readingMinutes: 10,
      difficulty: 'Easy',
      section: ReferenceSection.reference,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryCard(
            card: card,
            isRead: true,
            isBookmarked: true,
            onTap: () {},
            onToggleBookmark: () {},
          ),
        ),
      ),
    );

    expect(find.text('Read'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
