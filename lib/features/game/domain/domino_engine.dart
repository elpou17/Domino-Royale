import 'dart:math';
import 'package:domino_royale/features/game/domain/domino_tile.dart';

class RoundResult {
  const RoundResult({required this.winnerIndex, required this.points, required this.blocked});
  final int winnerIndex;
  final int points;
  final bool blocked;
}

class DominoEngine {
  DominoEngine({Random? random}) : _random = random ?? Random();
  final Random _random;

  List<DominoTile> createSet() {
    return [for (var left = 0; left <= 6; left++) for (var right = left; right <= 6; right++) DominoTile(left, right)];
  }

  List<List<DominoTile>> deal({required int players, int tilesPerPlayer = 7}) {
    final deck = createSet()..shuffle(_random);
    if (players * tilesPerPlayer > deck.length) throw ArgumentError('No hay fichas suficientes.');
    return [for (var p = 0; p < players; p++) deck.sublist(p * tilesPerPlayer, (p + 1) * tilesPerPlayer)];
  }

  bool canPlay(DominoTile tile, List<DominoTile> board) {
    if (board.isEmpty) return true;
    return tile.matches(board.first.left) || tile.matches(board.last.right);
  }

  List<DominoTile> play({required DominoTile tile, required List<DominoTile> board, required bool onLeft}) {
    if (board.isEmpty) return [tile];
    final output = [...board];
    if (onLeft) {
      final open = output.first.left;
      if (!tile.matches(open)) throw StateError('La ficha no coincide con el extremo izquierdo.');
      output.insert(0, tile.right == open ? tile : tile.flipped());
    } else {
      final open = output.last.right;
      if (!tile.matches(open)) throw StateError('La ficha no coincide con el extremo derecho.');
      output.add(tile.left == open ? tile : tile.flipped());
    }
    return output;
  }

  int handPoints(List<DominoTile> hand) => hand.fold(0, (sum, tile) => sum + tile.points);

  RoundResult resolveBlocked(List<List<DominoTile>> hands) {
    final totals = hands.map(handPoints).toList();
    final minimum = totals.reduce(min);
    final winner = totals.indexOf(minimum);
    final awarded = totals.where((value) => value != minimum).fold(0, (a, b) => a + b);
    return RoundResult(winnerIndex: winner, points: awarded, blocked: true);
  }
}
