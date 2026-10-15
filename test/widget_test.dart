
import 'package:flutter_test/flutter_test.dart';
import 'package:tac_an_project/app.dart';

void main() {
  testWidgets('E-FORECAST home screen test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TacAnProjectApp());

    expect(find.text('E-FORECAST'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
