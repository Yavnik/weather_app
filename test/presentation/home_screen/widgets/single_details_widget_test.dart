import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/presentation/weather_screen/widgets/single_details_widget.dart';

void main() {
  group('SingleDetailsWidget', () {
    testWidgets('renders SingleDetailsWidget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleDetailsWidget(title: 'title', value: '12', iconData: Icons.abc),
          ),
        ),
      );
      expect(find.byType(SingleDetailsWidget), findsOneWidget);
    });
  });
}
