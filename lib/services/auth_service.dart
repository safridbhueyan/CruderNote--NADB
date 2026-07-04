import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around FirebaseAuth that also maintains a matching
/// `users/{uid}` document in Firestore on first sign-in.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream that emits whenever the signed-in user changes. Useful for
  /// routing: signed in → show notes list, signed out → show auth screen.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Sign in with email + password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Create a brand-new account, then ensure a profile document exists.
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _ensureUserDocument(credential.user);
    return credential;
  }

  /// Sign out and forget the cached credentials.
  Future<void> signOut() => _auth.signOut();

  /// Display name fallback: prefer the auth display name, then email prefix.
  String displayName(User user) {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    final email = user.email ?? '';
    final at = email.indexOf('@');
    return at > 0 ? email.substring(0, at) : email;
  }

  Future<void> _ensureUserDocument(User? user) async {
    if (user == null) return;
    final ref = _db.collection('users').doc(user.uid);
    await ref.set({
      'email': user.email ?? '',
      'displayName': displayName(user),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
