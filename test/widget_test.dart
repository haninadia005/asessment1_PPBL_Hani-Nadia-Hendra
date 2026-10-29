import 'package:flutter_test/flutter_test.dart';
import 'package:agriclima_lstm_707012400104/main.dart';

void main() {
  testWidgets('Aplikasi AgriClima dapat dibuka',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AgriClimaApp());

    expect(find.text('AgriClima - Beranda'), findsOneWidget);
  });
}