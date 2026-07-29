import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import '../../core/widgets/royale_header.dart';
import '../rooms/rooms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.profile, required this.online});
  final PlayerProfile profile;
  final bool online;

  void _openRooms(BuildContext context, String mode) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => RoomsScreen(profile: profile, mode: mode, online: online),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoyaleHeader(title: online ? 'JUGAR ONLINE' : 'JUGAR CON ROBOTS', coins: profile.coins),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          Row(
            children: <Widget>[
              const CircleAvatar(radius: 26, child: Icon(Icons.person_rounded)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(profile.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    Text(profile.isGuest ? 'Invitado • progreso local' : 'Nivel ${profile.level} • ${profile.provider}', style: const TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
              Chip(avatar: const Icon(Icons.workspace_premium_rounded, size: 18), label: Text('VIP ${profile.vipLevel}')),
            ],
          ),
          const SizedBox(height: 22),
          const Text('ESCOGE UNA MODALIDAD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          _ModeCard(title: 'DOMINÓ CLÁSICO', subtitle: '4 jugadores • Parejas', players: 2273, icon: Icons.casino_rounded, colors: const <Color>[Color(0xFFF9A34D), Color(0xFFE36223)], onTap: () => _openRooms(context, 'Dominó Clásico')),
          const SizedBox(height: 14),
          _ModeCard(title: 'MANO A MANO', subtitle: '2 jugadores • Individual', players: 751, icon: Icons.sports_mma_rounded, colors: const <Color>[Color(0xFF38C6C2), Color(0xFF087F87)], onTap: () => _openRooms(context, 'Mano a Mano')),
          const SizedBox(height: 14),
          _ModeCard(title: 'DOMINÓ ABIERTO', subtitle: 'Modalidad estratégica', players: 50, icon: Icons.visibility_rounded, colors: const <Color>[Color(0xFFC272AF), Color(0xFF6A2B72)], onTap: () => _openRooms(context, 'Dominó Abierto')),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.title, required this.subtitle, required this.players, required this.icon, required this.colors, required this.onTap});
  final String title;
  final String subtitle;
  final int players;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 164,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 7),
                    Text(subtitle, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Row(children: <Widget>[const Icon(Icons.circle, size: 10, color: Colors.greenAccent), const SizedBox(width: 7), Text('$players jugando')]),
                  ],
                ),
              ),
              Icon(icon, size: 82, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
