import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract class BackendService {
  bool get isAvailable;

  Future<bool> initialize();

  Future<FirebaseFirestore?> firestore();
}

class FirebaseBackendService implements BackendService {
  FirebaseBackendService._();

  static final FirebaseBackendService instance = FirebaseBackendService._();

  Future<bool>? _initialization;
  bool _available = false;
  bool _firestoreConfigured = false;

  @override
  bool get isAvailable => _available;

  @override
  Future<bool> initialize() {
    return _initialization ??= _initialize();
  }

  Future<bool> _initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        final options = FirebaseRuntimeOptions.currentPlatform;
        if (options != null) {
          await Firebase.initializeApp(options: options);
        } else {
          await Firebase.initializeApp();
        }
      }

      _configureFirestore();
      _available = true;
      return true;
    } catch (error) {
      _available = false;
      debugPrint('Firebase disabled: $error');
      return false;
    }
  }

  @override
  Future<FirebaseFirestore?> firestore() async {
    final initialized = await initialize();
    if (!initialized) {
      return null;
    }

    await _ensureAnonymousSession();
    return FirebaseFirestore.instance;
  }

  void _configureFirestore() {
    if (_firestoreConfigured) {
      return;
    }

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    _firestoreConfigured = true;
  }

  Future<User?> _ensureAnonymousSession() async {
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        return auth.currentUser;
      }

      final credential = await auth.signInAnonymously();
      return credential.user;
    } catch (error) {
      debugPrint('Firebase anonymous auth unavailable: $error');
      return null;
    }
  }
}

class FirebaseRuntimeOptions {
  const FirebaseRuntimeOptions._();

  static FirebaseOptions? get currentPlatform {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

    if (apiKey.isEmpty ||
        appId.isEmpty ||
        messagingSenderId.isEmpty ||
        projectId.isEmpty) {
      return null;
    }

    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
      iosClientId: String.fromEnvironment('FIREBASE_IOS_CLIENT_ID'),
      androidClientId: String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID'),
    );
  }
}
