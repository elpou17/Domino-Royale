import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import 'domino_engine.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.profile,
    required this.mode,
    required this.targetPoints,
    required this.entryFee,
    required this.online,
  });

  final PlayerProfile profile;
  final String mode;
  final int targetPoints;
  final int entryFee;
  final bool online;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DominoEngine _engine;
  late PlayerProfile _profile;
  final ProfileStore _store = ProfileStore();
  String _message = 'Tu turno: selecciona una ficha';
  bool _botsRunning = false;
  bool _roundDialogShown = false;
  final List<String> _chatMessages = <String>['Bienvenidos a la mesa Royale'];

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _engine = DominoEngine(targetPoints: widget.targetPoints);
  }

  Future<void> _playHuman(DominoTile tile) async {
    if (_engine.turn != 0 || _engine.roundFinished || _botsRunning) return;
    final bool played = _engine.playTile(0, tile);
    setState(() => _message = played ? 'Ficha jugada' : 'Esa ficha no puede jugarse');
    if (played) await _runBots();
  }

  Future<void> _passHuman() async {
    if (_engine.turn != 0 || _engine.roundFinished || _botsRunning) return;
    final bool passed = _engine.pass(0);
    if (!passed) {
      setState(() => _message = 'Tienes una ficha disponible');
      return;
    }
    setState(() => _message = 'Pasaste el turno');
    await _runBots();
  }

  Future<void> _runBots() async {
    _botsRunning = true;
    while (!_engine.roundFinished && _engine.turn != 0) {
      final int player = _engine.turn;
      await Future<void>.delayed(const Duration(milliseconds: 380));
      if (!mounted) return;
      final DominoTile? tile = _engine.firstPlayable(player);
      setState(() {
        if (tile == null) {
          _engine.pass(player);
          _message = 'Jugador ${player + 1} pasó';
        } else {
          _engine.playTile(player, tile);
          _message = 'Jugador ${player + 1} jugó';
        }
      });
    }
    _botsRunning = false;
    if (!mounted) return;
    setState(() => _message = _engine.roundFinished ? _engine.resultMessage : 'Tu turno');
    if (_engine.roundFinished && !_roundDialogShown) {
      _roundDialogShown = true;
      await _showRoundResult();
    }
  }

  Future<void> _showRoundResult() async {
    final bool userTeamWon = _engine.teamScores[0] >= _engine.teamScores[1];
    final bool matchFinished = _engine.matchFinished;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(userTeamWon ? Icons.emoji_events_rounded : Icons.sports_score_rounded, color: const Color(0xFFFFB000)),
              const SizedBox(width: 10),
              Text(userTeamWon ? '¡Ganadores!' : 'Fin de ronda'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_engine.resultMessage, textAlign: TextAlign.center),
              const SizedBox(height: 14),
              _ResultScore(label: 'Nosotros', score: _engine.teamScores[0], color: const Color(0xFF2196F3)),
              const SizedBox(height: 8),
              _ResultScore(label: 'Ellos', score: _engine.teamScores[1], color: const Color(0xFFE85D5D)),
              if (_engine.resultMessage.toLowerCase().contains('trancada')) ...<Widget>[
                const SizedBox(height: 16),
                const Icon(Icons.lock_rounded, size: 62, color: Color(0xFFFFB000)),
                const Text('Partida trancada: se aplicó conteo de fichas.'),
              ],
            ],
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(matchFinished ? 'Ver resultado final' : 'Siguiente ronda'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (matchFinished) {
      final bool won = _engine.teamScores[0] >= _engine.teamScores[1];
      final int reward = won ? widget.entryFee * 2 : 0;
      _profile = await _store.registerMatch(_profile, won: won, reward: reward);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(won ? 'Campeones Royale' : 'Partida finalizada'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(won ? Icons.workspace_premium_rounded : Icons.handshake_rounded, size: 88, color: const Color(0xFFFFB000)),
                Text(won ? 'Ganaste $reward monedas' : 'Mejor suerte en la próxima mesa'),
                const SizedBox(height: 8),
                Text('Marcador final ${_engine.teamScores[0]} - ${_engine.teamScores[1]}'),
              ],
            ),
            actions: <Widget>[
              FilledButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Volver al lobby')),
            ],
          );
        },
      );
      if (mounted) Navigator.of(context).pop(_profile);
    } else {
      setState(() {
        _engine.newRound();
        _roundDialogShown = false;
        _message = 'Nueva ronda: tu turno';
      });
    }
  }

  Future<void> _showChat() async {
    final TextEditingController controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) modalSetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SafeArea(
                child: SizedBox(
                  height: 480,
                  child: Column(
                    children: <Widget>[
                      const ListTile(leading: Icon(Icons.chat_bubble_outline), title: Text('Chat de la mesa', style: TextStyle(fontWeight: FontWeight.w900))),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(14),
                          itemCount: _chatMessages.length,
                          itemBuilder: (_, int index) => Align(
                            alignment: index.isEven ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(color: index.isEven ? Colors.white10 : const Color(0xFF0D78A6), borderRadius: BorderRadius.circular(16)),
                              child: Text(_chatMessages[index]),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <String>['Buena jugada', 'Vamos', 'Suerte', 'Bien jugado'].map((String text) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(label: Text(text), onPressed: () => modalSetState(() => _chatMessages.add(text))),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Escribe aquí...', border: OutlineInputBorder()))),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              onPressed: () {
                                final String text = controller.text.trim();
                                if (text.isEmpty) return;
                                modalSetState(() => _chatMessages.add(text));
                                controller.clear();
                              },
                              icon: const Icon(Icons.send_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    controller.dispose();
  }

  Future<void> _showEmojis() async {
    const List<String> emojis = <String>['😀', '😂', '😎', '😭', '😡', '👏', '👍', '🤔', '😱', '🥳', '🔥', '👑', '💯', '🍀', '🤝', '🎉'];
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: emojis.map((String emoji) => InkWell(onTap: () => Navigator.pop(sheetContext, emoji), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 38))))).toList(),
            ),
          ),
        );
      },
    );
    if (selected != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reacción enviada $selected'), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _showGameMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const ListTile(leading: Icon(Icons.menu_rounded), title: Text('MENÚ DE PARTIDA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
                _MenuItem(icon: Icons.trending_up_rounded, title: 'Aumentar apuesta', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.pan_tool_alt_rounded, title: 'Proponer anulación de partido', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.chat_bubble_outline, title: 'Chat de la mesa', onTap: () { Navigator.pop(sheetContext); _showChat(); }),
                _MenuItem(icon: Icons.person_search_rounded, title: 'Buscar jugadores', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.settings_rounded, title: 'Configuraciones', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.palette_outlined, title: 'Personaliza tu juego', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.lightbulb_outline_rounded, title: 'Consejos de jugada', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.rule_rounded, title: 'Reglas del juego', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(icon: Icons.report_problem_outlined, title: 'Tuve un problema', onTap: () => Navigator.pop(sheetContext)),
                _MenuItem(
                  icon: Icons.exit_to_app_rounded,
                  title: 'Salir del juego',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmExit();
                  },
                ),
                const Padding(padding: EdgeInsets.all(18), child: Text('Domino Royale • v2.0.0', style: TextStyle(color: Colors.white38))),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmExit() async {
    final bool? exit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Salir de la partida'),
        content: const Text('Perderás la entrada de esta mesa. ¿Deseas continuar?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Salir')),
        ],
      ),
    );
    if (exit == true && mounted) Navigator.of(context).pop(_profile);
  }

  @override
  Widget build(BuildContext context) {
    final List<DominoTile> hand = _engine.hands[0];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(center: Alignment.center, radius: 1.2, colors: <Color>[Color(0xFF0C6A38), Color(0xFF03311D)]),
            ),
            child: Column(
              children: <Widget>[
                _GameTopBar(
                  targetPoints: widget.targetPoints,
                  scoreA: _engine.teamScores[0],
                  scoreB: _engine.teamScores[1],
                  onEmoji: _showEmojis,
                  onChat: _showChat,
                  onMenu: _showGameMenu,
                ),
                _PlayerSeat(name: 'Carlos', tiles: _engine.hands[2].length, isTurn: _engine.turn == 2),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _SideSeat(name: 'Luis', tiles: _engine.hands[1].length, isTurn: _engine.turn == 1),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 3,
                                  runSpacing: 3,
                                  children: _engine.board.map((DominoTile tile) => DominoTileView(tile: tile, small: true, horizontal: tile.left != tile.right)).toList(),
                                ),
                              ),
                            ),
                            if (_engine.roundFinished && _engine.resultMessage.toLowerCase().contains('trancada'))
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(28)),
                                child: const Column(mainAxisSize: MainAxisSize.min, children: <Widget>[Icon(Icons.lock_rounded, size: 86, color: Color(0xFFFFB000)), Text('JUEGO TRANCADO', style: TextStyle(fontWeight: FontWeight.w900))]),
                              ),
                          ],
                        ),
                      ),
                      _SideSeat(name: 'Ana', tiles: _engine.hands[3].length, isTurn: _engine.turn == 3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(_message, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                _PlayerSeat(name: _profile.displayName, tiles: hand.length, isTurn: _engine.turn == 0),
                SizedBox(
                  height: 116,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: hand.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 7),
                    itemBuilder: (BuildContext context, int index) {
                      final DominoTile tile = hand[index];
                      final bool playable = _engine.canPlay(tile) && _engine.turn == 0;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: playable ? 1 : 0.48,
                        child: GestureDetector(onTap: () => _playHuman(tile), child: DominoTileView(tile: tile, small: false)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: OutlinedButton.icon(onPressed: _passHuman, icon: const Icon(Icons.skip_next_rounded), label: const Text('Pasar'))),
                      const SizedBox(width: 10),
                      Expanded(child: FilledButton.icon(onPressed: _showEmojis, icon: const Icon(Icons.emoji_emotions_rounded), label: const Text('Emoji'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameTopBar extends StatelessWidget {
  const _GameTopBar({required this.targetPoints, required this.scoreA, required this.scoreB, required this.onEmoji, required this.onChat, required this.onMenu});
  final int targetPoints;
  final int scoreA;
  final int scoreB;
  final VoidCallback onEmoji;
  final VoidCallback onChat;
  final VoidCallback onMenu;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.black38,
      child: Row(
        children: <Widget>[
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), color: Colors.black38, child: Text('$scoreA\n$scoreB', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Text('Partida a $targetPoints puntos', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900))),
          IconButton(onPressed: onEmoji, icon: const Icon(Icons.emoji_emotions_rounded, color: Color(0xFFFFD65A))),
          IconButton(onPressed: onChat, icon: const Icon(Icons.chat_bubble_rounded)),
          IconButton(onPressed: onMenu, icon: const Icon(Icons.menu_rounded, size: 32)),
        ],
      ),
    );
  }
}

class _PlayerSeat extends StatelessWidget {
  const _PlayerSeat({required this.name, required this.tiles, required this.isTurn});
  final String name;
  final int tiles;
  final bool isTurn;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isTurn ? Colors.greenAccent : Colors.transparent, width: 3)), child: const CircleAvatar(radius: 21, child: Icon(Icons.person))),
          Text('$name • $tiles', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SideSeat extends StatelessWidget {
  const _SideSeat({required this.name, required this.tiles, required this.isTurn});
  final String name;
  final int tiles;
  final bool isTurn;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 58, child: _PlayerSeat(name: name, tiles: tiles, isTurn: isTurn));
  }
}

