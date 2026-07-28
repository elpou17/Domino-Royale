import 'package:domino_royale/features/game/domain/domino_engine.dart';
import 'package:domino_royale/features/game/domain/domino_tile.dart';
import 'package:domino_royale/features/game/presentation/domino_tile_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.mode, required this.targetScore, super.key});
  final String mode;
  final int targetScore;
  @override State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final engine = DominoEngine();
  late List<DominoTile> hand;
  final List<DominoTile> board = [];
  DominoTile? selected;
  int teamA = 0;
  int teamB = 0;
  String message = 'Selecciona una ficha válida.';

  @override
  void initState() {
    super.initState();
    hand = engine.deal(players: 4).first;
  }

  void _play(bool left) {
    final tile = selected;
    if (tile == null) return;
    try {
      final next = engine.play(tile: tile, board: board, onLeft: left);
      setState(() {
        board..clear()..addAll(next);
        hand.remove(tile);
        selected = null;
        message = hand.isEmpty ? '¡Ronda ganada!' : 'Ficha colocada correctamente.';
        if (hand.isEmpty) teamA = (teamA + 25).clamp(0, widget.targetScore);
      });
    } on StateError catch (error) {
      setState(() => message = error.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${widget.mode.toUpperCase()} · ${widget.targetScore} puntos')),
    body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        Expanded(child: _Score(label: 'Equipo Royale', score: teamA, target: widget.targetScore)),
        const SizedBox(width: 10),
        Expanded(child: _Score(label: 'Rivales', score: teamB, target: widget.targetScore)),
      ])),
      Expanded(child: Container(
        margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF0D5A43), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white12, width: 2)),
        child: Center(child: board.isEmpty
          ? const Text('La mesa está lista
Coloca la primera ficha', textAlign: TextAlign.center)
          : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: board.map((tile) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: DominoTileWidget(tile: tile))).toList()))),
      )),
      Text(message, textAlign: TextAlign.center),
      Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        OutlinedButton.icon(onPressed: selected == null ? null : () => _play(true), icon: const Icon(Icons.arrow_left), label: const Text('Izquierda')),
        const SizedBox(width: 12),
        FilledButton.icon(onPressed: selected == null ? null : () => _play(false), icon: const Icon(Icons.arrow_right), label: const Text('Derecha')),
      ])),
      SizedBox(height: 118, child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18), scrollDirection: Axis.horizontal,
        itemCount: hand.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) { final tile = hand[index]; return DominoTileWidget(tile: tile, selected: selected == tile, onTap: () => setState(() => selected = tile)); },
      )),
    ])),
  );
}

class _Score extends StatelessWidget {
  const _Score({required this.label, required this.score, required this.target});
  final String label; final int score; final int target;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text(label), Text('$score / $target', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), LinearProgressIndicator(value: score / target)])));
}
