import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/profile_store.dart';
import '../../core/session_store.dart';
import '../auth/login_screen.dart';
import '../lobby/play_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  double _progress = 0;
  String _status = 'Preparando la mesa...';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 38), _tick);
  }

  Future<void> _tick(Timer timer) async {
    if (!mounted) return;
    setState(() {
      _progress = (_progress + 0.018).clamp(0.0, 1.0).toDouble();
      if (_progress > 0.72) {
        _status = 'Entrando al club...';
      } else if (_progress > 0.35) {
        _status = 'Barajando las fichas...';
      }
    });
    if (_progress >= 1) {
      timer.cancel();
      final SessionData? session = await SessionStore().readPersistentSession();
      if (!mounted) return;
      if (session == null) {
        await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
      } else {
        final PlayerProfile profile = await ProfileStore().load(displayName: session.displayName, provider: session.provider, isGuest: false);
        if (!mounted) return;
        await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => PlaySelectionScreen(profile: profile)));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/images/splash_art.jpg', fit: BoxFit.cover, alignment: Alignment.topCenter),
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Colors.transparent, Color(0x4407111F), Color(0xFF07111F)], stops: <double>[0.48, 0.72, 0.86]))),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_status, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ClipRRect(borderRadius: BorderRadius.circular(18), child: LinearProgressIndicator(value: _progress, minHeight: 14, color: const Color(0xFFFFB000), backgroundColor: Colors.white24)),
                    const SizedBox(height: 8),
                    Text('${(_progress * 100).round()}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const Text('Nexo Games • v2.0.0', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
