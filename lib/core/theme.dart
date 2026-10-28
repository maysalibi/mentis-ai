import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class Brand {
  static const indigo = Color(0xFF243B6B);
  static const cyan = Color(0xFF22C7D9);
  static const emerald = Color(0xFF22A06B);
  static const navy = Color(0xFF162544);
  static const midnight = Color(0xFF0E1A33);
  static const surface = Color(0xFF1B2D52);
  static const neutral = Color(0xFFF5F7FB);
  static const amber = Color(0xFFF0B44D);
  static const mutedText = Color(0xFF9AA8C4);
  static const gradient = LinearGradient(colors: [indigo, cyan]);
}

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.indigo,
    brightness: b,
    primary: dark ? Brand.cyan : Brand.indigo,
    secondary: Brand.cyan,
  );
  final base = ThemeData(brightness: b, colorScheme: scheme, useMaterial3: true);
  final text = GoogleFonts.interTextTheme(base.textTheme).apply(
    bodyColor: dark ? Colors.white : Brand.navy,
    displayColor: dark ? Colors.white : Brand.navy,
  );
  return base.copyWith(
    scaffoldBackgroundColor: dark ? Brand.midnight : Brand.neutral,
    textTheme: text.copyWith(
      headlineLarge: GoogleFonts.newsreader(
          textStyle: text.headlineLarge, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.newsreader(
          textStyle: text.headlineMedium, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? Brand.surface : Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.blueGrey.withValues(alpha: .3))),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? Brand.navy : Colors.white,
      indicatorColor: Brand.cyan.withValues(alpha: .2),
    ),
  );
}
