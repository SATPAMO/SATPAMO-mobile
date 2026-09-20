import 'package:flutter_test/flutter_test.dart';
import 'package:sama_mobile/main.dart';

void main() {
  testWidgets('SamaMobileApp basic test', (WidgetTester tester) async {
    await tester.pumpWidget(const SamaMobileApp());
    expect(find.byType(SamaMobileApp), findsOneWidget);
  });
}
