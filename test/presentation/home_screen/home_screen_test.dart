import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/presentation/home_screen/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders HomeScreen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
