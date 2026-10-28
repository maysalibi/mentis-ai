import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "core/theme.dart";
import "features/auth/auth_screens.dart";
import "features/onboarding/welcome_screen.dart";
import "features/shell/shell.dart";
import "services/auth_service.dart";

final routerProvider = Provider<GoRouter>((ref) {
  final tick = ValueNotifier(0);
  ref.listen(authStateProvider, (_, __) => tick.value++);
  ref.listen(demoModeProvider, (_, __) => tick.value++);
  return GoRouter(
    refreshListenable: tick,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final demo = ref.read(demoModeProvider);
      if (auth.isLoading && !demo) return null;
      final inApp = auth.valueOrNull != null || demo;
      final loc = state.matchedLocation;
      final isPublic = loc == "/" || loc.startsWith("/auth");
      if (!inApp && !isPublic) return "/";
      if (inApp && isPublic) return "/home";
      return null;
    },
    routes: [
      GoRoute(path: "/", builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: "/auth/login", builder: (_, __) => const LoginScreen()),
      GoRoute(path: "/auth/register", builder: (_, __) => const RegisterScreen()),
      GoRoute(path: "/auth/forgot", builder: (_, __) => const ForgotScreen()),
      GoRoute(path: "/home", builder: (_, __) => const AppShell()),
    ],
  );
});

class MentisApp extends ConsumerWidget {
  const MentisApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        title: "Mentis AI",
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: ThemeMode.system, // TODO: persist user choice
        routerConfig: ref.watch(routerProvider),
      );
}
