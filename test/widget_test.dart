// This is a basic Flutter widget test for the Personal Finance Manager app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures, find child widgets in the widget tree, read text, and verify that
// widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PersonalFinanceManager/main.dart';

void main() {
  testWidgets('App navigation smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const PersonalFinanceManagerApp());

    // Verify that the Welcome Screen is displayed initially.
    expect(find.text('Welcome to Personal Finance Manager'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    // Tap the 'Login' button and trigger a frame.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify that the Login Screen is displayed.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Enter dummy credentials and submit.
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify navigation to the Dashboard.
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Add Income'), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget);
  });
}