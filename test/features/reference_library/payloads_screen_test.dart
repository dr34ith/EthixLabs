import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/features/reference_library/data/payloads_content.dart';
import 'package:ethixlabs/features/reference_library/presentation/screens/payloads_screen.dart';
import 'package:ethixlabs/features/reference_library/presentation/widgets/payload_category_section.dart';
import 'package:ethixlabs/features/reference_library/presentation/widgets/payload_copy_row.dart';

void main() {
  testWidgets('renders all 8 category sections and scrolls without overflow',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PayloadsScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(PayloadCategorySection), findsNWidgets(8));
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping the copy button copies the exact payload and shows a snackbar',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PayloadsScreen()));
    await tester.pumpAndSettle();

    final firstPayload = payloadCategories.first.techniques.first.payloads.first;

    await tester.tap(find.byIcon(Icons.copy).first);
    await tester.pump();

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboard?.text, firstPayload.value);

    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  testWidgets('PayloadCopyRow uses SelectableText for the payload value',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PayloadsScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(PayloadCopyRow), findsWidgets);
    expect(find.byType(SelectableText), findsWidgets);
  });
}
