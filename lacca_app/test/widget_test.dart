import 'package:flutter_test/flutter_test.dart';

import 'package:lacca_app/main.dart';

void main() {
  testWidgets('LACA app loads onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LacaApp());
    await tester.pump();

    // Verify the onboarding screen shows
    expect(find.text('Welcome to LACA'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}