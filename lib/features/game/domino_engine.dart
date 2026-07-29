import 'dart:math';

class DominoTile {
  const DominoTile(this.left, this.right);

  final int left;
  final int right;

  int get points => left + right;

  DominoTile flipped() => DominoTile(right, left);

  @override
  bool operator ==(Object other) {
    return other is DominoTile && other.left == left && other.right == right;
  }

  @override
  int get hashCode => Object.hash(left, right);

  @override
  String toString() => '$left|$right';
}

class DominoEngine {
  DominoEngine({required this.targetPoints, Random? random})
      : _random = random ?? Random() {
    newRound();
  }

  final int targetPoints;
  final Random _random;
  final List<List<DominoTile>> hands = <List<DominoTile>>[
    <DominoTile>[],
    <DominoTile>[],
    <DominoTile>[],
    <DominoTile>[],
  ];
  final List<DominoTile> board = <DominoTile>[];
  final List<int> teamScores = <int>[0, 0];

  int turn = 0;
  int passes = 0;
  bool roundFinished = false;
  String resultMessage = '';

  int? get leftEnd => board.isEmpty ? null : board.first.left;
  int? get rightEnd => board.isEmpty ? null : board.last.right;

  bool get matchFinished =>
      teamScores[0] >= targetPoints || teamScores[1] >= targetPoints;

  void newRound() {
    final List<DominoTile> deck = <DominoTile>[];
    for (int left = 0; left <= 6; left++) {
      for (int right = left; right <= 6; right++) {
        deck.add(DominoTile(left, right));
      }
    }
    deck.shuffle(_random);

    for (final List<DominoTile> hand in hands) {
      hand.clear();
    }
    board.clear();

    for (int player = 0; player < 4; player++) {
      hands[player].addAll(deck.skip(player * 7).take(7));
    }

    turn = 0;
    passes = 0;
    roundFinished = false;
    resultMessage = '';
  }

  bool canPlay(DominoTile tile) {
    if (board.isEmpty) {
      return true;
    }
    return tile.left == leftEnd ||
        tile.right == leftEnd ||
        tile.left == rightEnd ||
        tile.right == rightEnd;
  }

  bool playTile(int player, DominoTile tile, {bool preferLeft = false}) {
    if (roundFinished || player != turn || !hands[player].contains(tile)) {
      return false;
    }
    if (!canPlay(tile)) {
      return false;
    }

    DominoTile placed = tile;
    if (board.isEmpty) {
      board.add(placed);
    } else {
      final bool canLeft = tile.left == leftEnd || tile.right == leftEnd;
      final bool canRight = tile.left == rightEnd || tile.right == rightEnd;

      if (canLeft && (preferLeft || !canRight)) {
        if (tile.right != leftEnd) {
          placed = tile.flipped();
        }
        board.insert(0, placed);
      } else {
        if (tile.left != rightEnd) {
          placed = tile.flipped();
        }
        board.add(placed);
      }
    }

    hands[player].remove(tile);
    passes = 0;

    if (hands[player].isEmpty) {
      _finishRound(player % 2, 'El jugador ${player + 1} dominó la ronda');
    } else {
      turn = (turn + 1) % 4;
    }
    return true;
  }

  bool pass(int player) {
    if (roundFinished || player != turn || firstPlayable(player) != null) {
      return false;
    }

    passes++;
    turn = (turn + 1) % 4;
    if (passes >= 4) {
      _finishBlockedRound();
    }
    return true;
  }

  DominoTile? firstPlayable(int player) {
    for (final DominoTile tile in hands[player]) {
      if (canPlay(tile)) {
        return tile;
      }
    }
    return null;
  }

  int handPoints(int player) {
    return hands[player]
        .fold<int>(0, (int sum, DominoTile tile) => sum + tile.points);
  }

  int teamHandPoints(int team) {
    return handPoints(team) + handPoints(team + 2);
  }

  void _finishBlockedRound() {
    final int teamA = teamHandPoints(0);
    final int teamB = teamHandPoints(1);
    if (teamA <= teamB) {
      _finishRound(0, 'Ronda trancada: gana Equipo A');
    } else {
      _finishRound(1, 'Ronda trancada: gana Equipo B');
    }
  }

  void _finishRound(int winningTeam, String message) {
    final List<int> losingPlayers =
        winningTeam == 0 ? <int>[1, 3] : <int>[0, 2];
    int earned = 0;
    for (final int player in losingPlayers) {
      earned += handPoints(player);
    }

    teamScores[winningTeam] += earned;
    roundFinished = true;
    resultMessage = '$message (+$earned puntos)';
  }
}