class DominoTileView extends StatelessWidget {
  const DominoTileView({super.key, required this.tile, required this.small, this.horizontal = false});
  final DominoTile tile;
  final bool small;
  final bool horizontal;
  @override
  Widget build(BuildContext context) {
    final double width = small ? (horizontal ? 48 : 27) : 52;
    final double height = small ? (horizontal ? 27 : 48) : 96;
    final Widget face = Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(small ? 2 : 4),
      decoration: BoxDecoration(color: const Color(0xFFF7F7F3), borderRadius: BorderRadius.circular(small ? 4 : 8), border: Border.all(color: const Color(0xFFB9B9B9)), boxShadow: const <BoxShadow>[BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(1, 2))]),
      child: horizontal
          ? Row(children: <Widget>[Expanded(child: _PipFace(value: tile.left, small: small)), Container(width: 1, color: Colors.black54), Expanded(child: _PipFace(value: tile.right, small: small))])
          : Column(children: <Widget>[Expanded(child: _PipFace(value: tile.left, small: small)), Container(height: 1, color: Colors.black54), Expanded(child: _PipFace(value: tile.right, small: small))]),
    );
    return face;
  }
}

class _PipFace extends StatelessWidget {
  const _PipFace({required this.value, required this.small});
  final int value;
  final bool small;
  static const List<Alignment> _positions = <Alignment>[
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];
  List<int> get _active {
    switch (value) {
      case 1: return <int>[4];
      case 2: return <int>[0, 8];
      case 3: return <int>[0, 4, 8];
      case 4: return <int>[0, 2, 6, 8];
      case 5: return <int>[0, 2, 4, 6, 8];
      case 6: return <int>[0, 2, 3, 5, 6, 8];
      default: return <int>[];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(children: _active.map((int index) => Align(alignment: _positions[index], child: Container(width: small ? 4 : 7, height: small ? 4 : 7, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)))).toList());
  }
}

class _ResultScore extends StatelessWidget {
  const _ResultScore({required this.label, required this.score, required this.color});
  final String label;
  final int score;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(14), border: Border.all(color: color)), child: Row(children: <Widget>[Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))), Text('$score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))]));
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.title, required this.onTap, this.color});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon, color: color ?? const Color(0xFF23C9D6)), title: Text(title), onTap: onTap);
  }
}
