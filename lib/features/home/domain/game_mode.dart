import 'package:flutter/material.dart';

class GameMode {
  const GameMode({required this.id, required this.title, required this.subtitle, required this.icon, required this.onlinePlayers});
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int onlinePlayers;
}

const gameModes = <GameMode>[
  GameMode(id: 'classic', title: 'Dominó Clásico', subtitle: 'Cuatro jugadores · por parejas', icon: Icons.grid_view_rounded, onlinePlayers: 2691),
  GameMode(id: 'duel', title: 'Mano a Mano', subtitle: 'Duelo estratégico 1 contra 1', icon: Icons.people_alt_rounded, onlinePlayers: 842),
  GameMode(id: 'open', title: 'Dominó Abierto', subtitle: 'Información visible y ritmo táctico', icon: Icons.visibility_rounded, onlinePlayers: 57),
];
