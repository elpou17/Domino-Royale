import 'package:shared_preferences/shared_preferences.dart';

class PlayerProfile {
  const PlayerProfile({
    required this.displayName,
    required this.provider,
    required this.isGuest,
    required this.coins,
    required this.level,
    required this.vipLevel,
    required this.dailyStreak,
    required this.lastBonusDate,
    required this.matchesPlayed,
    required this.matchesWon,
  });

  final String displayName;
  final String provider;
  final bool isGuest;
  final int coins;
  final int level;
  final int vipLevel;
  final int dailyStreak;
  final String lastBonusDate;
  final int matchesPlayed;
  final int matchesWon;

  PlayerProfile copyWith({
    String? displayName,
    String? provider,
    bool? isGuest,
    int? coins,
    int? level,
    int? vipLevel,
    int? dailyStreak,
    String? lastBonusDate,
    int? matchesPlayed,
    int? matchesWon,
  }) {
    return PlayerProfile(
      displayName: displayName ?? this.displayName,
      provider: provider ?? this.provider,
      isGuest: isGuest ?? this.isGuest,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      vipLevel: vipLevel ?? this.vipLevel,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastBonusDate: lastBonusDate ?? this.lastBonusDate,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      matchesWon: matchesWon ?? this.matchesWon,
    );
  }
}

class ProfileStore {
  static const String _coinsKey = 'profile_coins';
  static const String _levelKey = 'profile_level';
  static const String _vipKey = 'profile_vip';
  static const String _streakKey = 'daily_streak';
  static const String _lastBonusKey = 'last_bonus_date';
  static const String _playedKey = 'matches_played';
  static const String _wonKey = 'matches_won';

  Future<PlayerProfile> load({
    required String displayName,
    required String provider,
    required bool isGuest,
  }) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return PlayerProfile(
      displayName: displayName,
      provider: provider,
      isGuest: isGuest,
      coins: preferences.getInt(_coinsKey) ?? 3232,
      level: preferences.getInt(_levelKey) ?? 5,
      vipLevel: preferences.getInt(_vipKey) ?? 1,
      dailyStreak: preferences.getInt(_streakKey) ?? 0,
      lastBonusDate: preferences.getString(_lastBonusKey) ?? '',
      matchesPlayed: preferences.getInt(_playedKey) ?? 0,
      matchesWon: preferences.getInt(_wonKey) ?? 0,
    );
  }

  Future<void> save(PlayerProfile profile) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_coinsKey, profile.coins);
    await preferences.setInt(_levelKey, profile.level);
    await preferences.setInt(_vipKey, profile.vipLevel);
    await preferences.setInt(_streakKey, profile.dailyStreak);
    await preferences.setString(_lastBonusKey, profile.lastBonusDate);
    await preferences.setInt(_playedKey, profile.matchesPlayed);
    await preferences.setInt(_wonKey, profile.matchesWon);
  }

  String todayKey() {
    final DateTime now = DateTime.now();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  bool canClaimDailyBonus(PlayerProfile profile) {
    return profile.lastBonusDate != todayKey();
  }

  Future<PlayerProfile> claimDailyBonus(PlayerProfile profile) async {
    if (!canClaimDailyBonus(profile)) {
      return profile;
    }
    final int nextStreak = profile.dailyStreak >= 5 ? 1 : profile.dailyStreak + 1;
    final int reward = nextStreak * 100;
    final PlayerProfile updated = profile.copyWith(
      dailyStreak: nextStreak,
      coins: profile.coins + reward,
      lastBonusDate: todayKey(),
    );
    await save(updated);
    return updated;
  }

  Future<PlayerProfile> debit(PlayerProfile profile, int amount) async {
    final PlayerProfile updated = profile.copyWith(coins: profile.coins - amount);
    await save(updated);
    return updated;
  }

  Future<PlayerProfile> credit(PlayerProfile profile, int amount) async {
    final PlayerProfile updated = profile.copyWith(coins: profile.coins + amount);
    await save(updated);
    return updated;
  }

  Future<PlayerProfile> registerMatch(
    PlayerProfile profile, {
    required bool won,
    required int reward,
  }) async {
    final PlayerProfile updated = profile.copyWith(
      coins: profile.coins + reward,
      matchesPlayed: profile.matchesPlayed + 1,
      matchesWon: profile.matchesWon + (won ? 1 : 0),
    );
    await save(updated);
    return updated;
  }
}
