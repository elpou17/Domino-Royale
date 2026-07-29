import 'package:flutter_test/flutter_test.dart';
import 'package:domino_royale/app.dart';

void main() {
  testWidgets('Domino Royale inicia correctamente', (tester) async {
    await tester.pumpWidget(const DominoRoyaleApp());

    expect(find.byType(DominoRoyaleApp), findsOneWidget);
  });
}
