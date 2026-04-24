// services/auth_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// РЎРµСЂРІРёСЃ Р°РІС‚РѕСЂРёР·Р°С†РёРё: Google Sign-In + Firebase Auth
class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keySkippedAuth = 'auth_skipped';

  bool _firebaseReady = false;
  bool get isFirebaseReady => _firebaseReady;

  final _authStateController = StreamController<User?>.broadcast();
  Stream<User?> get authStateChanges => _authStateController.stream;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  String? get displayName => currentUser?.displayName;
  String? get photoUrl => currentUser?.photoURL;

  /// РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ (РІС‹Р·С‹РІР°С‚СЊ РїРѕСЃР»Рµ Firebase.initializeApp)
  void setFirebaseReady(bool ready) {
    _firebaseReady = ready;
    _authStateController.add(_auth.currentUser);
  }

  /// РџСЂРѕРІРµСЂРєР°: РїСЂРѕС€С‘Р» Р»Рё РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ РѕРЅР±РѕСЂРґРёРЅРі (РїРµСЂРІС‹Р№ СЌРєСЂР°РЅ)
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// РћС‚РјРµС‚РёС‚СЊ РѕРЅР±РѕСЂРґРёРЅРі РєР°Рє РїСЂРѕР№РґРµРЅРЅС‹Р№
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// РџСЂРѕРІРµСЂРєР°: РѕС‚РєР°Р·Р°Р»СЃСЏ Р»Рё РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ РѕС‚ РІС…РѕРґР°
  Future<bool> hasSkippedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySkippedAuth) ?? false;
  }

  /// РћС‚РјРµС‚РёС‚СЊ, С‡С‚Рѕ РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ РѕС‚РєР°Р·Р°Р»СЃСЏ РѕС‚ РІС…РѕРґР°
  Future<void> setSkippedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySkippedAuth, true);
  }

  /// Р’С…РѕРґ С‡РµСЂРµР· Google
  Future<User?> signInWithGoogle() async {
    if (!_firebaseReady) {
      debugPrint('Firebase is not initialized');
      return null;
    }

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _authStateController.add(userCredential.user);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('вќЊ Firebase Auth: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('вќЊ Google Sign-In: $e');
      rethrow;
    }
  }

  /// Р’С‹С…РѕРґ
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _authStateController.add(null);
  }

  /// РЎР±СЂРѕСЃ С„Р»Р°РіР° "РїСЂРѕРїСѓСЃС‚РёР» РІС…РѕРґ" (С‡С‚РѕР±С‹ СЃРЅРѕРІР° РїРѕРєР°Р·Р°С‚СЊ РїСЂРµРґР»РѕР¶РµРЅРёРµ РІС…РѕРґР°)
  Future<void> clearSkippedAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySkippedAuth);
  }

  void dispose() {
    _authStateController.close();
  }
}

