import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? firebaseError;
  try {
    // Uses android/app/google-services.json (from YOUR Firebase project).
    await Firebase.initializeApp();
  } catch (e) {
    firebaseError = e.toString();
  }
  runApp(ProviderScope(child: firebaseError == null
      ? const MentisApp()
      : ConfigMissingApp(error: firebaseError)));
}

class ConfigMissingApp extends StatelessWidget {
  const ConfigMissingApp({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Firebase is not configured.\n\nAdd android/app/google-services.json '
                'from your Firebase project (see README), then rebuild.\n\n$error',
              ),
            ),
          ),
        ),
      );
}
