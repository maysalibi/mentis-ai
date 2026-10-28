import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/theme.dart";
import "../../core/widgets.dart";
import "../../services/auth_service.dart";

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: NeuralBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const LogoBadge(height: 40),
                TextButton(
                    onPressed: () => context.go("/auth/login"),
                    child: const Text("Sign In")),
              ]),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: Brand.cyan.withValues(alpha: .5)),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text("The future of human-AI knowledge collaboration",
                    style: TextStyle(color: Brand.cyan, fontSize: 12)),
              ),
              const SizedBox(height: 20),
              Text("An intelligent research environment, not a chatbot",
                  style: t.headlineLarge
                      ?.copyWith(color: Colors.white, fontSize: 38, height: 1.15)),
              const SizedBox(height: 16),
              const Text(
                  "Mentis AI helps you understand research papers, connect concepts, "
                  "and learn more effectively.",
                  style: TextStyle(color: Brand.mutedText, fontSize: 16, height: 1.5)),
              const SizedBox(height: 32),
              GradientButton(
                  label: "Enter the Workspace",
                  onPressed: () => context.go("/auth/register")),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Brand.cyan.withValues(alpha: .5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                onPressed: () => ref.read(demoModeProvider.notifier).state = true,
                child: const Text("Explore the Demo Library"),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text("Learn deeper · Research smarter · Discover more",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Brand.mutedText, fontSize: 12)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
