import 'package:flutter_test/flutter_test.dart';
import 'package:calm_space_app/main.dart';

void main() {
  testWidgets('CalmSpace smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalmSpaceApp());

    // Verify that our app starts with the welcome message.
    expect(find.text('Halo, Selamat Datang! 🌿'), findsOneWidget);
  });
}