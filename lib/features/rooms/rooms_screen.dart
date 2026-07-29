import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import '../../core/widgets/royale_header.dart';
import '../game/game_screen.dart';

class GameRoom {
  const GameRoom({required this.name, required this.entryFee, required this.minBalance, required this.players, required this.colors, required this.icon});
  final String name;
  final int entryFee;
  final int minBalance;
  final int players;
  final List<Color> colors;
  final IconData icon;
}

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key, required this.profile, required this.mode, required this.online});
  final PlayerProfile profile;
  final String mode;
  final bool online;

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  late PlayerProfile _profile;
  final ProfileStore _store = ProfileStore();

  static const List<GameRoom> _rooms = <GameRoom>[
    GameRoom(name: 'INICIANTE I', entryFee: 100, minBalance: 0, players: 99, colors: <Color>[Color(0xFF58DB72), Color(0xFF159C48)], icon: Icons.emoji_people_rounded),
    GameRoom(name: 'INICIANTE II', entryFee: 200, minBalance: 0, players: 180, colors: <Color>[Color(0xFF64D5A2), Color(0xFF2A8B90)], icon: Icons.face_3_rounded),
    GameRoom(name: 'INTERMEDIO I', entryFee: 500, minBalance: 0, players: 574, colors: <Color>[Color(0xFF5DB7E8), Color(0xFF326BA7)], icon: Icons.style_rounded),
    GameRoom(name: 'INTERMEDIO II', entryFee: 2000, minBalance: 0, players: 536, colors: <Color>[Color(0xFF9C75D8), Color(0xFF623B9B)], icon: Icons.savings_rounded),
    GameRoom(name: 'AVANZADO I', entryFee: 5000, minBalance: 10000, players: 165, colors: <Color>[Color(0xFFC34873), Color(0xFF79203E)], icon: Icons.lock_rounded),
    GameRoom(name: 'AVANZADO II', entryFee: 10000, minBalance: 40000, players: 50, colors: <Color>[Color(0xFFB33B63), Color(0xFF61142E)], icon: Icons.lock_rounded),
    GameRoom(name: 'ROYALE PRO', entryFee: 25000, minBalance: 100000, players: 46, colors: <Color>[Color(0xFF28305C), Color(0xFF11152F)], icon: Icons.workspace_premium_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  Future<void> _selectRoom(GameRoom room) async {
    final bool locked = _profile.coins < room.minBalance || _profile.coins < room.entryFee;
    if (locked) {
      await showDialog<void>(context: context, builder: (BuildContext context) => AlertDialog(title: const Text('Sala bloqueada'), content: Text('Necesitas al menos ${room.minBalance > room.entryFee ? room.minBalance : room.entryFee} monedas para entrar.'), actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))]));
      return;
    }

    final bool? accepted = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(room.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(room.icon, size: 72, color: const Color(0xFFFFB000)),
              const SizedBox(height: 12),
              const Text('VALOR DE LA PARTIDA', style: TextStyle(fontWeight: FontWeight.w900)),
              Text('${room.entryFee} monedas', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFFFFB000))),
              const SizedBox(height: 8),
              Text('Saldo actual: ${_profile.coins}'),
              const SizedBox(height: 8),
              const Text('Los créditos se descontarán al inicio de la partida.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Jugar')),
          ],
        );
      },
    );
    if (accepted != true || !mounted) return;

    final int? target = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('¿A cuántos puntos será la partida?', textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                for (final int points in <int>[50, 100, 200]) ...<Widget>[
                  FilledButton(onPressed: () => Navigator.pop(sheetContext, points), child: Text('$points puntos')),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
    if (target == null || !mounted) return;
    _profile = await _store.debit(_profile, room.entryFee);
    if (!mounted) return;
    final PlayerProfile? returned = await Navigator.of(context).push<PlayerProfile>(
      MaterialPageRoute<PlayerProfile>(
        builder: (_) => GameScreen(profile: _profile, mode: widget.mode, targetPoints: target, entryFee: room.entryFee, online: widget.online),
      ),
    );
    if (returned != null && mounted) setState(() => _profile = returned);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoyaleHeader(title: widget.mode.toUpperCase(), coins: _profile.coins, showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                Text(widget.online ? 'JUGAR ONLINE' : 'ENTRENAMIENTO', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const Text('Disputa créditos virtuales y progresa en el ranking.', style: TextStyle(color: Colors.white60)),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _rooms.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.15, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (BuildContext context, int index) {
              final GameRoom room = _rooms[index];
              final bool locked = _profile.coins < room.minBalance || _profile.coins < room.entryFee;
              return _RoomCard(room: room, locked: locked, onTap: () => _selectRoom(room));
            },
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.locked, required this.onTap});
  final GameRoom room;
  final bool locked;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(gradient: LinearGradient(colors: room.colors), borderRadius: BorderRadius.circular(18)),
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topRight, child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Text('${room.players} '), const Icon(Icons.person, size: 17)])),
              Center(child: Icon(locked ? Icons.lock_rounded : room.icon, size: 58, color: Colors.white70)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(room.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text(room.minBalance > 0 ? 'Saldo mín. ${room.minBalance}' : '${room.entryFee} monedas', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
