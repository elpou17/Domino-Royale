import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';

class DominoRoyaleApp extends StatelessWidget {
  const DominoRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFB000),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Domino Royale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF07111F), centerTitle: false),
        cardTheme: const CardThemeData(clipBehavior: Clip.antiAlias, margin: EdgeInsets.zero),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF101C2B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
