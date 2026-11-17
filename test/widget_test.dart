import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunite/main.dart';

void main() {
  testWidgets('App starts with the bottom navigation bar', (tester) async {
    await tester.pumpWidget(const SUniteApp());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('My Groups'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
