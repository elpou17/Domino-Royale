import 'package:domino_royale/core/constants.dart';
import 'package:domino_royale/features/home/domain/game_mode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.casino_rounded, color: Color(0xFFFFC857)), SizedBox(width: 8), Text('Domino Royale')]),
        actions: const [
          Chip(avatar: Icon(Icons.monetization_on, size: 18), label: Text('${AppConstants.startingCoins}')),
          SizedBox(width: 8), CircleAvatar(child: Text('MP')), SizedBox(width: 8),
        ],
      ),
      drawer: const _RoyaleDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Card(
              color: const Color(0xFF153C38),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Bienvenido a la mesa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6), Text('Selecciona una modalidad y compite hasta 50, 100 o 200 puntos.'),
                  ])),
                  FilledButton.tonalIcon(onPressed: () {}, icon: const Icon(Icons.workspace_premium), label: const Text('VIP')),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Text('Escoge un juego', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...gameModes.map((mode) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ModeCard(mode: mode, onTap: () => context.go('/lobby/${mode.id}')),
            )),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.onTap});
  final GameMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Container(width: 72, height: 72, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(22)), child: Icon(mode.icon, size: 38)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mode.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4), Text(mode.subtitle),
            const SizedBox(height: 10), Row(children: [const Icon(Icons.circle, size: 9, color: Colors.greenAccent), const SizedBox(width: 6), Text('${mode.onlinePlayers} conectados')]),
          ])),
          const Icon(Icons.chevron_right),
        ]),
      ),
    ),
  );
}

class _RoyaleDrawer extends StatelessWidget {
  const _RoyaleDrawer();
  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(child: ListView(children: [
      const UserAccountsDrawerHeader(accountName: Text('Miguel Pou'), accountEmail: Text('Jugador nivel 1'), currentAccountPicture: CircleAvatar(child: Text('MP'))),
      for (final item in const [
        (Icons.chat_bubble_outline, 'Chat entre amigos'), (Icons.person_search, 'Buscar jugadores'),
        (Icons.leaderboard_outlined, 'Clasificación'), (Icons.history, 'Historial'),
        (Icons.settings_outlined, 'Configuración'), (Icons.help_outline, 'Ayuda'),
        (Icons.support_agent, 'Soporte'), (Icons.privacy_tip_outlined, 'Política de privacidad')
      ]) ListTile(leading: Icon(item.$1), title: Text(item.$2), onTap: () => Navigator.pop(context)),
      const Divider(),
      ListTile(leading: const Icon(Icons.logout), title: const Text('Cerrar sesión'), onTap: () => context.go('/login')),
      const Padding(padding: EdgeInsets.all(16), child: Text('Domino Royale 1.0.0', textAlign: TextAlign.center)),
    ])),
  );
}
