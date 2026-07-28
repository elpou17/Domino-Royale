import 'package:domino_royale/features/auth/data/demo_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repository = DemoAuthRepository();
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function() action) async {
    setState(() { _busy = true; _error = null; });
    try {
      await action();
      if (mounted) context.go('/home');
    } on Object catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.casino_rounded, size: 86, color: Color(0xFFFFC857)),
                  const SizedBox(height: 16),
                  Text('DOMINO ROYALE', textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const Text('La mesa competitiva del Caribe', textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextField(controller: _email, keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo electrónico', prefixIcon: Icon(Icons.email_outlined))),
                  const SizedBox(height: 12),
                  TextField(controller: _password, obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline))),
                  if (_error != null) Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _busy ? null : () => _run(() => _repository.signInWithEmail(_email.text, _password.text)),
                    child: const Text('Entrar con correo'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(onPressed: _busy ? null : () => _run(_repository.signInWithApple),
                    icon: const Icon(Icons.apple), label: const Text('Continuar con Apple')),
                  OutlinedButton.icon(onPressed: _busy ? null : () => _run(_repository.signInWithFacebook),
                    icon: const Icon(Icons.facebook), label: const Text('Continuar con Facebook')),
                  TextButton(onPressed: _busy ? null : () => _run(_repository.signInAsGuest),
                    child: const Text('Jugar como invitado')),
                  if (_busy) const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
                  const SizedBox(height: 12),
                  const Text('Al continuar aceptas los Términos y la Política de Privacidad.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
