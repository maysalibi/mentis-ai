import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _google = GoogleSignIn();

  Stream<User?> get changes => _auth.authStateChanges();

  Future<void> _ensureProfile(User u, {String? name}) async {
    final ref = _db.collection("users").doc(u.uid);
    final snap = await ref.get();
    if (snap.exists) return;
    await ref.set({
      "uid": u.uid,
      "email": u.email ?? "",
      "displayName": name ?? u.displayName ?? "",
      "preferredLevel": "intermediate",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> register(String name, String email, String password) =>
      _run(() async {
        final c = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
        await c.user!.updateDisplayName(name.trim());
        await _ensureProfile(c.user!, name: name.trim());
        await c.user!.sendEmailVerification();
      });

  Future<void> signIn(String email, String password) => _run(() async {
        final c = await _auth.signInWithEmailAndPassword(
            email: email.trim(), password: password);
        await _ensureProfile(c.user!);
      });

  Future<void> sendReset(String email) =>
      _run(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> signInWithGoogle() => _run(() async {
        final acct = await _google.signIn();
        if (acct == null) throw AuthException("Google sign-in was cancelled.");
        final tok = await acct.authentication;
        final cred = GoogleAuthProvider.credential(
            accessToken: tok.accessToken, idToken: tok.idToken);
        final c = await _auth.signInWithCredential(cred);
        await _ensureProfile(c.user!);
      });

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e));
    } catch (e) {
      throw AuthException("Something went wrong: $e");
    }
  }

  String _friendly(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        return "An account already exists for this email.";
      case "invalid-email":
        return "That email address is not valid.";
      case "weak-password":
        return "Password must be at least 6 characters.";
      case "user-not-found":
      case "wrong-password":
      case "invalid-credential":
        return "Incorrect email or password.";
      case "network-request-failed":
        return "No network connection.";
      case "account-exists-with-different-credential":
        return "This email is registered with another sign-in method. Sign in "
            "with that method first; account linking is a planned step.";
      default:
        return e.message ?? "Authentication failed (${e.code}).";
    }
  }
}

final authServiceProvider = Provider((_) => AuthService());
final authStateProvider =
    StreamProvider<User?>((ref) => ref.watch(authServiceProvider).changes);
final demoModeProvider = StateProvider<bool>((_) => false);
