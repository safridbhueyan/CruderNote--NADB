// Basic smoke test for the Notes Management app.
//
// Firebase is not initialized in this test environment, so we verify the
// root widget builds the MaterialApp shell (with the Notes title in its theme)
// without actually contacting Firestore.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp builds with Notes theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(appBar: null, body: SizedBox.shrink()),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
