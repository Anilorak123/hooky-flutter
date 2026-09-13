import 'package:flutter_test/flutter_test.dart';
import 'package:hooky_flutter/main.dart';

void main() {
  testWidgets('Hooky smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HookyApp());
  });
}