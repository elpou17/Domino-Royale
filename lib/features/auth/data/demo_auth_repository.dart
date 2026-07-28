import 'package:domino_royale/features/auth/domain/auth_repository.dart';

class DemoAuthRepository implements AuthRepository {
  Future<void> _simulate() => Future<void>.delayed(const Duration(milliseconds: 450));

  @override
  Future<void> signInAsGuest() => _simulate();

  @override
  Future<void> signInWithApple() => _simulate();

  @override
  Future<void> signInWithEmail(String email, String password) async {
    if (!email.contains('@') || password.length < 6) {
      throw const FormatException('Correo o contraseña inválidos.');
    }
    await _simulate();
  }

  @override
  Future<void> signInWithFacebook() => _simulate();

  @override
  Future<void> signOut() => _simulate();
}
