import 'package:domino_royale/features/game/domain/domino_engine.dart';
import 'package:domino_royale/features/game/domain/domino_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DominoEngine', () {
    final engine = DominoEngine();

    test('crea las 28 fichas del doble-seis', () {
      expect(engine.createSet(), hasLength(28));
      expect(engine.createSet().toSet(), hasLength(28));
    });

    test('reparte siete fichas a cuatro jugadores', () {
      final hands = engine.deal(players: 4);
      expect(hands, hasLength(4));
      expect(hands.every((hand) => hand.length == 7), isTrue);
    });

    test('permite colocar una ficha coincidente a la derecha', () {
      final board = engine.play(tile: const DominoTile(2, 5), board: const [DominoTile(1, 2)], onLeft: false);
      expect(board, const [DominoTile(1, 2), DominoTile(2, 5)]);
    });

    test('invierte la ficha cuando corresponde', () {
      final board = engine.play(tile: const DominoTile(5, 2), board: const [DominoTile(1, 2)], onLeft: false);
      expect(board.last, const DominoTile(2, 5));
    });

    test('rechaza una ficha no compatible', () {
      expect(() => engine.play(tile: const DominoTile(4, 5), board: const [DominoTile(1, 2)], onLeft: false), throwsStateError);
    });

    test('resuelve un tranque por menor cantidad de puntos', () {
      final result = engine.resolveBlocked(const [
        [DominoTile(0, 1)], [DominoTile(5, 6)], [DominoTile(2, 3)], [DominoTile(4, 4)]
      ]);
      expect(result.winnerIndex, 0);
      expect(result.blocked, isTrue);
      expect(result.points, 24);
    });
  });
}
