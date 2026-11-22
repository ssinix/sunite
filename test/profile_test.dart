import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/screens/profile/edit_profile_screen.dart';
import 'package:sunite/screens/profile/other_profile_screen.dart';
import 'package:sunite/screens/profile/profile_screen.dart';

// Use a tall phone-sized screen so the whole profile is built
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('My Profile shows the profile and owner controls',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('Azra At'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('CS310 app team'), findsOneWidget);
    expect(find.text('My Posts'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('Edit Profile saves a new skill back to My Profile',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Profile'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Figma');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Confirmation dialog after the valid form
    expect(find.text('Profile saved'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Back on My Profile with the new skill
    expect(find.text('Log Out'), findsOneWidget);
    expect(find.text('Figma'), findsOneWidget);
  });

  testWidgets('Edit Profile shows inline errors and no dialog when invalid',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(
      home: EditProfileScreen(profile: SampleProfiles.currentUser),
    ));

    // Remove the only major, then try to save
    await tester.tap(find.descendant(
      of: find.widgetWithText(InputChip, 'Computer Science & Eng.'),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Add at least one major'), findsOneWidget);
    expect(find.text('Profile saved'), findsNothing);
  });

  testWidgets('Other User\'s Profile has no owner controls', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: OtherProfileScreen(profile: SampleProfiles.otherUser),
    ));

    expect(find.text('Elif Çamlıkaya'), findsOneWidget);
    expect(find.text('Contact by e-mail'), findsOneWidget);
    expect(find.text('Log Out'), findsNothing);
    expect(find.text('My Posts'), findsNothing);
  });

  // Issue #3: closing the "Add major" dialog used to crash Edit Profile
  testWidgets('Add major dialog can be cancelled and used again',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(
      home: EditProfileScreen(profile: SampleProfiles.currentUser),
    ));

    // Open the dialog and cancel it
    await tester.tap(find.text('Add major'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsNothing);

    // Open it again and add a major
    await tester.tap(find.text('Add major'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'Economics',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Economics'), findsOneWidget);
  });
}
