import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../core/theme.dart";
import "../../services/auth_service.dart";

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<AppShell> {
  int _i = 0;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final demo = ref.watch(demoModeProvider);
    final pages = <Widget>[
      _Home(user: user, demo: demo),
      const _Pending("Papers"),
      const _Pending("Assistant"),
      const _Pending("Learning"),
      _Profile(user: user, demo: demo),
    ];
    return Scaffold(
      body: SafeArea(child: pages[_i]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (v) => setState(() => _i = v),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: "Home"),
          NavigationDestination(icon: Icon(Icons.article_outlined), label: "Papers"),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: "Assistant"),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: "Learning"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({required this.user, required this.demo});
  final User? user;
  final bool demo;
  @override
  Widget build(BuildContext context) {
    final name = (user?.displayName?.isNotEmpty ?? false)
        ? user!.displayName!
        : (user?.email ?? "Explorer");
    return ListView(padding: const EdgeInsets.all(20), children: [
      if (demo)
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              color: Brand.amber.withValues(alpha: .2), borderRadius: BorderRadius.circular(12)),
          child: const Text("Demo mode: you are not signed in. Nothing is saved."),
        ),
      Text("Welcome back, $name", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8),
      const Text("Dashboard data, papers, notes and the other screens are the next build phase."),
    ]);
  }
}

class _Profile extends ConsumerWidget {
  const _Profile({required this.user, required this.demo});
  final User? user;
  final bool demo;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(user?.displayName ?? "Demo visitor",
              style: Theme.of(context).textTheme.headlineMedium),
          Text(user?.email ?? "Not signed in"),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              ref.read(demoModeProvider.notifier).state = false;
              await ref.read(authServiceProvider).signOut();
            },
            child: Text(demo ? "Leave demo" : "Sign out"),
          ),
        ],
      );
}

class _Pending extends StatelessWidget {
  const _Pending(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text("$title: not built yet (planned for the next phase).",
              textAlign: TextAlign.center),
        ),
      );
}
