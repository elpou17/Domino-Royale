import 'package:flutter/material.dart';

import '../../core/profile_store.dart';

Future<PlayerProfile> showDailyBonusDialog(
  BuildContext context,
  PlayerProfile profile,
) async {
  final ProfileStore store = ProfileStore();
  if (!store.canClaimDailyBonus(profile)) {
    return profile;
  }
  final int nextStreak = profile.dailyStreak >= 5 ? 1 : profile.dailyStreak + 1;
  final int reward = nextStreak * 100;
  final bool? claim = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Row(
          children: <Widget>[
            Icon(Icons.card_giftcard_rounded, color: Color(0xFFFFB000)),
            SizedBox(width: 10),
            Text('Bono diario'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.monetization_on, size: 78, color: Color(0xFFFFB000)),
            Text('Has ganado $reward monedas', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              children: List<Widget>.generate(5, (int index) {
                final int day = index + 1;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: day == nextStreak ? const Color(0xFFFFB000) : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text('Día $day', style: const TextStyle(fontSize: 11)),
                        Text('${day * 100}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        actions: <Widget>[
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Recibir bono'),
          ),
        ],
      );
    },
  );
  if (claim == true) {
    return store.claimDailyBonus(profile);
  }
  return profile;
}

Future<void> showDailyChallengesDialog(BuildContext context, PlayerProfile profile) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Desafíos diarios'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _ChallengeTile(title: 'Gana una partida', reward: 70, progress: profile.matchesWon > 0 ? 1 : 0, goal: 1),
              const _ChallengeTile(title: 'Juega 4 partidas Mano a Mano', reward: 300, progress: 0, goal: 4),
              const _ChallengeTile(title: 'Gana 3 partidas de entrenamiento', reward: 180, progress: 0, goal: 3),
              const _ChallengeTile(title: 'Completa una partida a 200 puntos', reward: 350, progress: 0, goal: 1),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cerrar')),
        ],
      );
    },
  );
}

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({required this.title, required this.reward, required this.progress, required this.goal});
  final String title;
  final int reward;
  final int progress;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final double value = goal == 0 ? 0 : progress / goal;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.emoji_events_outlined, color: Color(0xFFFFB000)),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
                Text('+$reward'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: value.clamp(0.0, 1.0).toDouble()),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: Text('$progress/$goal')),
          ],
        ),
      ),
    );
  }
}
