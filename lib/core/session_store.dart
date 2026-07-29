import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  const SessionData({
    required this.displayName,
    required this.provider,
  });

  final String displayName;
  final String provider;
}

class SessionStore {
  static const String _signedInKey = 'signed_in';
  static const String _displayNameKey = 'display_name';
  static const String _providerKey = 'provider';

  Future<SessionData?> readPersistentSession() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    final bool signedIn = preferences.getBool(_signedInKey) ?? false;
    if (!signedIn) {
      return null;
    }

    return SessionData(
      displayName:
          preferences.getString(_displayNameKey) ?? 'Jugador Royale',
      provider: preferences.getString(_providerKey) ?? 'Cuenta',
    );
  }

  Future<void> savePersistentSession({
    required String displayName,
    required String provider,
  }) async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.setBool(_signedInKey, true);
    await preferences.setString(_displayNameKey, displayName);
    await preferences.setString(_providerKey, provider);
  }

  Future<void> signOut() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.remove(_signedInKey);
    await preferences.remove(_displayNameKey);
    await preferences.remove(_providerKey);
  }
}
