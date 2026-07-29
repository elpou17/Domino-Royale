import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import '../../core/session_store.dart';
import '../lobby/play_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _busy = false;

  Future<void> _enter({required String provider, required bool isGuest}) async {
    if (_busy) return;
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final String name = isGuest ? 'Invitado Royale' : 'Jugador $provider';
    if (!isGuest) {
      await SessionStore().savePersistentSession(displayName: name, provider: provider);
    }
    final PlayerProfile profile = await ProfileStore().load(
      displayName: name,
      provider: provider,
      isGuest: isGuest,
    );
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => PlaySelectionScreen(profile: profile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF111E3A), Color(0xFF050B17)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(Icons.workspace_premium_rounded, size: 92, color: Color(0xFFFFB000)),
                    const Text('DOMINO\nROYALE', textAlign: TextAlign.center, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, height: 0.95)),
                    const SizedBox(height: 12),
                    const Text('Inicia sesión para continuar', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 34),
                    _AuthButton(label: 'Continuar con Google', icon: Icons.g_mobiledata_rounded, background: Colors.white, foreground: Colors.black, onPressed: _busy ? null : () => _enter(provider: 'Google', isGuest: false)),
                    const SizedBox(height: 12),
                    _AuthButton(label: 'Continuar con Facebook', icon: Icons.facebook_rounded, background: const Color(0xFF1877F2), foreground: Colors.white, onPressed: _busy ? null : () => _enter(provider: 'Facebook', isGuest: false)),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _enter(provider: 'Invitado', isGuest: true),
                      icon: const Icon(Icons.person_outline_rounded),
                      label: const Text('Jugar como invitado'),
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFA000)),
                    ),
                    if (_busy) const Padding(padding: EdgeInsets.only(top: 20), child: LinearProgressIndicator()),
                    const SizedBox(height: 24),
                    const Text('Los accesos sociales están listos como flujo visual; Firebase se conecta en la fase online.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
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

class _AuthButton extends StatelessWidget {
  const _AuthButton({required this.label, required this.icon, required this.background, required this.foreground, required this.onPressed});
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(label),
      style: FilledButton.styleFrom(backgroundColor: background, foregroundColor: foreground),
    );
  }
}
