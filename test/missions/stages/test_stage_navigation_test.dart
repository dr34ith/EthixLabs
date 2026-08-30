import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ethixlabs/providers/app_provider.dart';
import 'package:ethixlabs/missions/data/missions_data.dart';
import 'package:ethixlabs/missions/stages/test_stage.dart';
import 'package:ethixlabs/missions/stages/identify_stage.dart';
import 'package:ethixlabs/missions/vulnshop/vulnshop_lab.dart';

// Regression coverage for the TEST -> IDENTIFY navigation bug: missions 1-4
// are conceptual (no VulnShop exploit is ever wired up for them in
// vulnshop_lab.dart's _evalUrlExploit), so gating stage completion on the
// lab's onResult callback left users permanently stuck at TEST. TestStage
// now completes those missions directly instead of launching the lab.
void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget wrap(AppProvider provider, Widget child) {
    return ChangeNotifierProvider<AppProvider>.value(
      value: provider,
      child: MaterialApp(home: child),
    );
  }

  testWidgets(
      'Mission 1 (conceptual): TEST stage completes without the VulnShop '
      'lab and navigates to IDENTIFY', (tester) async {
    final provider = AppProvider();
    final mission = allMissions.firstWhere((m) => m.number == 1);

    await tester.pumpWidget(wrap(provider, TestStage(mission: mission)));
    await tester.pump();

    await tester.tap(find.text(
        'I have read the guidance and understand what I need to do.'));
    await tester.pump();

    expect(find.text('MARK TEST STAGE COMPLETE'), findsOneWidget);
    expect(find.text('LAUNCH VULNSHOP LAB'), findsNothing);

    await tester.tap(find.text('MARK TEST STAGE COMPLETE'));
    await tester.pump();

    expect(find.text('TEST STAGE COMPLETE!'), findsOneWidget);
    expect(
      provider.getMissionProgress(1).completedStages.contains(MissionStage.test),
      true,
    );

    expect(find.text('CONTINUE TO IDENTIFY STAGE'), findsOneWidget);
    await tester.tap(find.text('CONTINUE TO IDENTIFY STAGE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(IdentifyStage), findsOneWidget);
    expect(find.byType(TestStage), findsNothing);
  });

  testWidgets(
      'Mission 5 (hands-on): TEST stage still requires launching the '
      'VulnShop lab, not an immediate complete', (tester) async {
    final provider = AppProvider();
    final mission = allMissions.firstWhere((m) => m.number == 5);

    await tester.pumpWidget(wrap(provider, TestStage(mission: mission)));
    await tester.pump();

    await tester.tap(find.text(
        'I have read the guidance and understand what I need to do.'));
    await tester.pump();

    expect(find.text('LAUNCH VULNSHOP LAB'), findsOneWidget);
    expect(find.text('MARK TEST STAGE COMPLETE'), findsNothing);

    await tester.tap(find.text('LAUNCH VULNSHOP LAB'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(VulnShopLabPage), findsOneWidget);
    expect(
      provider.getMissionProgress(5).completedStages.contains(MissionStage.test),
      false,
    );
  });

  testWidgets('Mission 1: resuming after TEST is already complete shows '
      'the Continue button immediately', (tester) async {
    final provider = AppProvider();
    provider.completeStage(1, MissionStage.test);
    final mission = allMissions.firstWhere((m) => m.number == 1);

    await tester.pumpWidget(wrap(provider, TestStage(mission: mission)));
    await tester.pump();

    expect(find.text('TEST STAGE COMPLETE!'), findsOneWidget);
    expect(find.text('CONTINUE TO IDENTIFY STAGE'), findsOneWidget);
    expect(find.text('MARK TEST STAGE COMPLETE'), findsNothing);
  });
}
