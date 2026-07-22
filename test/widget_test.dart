import 'package:flutter_test/flutter_test.dart';
import 'package:mind_insight/main.dart';

void main() {
  testWidgets('Home page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MindInsightApp());

    expect(find.text('Mind Insight'), findsOneWidget);
    expect(find.text('Draw my cards'), findsOneWidget);
    expect(find.text('Start a reading'), findsOneWidget);
  });
}
