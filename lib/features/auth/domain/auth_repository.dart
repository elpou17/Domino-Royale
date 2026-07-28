abstract interface class AuthRepository {
  Future<void> signInAsGuest();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signInWithApple();
  Future<void> signInWithFacebook();
  Future<void> signOut();
}
