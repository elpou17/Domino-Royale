import 'package:flutter/material.dart';

class RoyaleHeader extends StatelessWidget implements PreferredSizeWidget {
  const RoyaleHeader({
    super.key,
    required this.title,
    required this.coins,
    this.showBack = false,
    this.onMenu,
  });

  final String title;
  final int coins;
  final bool showBack;
  final VoidCallback? onMenu;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      toolbarHeight: 68,
      titleSpacing: 8,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
      flexibleSpace: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFB5103B), Color(0xFF3B1765)],
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFFFC247)),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.monetization_on, color: Color(0xFFFFC247), size: 22),
              const SizedBox(width: 6),
              Text('$coins', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        IconButton(
          onPressed: onMenu,
          icon: const Icon(Icons.menu_rounded, size: 34),
          tooltip: 'Menú',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
