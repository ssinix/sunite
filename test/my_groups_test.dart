import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunite/main.dart';
import 'package:sunite/screens/my_groups/my_groups_screen.dart';

// Use a tall phone-sized screen so whole screens are built
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 4800);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

// Opens My Groups on its own; Browse boards does nothing here
Future<void> pumpMyGroups(WidgetTester tester) async {
  useTallScreen(tester);
  await tester.pumpWidget(
    MaterialApp(home: MyGroupsScreen(onBrowseBoards: () {})),
  );
}

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

// Switches the Owned / Joined / My Requests toggle
Future<void> selectTab(WidgetTester tester, String tab) async {
  await tester.tap(find.widgetWithText(ElevatedButton, tab));
  await tester.pumpAndSettle();
}

// Waits until the SnackBar is gone, so it doesn't cover bottom buttons
Future<void> waitForSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  group('My Groups', () {
    testWidgets('toggle switches between the three lists', (tester) async {
      await pumpMyGroups(tester);

      expect(find.text('CS310 app team'), findsOneWidget);
      expect(find.text('2 pending'), findsNWidgets(2));

      await selectTab(tester, 'Joined');
      expect(find.text('ENS491 project team'), findsOneWidget);
      expect(find.text('CS310 app team'), findsNothing);

      await selectTab(tester, 'My Requests');
      expect(find.text('CS412 study group'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Declined'), findsOneWidget);
    });

    testWidgets('removing every request shows the empty state, '
        'and Browse boards opens Home', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const SUniteApp());
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('My Groups'),
        ),
      );
      await tester.pumpAndSettle();
      await selectTab(tester, 'My Requests');

      await tapText(tester, 'Cancel request');
      expect(find.text('CS412 study group'), findsNothing);
      expect(find.text('Request cancelled'), findsOneWidget);

      await tapText(tester, 'Remove');
      expect(find.text('No requests yet'), findsOneWidget);

      await tapText(tester, 'Browse boards');
      expect(find.text('Home screen coming soon'), findsOneWidget);
    });
  });

  group('Manage Group', () {
    testWidgets('accepting a request updates Manage Group and My Groups',
        (tester) async {
      await pumpMyGroups(tester);
      await tapText(tester, 'CS310 app team');
      expect(find.text('3/5'), findsOneWidget);
      expect(find.text('PENDING REQUESTS (2)'), findsOneWidget);

      await tapText(tester, 'Accept');
      expect(find.text('4/5'), findsOneWidget);
      expect(find.text('PENDING REQUESTS (1)'), findsOneWidget);
      expect(find.text('MEMBERS (4)'), findsOneWidget);

      // Back on My Groups, the card shows the new numbers
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('4/5'), findsOneWidget);
      expect(find.text('1 pending'), findsOneWidget);
    });

    testWidgets('Accept is disabled once the group is full', (tester) async {
      await pumpMyGroups(tester);
      await tapText(tester, 'Campus food-waste app');

      await tapText(tester, 'Accept');
      expect(find.text('3/3'), findsOneWidget);
      expect(find.textContaining('The group is full'), findsOneWidget);

      final accept = tester.widget<ButtonStyleButton>(
        find.ancestor(
          of: find.text('Accept'),
          matching: find.bySubtype<ButtonStyleButton>(),
        ),
      );
      expect(accept.onPressed, isNull);
    });

    testWidgets('Delete Group asks first, then removes the group',
        (tester) async {
      await pumpMyGroups(tester);
      await tapText(tester, 'CS310 app team');

      // Cancel keeps the group
      await tapText(tester, 'Delete Group');
      expect(find.text('Delete this group?'), findsOneWidget);
      await tapText(tester, 'Cancel');
      expect(find.text('Manage Group'), findsOneWidget);

      // Delete goes back to My Groups without the group
      await tapText(tester, 'Delete Group');
      await tapText(tester, 'Delete');
      expect(find.text('Manage Group'), findsNothing);
      expect(find.text('CS310 app team'), findsNothing);
      expect(find.text('"CS310 app team" was deleted'), findsOneWidget);
    });
  });

  group('Group Detail', () {
    testWidgets('leaving a group and asking to join again moves it to '
        'My Requests', (tester) async {
      await pumpMyGroups(tester);
      await selectTab(tester, 'Joined');
      await tapText(tester, 'ENS491 project team');
      expect(find.text('3/4 members'), findsOneWidget);

      await tapText(tester, 'Leave Group');
      expect(find.text('Leave this group?'), findsOneWidget);
      await tapText(tester, 'Leave');
      expect(find.text('2/4 members'), findsOneWidget);
      await waitForSnackBar(tester);

      await tapText(tester, 'Request to Join');
      expect(find.text('Request to join?'), findsOneWidget);
      await tapText(tester, 'Send Request');
      expect(find.text('Request pending'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('No joined groups yet'), findsOneWidget);

      await selectTab(tester, 'My Requests');
      expect(find.text('ENS491 project team'), findsOneWidget);
      expect(find.text('Pending'), findsNWidgets(2));
    });

    testWidgets('shows the pending and full states', (tester) async {
      await pumpMyGroups(tester);
      await selectTab(tester, 'My Requests');

      await tapText(tester, 'CS412 study group');
      expect(find.text('Request pending'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tapText(tester, 'Going to Bologna in Fall 2027');
      expect(find.text('Group full'), findsOneWidget);
    });
  });
}
