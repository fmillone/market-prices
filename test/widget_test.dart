// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_prices/main.dart';
import 'package:market_prices/ticker_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([TickerService])
void main() {
  SharedPreferences.setMockInitialValues({});
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final mock = MockTickerService();
    when(mock.fetchPrices()).thenAnswer((_) async => []);

    await tester.pumpWidget(ProviderScope(
      child: const MyApp(),
      overrides: [TickerService.provider.overrideWithValue(mock)],
    ));

    // Verify that our counter starts at 0.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(mock.fetchPrices()).called(1);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    verifyNever(mock.fetchPrices()).called(0);
    verify(mock.refreshTickers()).called(1);
  });
}
