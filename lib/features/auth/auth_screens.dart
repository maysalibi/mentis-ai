import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/theme.dart";
import "../../core/widgets.dart";
import "../../services/auth_service.dart";

class _AuthFrame extends StatelessWidget {
  const _AuthFrame({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Theme(
        data: buildTheme(Brightness.dark),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: NeuralBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  IconButton(
                      onPressed: () =>
                          context.canPop() ? context.pop() : context.go("/"),
                      icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const SizedBox(height: 8),
                  const LogoBadge(height: 44),
                  const SizedBox(height: 28),
                  Builder(
                    builder: (c) => Text(title,
                        style: Theme.of(c)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: 24),
                  ...children,
                ]),
              ),
            ),
          ),
        ),
      );
}

mixin _Busy<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool busy = false;
  String? error;
  Future<bool> run(Future<void> Function() fn) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await fn();
      return true;
    } on AuthException catch (e) {
      if (mounted) setState(() => error = e.message);
      return false;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget errorBox() => error == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(error!, style: const TextStyle(color: Color(0xFFFF8A80))));
}

String? _email(String? v) =>
    (v == null || !RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v.trim()))
        ? "Enter a valid email address"
        : null;

Widget _pwField(TextEditingController c, String label, bool hide, VoidCallback toggle,
        String? Function(String?) v) =>
    TextFormField(
      controller: c,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
            icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
            onPressed: toggle),
      ),
      validator: v,
    );

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginScreen> with _Busy {
  final _key = GlobalKey<FormState>();
  final _mail = TextEditingController();
  final _pw = TextEditingController();
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    return _AuthFrame(title: "Welcome back", children: [
      Form(
        key: _key,
        child: Column(children: [
          TextFormField(
              controller: _mail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
              validator: _email),
          const SizedBox(height: 14),
          _pwField(_pw, "Password", _hide, () => setState(() => _hide = !_hide),
              (v) => (v == null || v.isEmpty) ? "Enter your password" : null),
        ]),
      ),
      Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () => context.push("/auth/forgot"),
              child: const Text("Forgot password?"))),
      errorBox(),
      GradientButton(
        label: "Sign In",
        loading: busy,
        onPressed: () {
          if (_key.currentState!.validate()) {
            run(() => auth.signIn(_mail.text, _pw.text));
          }
        },
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: .3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        onPressed: busy ? null : () => run(auth.signInWithGoogle),
        icon: const Icon(Icons.account_circle_outlined),
        label: const Text("Continue with Google"),
      ),
      const SizedBox(height: 8),
      Center(
          child: TextButton(
              onPressed: () => context.go("/auth/register"),
              child: const Text("Create Account"))),
    ]);
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<RegisterScreen> with _Busy {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mail = TextEditingController();
  final _pw = TextEditingController();
  final _pw2 = TextEditingController();
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    void toggle() => setState(() => _hide = !_hide);
    return _AuthFrame(title: "Create your account", children: [
      Form(
        key: _key,
        child: Column(children: [
          TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: "Full name"),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? "Enter your name" : null),
          const SizedBox(height: 14),
          TextFormField(
              controller: _mail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
              validator: _email),
          const SizedBox(height: 14),
          _pwField(_pw, "Password", _hide, toggle,
              (v) => (v == null || v.length < 8) ? "Use at least 8 characters" : null),
          const SizedBox(height: 14),
          _pwField(_pw2, "Confirm password", _hide, toggle,
              (v) => v != _pw.text ? "Passwords do not match" : null),
        ]),
      ),
      const SizedBox(height: 16),
      errorBox(),
      GradientButton(
        label: "Create Account",
        loading: busy,
        onPressed: () {
          if (_key.currentState!.validate()) {
            run(() => auth.register(_name.text, _mail.text, _pw.text));
          }
        },
      ),
      const SizedBox(height: 8),
      Center(
          child: TextButton(
              onPressed: () => context.go("/auth/login"),
              child: const Text("I already have an account"))),
    ]);
  }
}

class ForgotScreen extends ConsumerStatefulWidget {
  const ForgotScreen({super.key});
  @override
  ConsumerState<ForgotScreen> createState() => _ForgotState();
}

class _ForgotState extends ConsumerState<ForgotScreen> with _Busy {
  final _key = GlobalKey<FormState>();
  final _mail = TextEditingController();
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    return _AuthFrame(title: "Reset your password", children: [
      Form(
        key: _key,
        child: TextFormField(
            controller: _mail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Email"),
            validator: _email),
      ),
      const SizedBox(height: 16),
      errorBox(),
      if (sent)
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
              "If an account exists for that address, a reset email has been sent.",
              style: TextStyle(color: Brand.emerald)),
        ),
      GradientButton(
        label: "Send reset email",
        loading: busy,
        onPressed: () async {
          if (!_key.currentState!.validate()) return;
          final ok = await run(() => auth.sendReset(_mail.text));
          if (ok && mounted) setState(() => sent = true);
        },
      ),
    ]);
  }
}
