import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/main.dart';

void main() {
  testWidgets('Counter smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DflApp());
    expect(find.text('DFL Weekend'), findsOneWidget);
  });
}
