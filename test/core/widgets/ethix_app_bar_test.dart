import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ethixlabs/core/widgets/ethix_app_bar.dart';

void main() {
  testWidgets('tapping notification/profile icons fires the given callbacks',
      (tester) async {
    var notificationTapped = false;
    var profileTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: EthixAppBar(
            onNotificationTap: () => notificationTapped = true,
            onProfileTap: () => profileTapped = true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_outlined));
    expect(notificationTapped, true);

    await tester.tap(find.byIcon(Icons.person_outline));
    expect(profileTapped, true);
  });

  testWidgets('reports an 80px preferred height', (tester) async {
    const bar = EthixAppBar();
    expect(bar.preferredSize.height, 80);
  });
}
