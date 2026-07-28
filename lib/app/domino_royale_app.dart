import 'package:domino_royale/app/router.dart';
import 'package:domino_royale/app/theme.dart';
import 'package:flutter/material.dart';

class DominoRoyaleApp extends StatelessWidget {
  const DominoRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Domino Royale',
      debugShowCheckedModeBanner: false,
      theme: buildDominoTheme(),
      routerConfig: appRouter,
    );
  }
}
