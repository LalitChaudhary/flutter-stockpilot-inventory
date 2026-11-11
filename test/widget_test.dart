import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/main.dart';

void main() {
  testWidgets('clerk opens the counter', (tester) async {
    await tester.pumpWidget(const StockPilotApp());
    await tester.tap(find.text('Open counter'));
    await tester.pumpAndSettle();
    expect(find.text('Sell 2 bolts'), findsOneWidget);
  });
}
