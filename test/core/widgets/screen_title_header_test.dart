import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/core/widgets/screen_title_header.dart';

void main() {
  testWidgets('renders title and subtitle, spans the full available width',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScreenTitleHeader(title: 'Missions', subtitle: 'Complete 25 missions.'),
        ),
      ),
    );

    expect(find.text('Missions'), findsOneWidget);
    expect(find.text('Complete 25 missions.'), findsOneWidget);

    final size = tester.getSize(find.byType(ScreenTitleHeader));
    expect(size.width, 800); // default test surface width
  });

  testWidgets('omits the subtitle row entirely when none is given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ScreenTitleHeader(title: 'RoadMap')),
      ),
    );

    expect(find.text('RoadMap'), findsOneWidget);
    // Only the title Text renders — no subtitle Text anywhere in the tree.
    expect(find.byType(Text), findsOneWidget);
  });
}
