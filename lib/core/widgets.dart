import "dart:math";
import "package:flutter/material.dart";
import "theme.dart";

class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key, this.height = 56});
  final double height;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Image.asset("assets/images/logo.png", height: height),
      );
}

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key, required this.label, required this.onPressed, this.loading = false});
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
              gradient: Brand.gradient, borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: loading ? null : onPressed,
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(label,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      );
}

/// Lightweight connected-node motif; use only on welcome/auth/empty states.
class NeuralBackground extends StatelessWidget {
  const NeuralBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Brand.midnight, Brand.navy]),
        ),
        child: CustomPaint(painter: _NeuralPainter(), child: child),
      );
}

class _NeuralPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(7);
    final pts = List.generate(
        26, (_) => Offset(r.nextDouble() * size.width, r.nextDouble() * size.height));
    final line = Paint()
      ..color = Brand.cyan.withValues(alpha: .10)
      ..strokeWidth = 1;
    final dot = Paint()..color = Brand.cyan.withValues(alpha: .28);
    for (var i = 0; i < pts.length; i++) {
      for (var j = i + 1; j < pts.length; j++) {
        if ((pts[i] - pts[j]).distance < 130) canvas.drawLine(pts[i], pts[j], line);
      }
      canvas.drawCircle(pts[i], 2.2, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
