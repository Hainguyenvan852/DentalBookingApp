import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String address,
    required String fullName,
    required String password,
    required String dob,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.updateDisplayName(fullName);

    await cred.user?.sendEmailVerification();

    try{
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user?.uid,
        'role': 'patient',
        'email': email,
        'fullName': fullName,
        'dob': dob,
        'address': address,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true
      });
    }catch (e, st) {
      log('Create user doc failed: $e', stackTrace: st);
      rethrow;
    }


  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendResetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<Map<String, dynamic>?> loadProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }

  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  User? get currentUser => _auth.currentUser;
}
