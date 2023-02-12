import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yuhsuan_sdk/src/widgets.dart';

import 'template.dart';

void main() {
  testWidgets('snack bar test', (tester) async {
    await tester.pumpWidget(MyWidget(
      body: Widgets().snackMessage('M'),
    ));

    final snackFinder = find.byWidget(SnackBar(content: Text('M')));
    expect(snackFinder, findsOneWidget);
  });
}

/// [findsNothing]
// Verifies that no widgets are found.
/// [findsWidgets]
// Verifies that one or more widgets are found.
/// [findsNWidgets]
// Verifies that a specific number of widgets are found.
/// [matchesGoldenFile]
// Verifies that a widget’s rendering matches a particular bitmap image (“golden file” testing).
