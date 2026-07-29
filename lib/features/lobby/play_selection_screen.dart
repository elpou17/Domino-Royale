import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import '../../core/widgets/royale_header.dart';
import '../home/home_screen.dart';
import '../rewards/reward_dialogs.dart';

class PlaySelectionScreen extends StatefulWidget {
  const PlaySelectionScreen({super.key, required this.profile});
  final PlayerProfile profile;

  @override
  State<PlaySelectionScreen> createState() => _PlaySelectionScreenState();
}

class _PlaySelectionScreenState extends State<PlaySelectionScreen> {
  late PlayerProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showEntryRewards());
  }

  Future<void> _showEntryRewards() async {
    final PlayerProfile updated = await showDailyBonusDialog(context, _profile);
    if (!mounted) return;
    setState(() => _profile = updated);
    await showDailyChallengesDialog(context, _profile);
  }

  void _openCatalog({required bool online}) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => HomeScreen(profile: _profile, online: online),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoyaleHeader(title: 'DOMINO ROYALE', coins: _profile.coins),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF0C5C36), Color(0xFF05291B)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: <Widget>[
                    const Icon(Icons.casino_rounded, size: 110, color: Colors.white),
                    const Text('DOMINO ROYALE', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Expanded(child: const _CustomizeCard(icon: Icons.view_agenda_rounded, label: 'Fichas')),
                        const SizedBox(width: 14),
                        Expanded(child: const _CustomizeCard(icon: Icons.table_restaurant_rounded, label: 'Mesa')),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _BigActionButton(
                      label: 'JUEGA CON ROBOTS',
                      subtitle: 'Entrenamiento sin conexión',
                      icon: Icons.smart_toy_rounded,
                      colors: const <Color>[Color(0xFF20E777), Color(0xFF00A956)],
                      onTap: () => _openCatalog(online: false),
                    ),
                    const SizedBox(height: 14),
                    _BigActionButton(
                      label: 'JUGAR ONLINE',
                      subtitle: '2,273 jugadores conectados',
                      icon: Icons.public_rounded,
                      colors: const <Color>[Color(0xFF31C5EE), Color(0xFF0874B8)],
                      onTap: () => _openCatalog(online: true),
                    ),
                    const SizedBox(height: 18),
                    TextButton.icon(
                      onPressed: () => _openCatalog(online: true),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: const Text('Ver todas las salas'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomizeCard extends StatelessWidget {
  const _CustomizeCard({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white30, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(icon, size: 52), const SizedBox(height: 8), Text(label)],
      ),
    );
  }
}

class _BigActionButton extends StatelessWidget {
  const _BigActionButton({required this.label, required this.subtitle, required this.icon, required this.colors, required this.onTap});
  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          height: 86,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const <BoxShadow>[BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 5))],
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              Icon(icon, size: 42),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(label, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                    Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 34),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
