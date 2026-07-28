import 'package:domino_royale/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({required this.mode, super.key});
  final String mode;
  @override State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  int target = 100;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Crear partida')),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.emoji_events_rounded, size: 82, color: Color(0xFFFFC857)),
      const SizedBox(height: 14),
      Text('Objetivo de puntuación', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('La configuración se bloquea cuando inicia la mesa.', textAlign: TextAlign.center),
      const SizedBox(height: 24),
      SegmentedButton<int>(
        segments: AppConstants.scoreTargets.map((score) => ButtonSegment(value: score, label: Text('$score pts'), icon: const Icon(Icons.flag_outlined))).toList(),
        selected: {target},
        onSelectionChanged: (value) => setState(() => target = value.first),
      ),
      const SizedBox(height: 24),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        ListTile(leading: const Icon(Icons.sports_esports), title: const Text('Modalidad'), trailing: Text(widget.mode.toUpperCase())),
        ListTile(leading: const Icon(Icons.flag), title: const Text('Meta'), trailing: Text('$target puntos')),
        const ListTile(leading: Icon(Icons.security), title: Text('Reglas validadas'), trailing: Text('Motor local MVP')),
      ]))),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: () => context.go('/game/${widget.mode}/$target'), icon: const Icon(Icons.play_arrow), label: const Padding(padding: EdgeInsets.all(14), child: Text('Iniciar partida de demostración'))),
    ])),
  );
}
