import 'package:flutter_test/flutter_test.dart';
import 'package:PearlMarketplace/main.dart';

void main() {
  testWidgets('Pearl Marketplace smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PearlMarketplaceApp());
    expect(find.byType(PearlMarketplaceApp), findsOneWidget);
  });
}
