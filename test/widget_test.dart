// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:chatter_app/app/app.dart';
import 'package:chatter_app/core/constants/page_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Test MainApp Widget', (WidgetTester tester) async {
    // Build our widget.
    await tester.pumpWidget(const MainApp());

    // Verify if the MaterialApp widget is found.
    expect(find.byType(MaterialApp), findsOneWidget);

    // You can add more test cases here based on your requirements.

    // For example, you can test the presence of specific widgets or routes.

    // Example 1: Verify the presence of a specific route.
    expect(Get.currentRoute, PageRouteConstants.login);

    // Example 2: Verify the presence of specific widgets.
    expect(find.text('Flutter Demo'), findsOneWidget);

    // Example 3: You can test interactions, like tapping on a widget and checking the result.

    // Example 4: Verify theme-related properties, if needed.

    // Example 5: You can test the dark theme by changing the themeMode and checking the UI changes.
  });
}
