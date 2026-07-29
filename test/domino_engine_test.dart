import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:domino_royale/features/game/domino_engine.dart';

void main() {
  test('double-six set distributes seven tiles to four players', () {
    final DominoEngine engine = DominoEngine(
      targetPoints: 100,
      random: Random(7),
    );

    expect(engine.hands.length, 4);
    for (final List<DominoTile> hand in engine.hands) {
      expect(hand.length, 7);
    }
  });

  test('empty board accepts any tile', () {
    final DominoEngine engine = DominoEngine(
      targetPoints: 100,
      random: Random(3),
    );

    expect(engine.canPlay(engine.hands.first.first), isTrue);
  });
}
