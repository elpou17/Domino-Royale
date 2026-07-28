import 'package:domino_royale/features/auth/presentation/login_screen.dart';
import 'package:domino_royale/features/game/presentation/game_screen.dart';
import 'package:domino_royale/features/game/presentation/lobby_screen.dart';
import 'package:domino_royale/features/home/presentation/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/lobby/:mode',
      builder: (_, state) => LobbyScreen(mode: state.pathParameters['mode']!),
    ),
    GoRoute(
      path: '/game/:mode/:target',
      builder: (_, state) => GameScreen(
        mode: state.pathParameters['mode']!,
        targetScore: int.parse(state.pathParameters['target']!),
      ),
    ),
  ],
);
