import 'package:domino_royale/features/game/domain/domino_tile.dart';
import 'package:flutter/material.dart';

class DominoTileWidget extends StatelessWidget {
  const DominoTileWidget({required this.tile, this.selected = false, this.onTap, super.key});
  final DominoTile tile;
  final bool selected;
  final VoidCallback? onTap;

  Widget _half(int value) => Expanded(child: Center(child: Text('$value', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold))));

  @override
  Widget build(BuildContext context) => AnimatedScale(
    scale: selected ? 1.08 : 1,
    duration: const Duration(milliseconds: 150),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48, height: 92,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? const Color(0xFFFFC857) : Colors.black26, width: selected ? 3 : 1)),
        child: Column(children: [_half(tile.left), const Divider(height: 1, color: Colors.black54), _half(tile.right)]),
      ),
    ),
  );
}
