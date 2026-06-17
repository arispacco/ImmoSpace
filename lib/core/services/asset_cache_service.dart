import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AssetCacheService {
  static final AssetCacheService _instance = AssetCacheService._internal();
  factory AssetCacheService() => _instance;
  AssetCacheService._internal();

  /// Gets the local path for an asset. If it's a remote URL, downloads and caches it.
  /// If it's already cached, returns the cached file path immediately.
  /// If it's a local asset path, returns it directly.
  Future<String> getLocalAssetPath(
    String urlOrPath, {
    void Function(double progress)? onProgress,
  }) async {
    // Check if it is a remote url
    if (!urlOrPath.startsWith('http://') && !urlOrPath.startsWith('https://')) {
      return urlOrPath;
    }

    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      // Extract file name from URL
      final fileName = urlOrPath.split('/').last;
      final localFile = File('${cacheDir.path}/$fileName');

      // Check if file is already cached
      if (await localFile.exists()) {
        if (kDebugMode) {
          print('AssetCacheService: Load from cache -> ${localFile.path}');
        }
        return localFile.path;
      }

      // Download file with progress tracking
      if (kDebugMode) {
        print('AssetCacheService: Downloading asset -> $urlOrPath');
      }

      final client = http.Client();
      final request = http.Request('GET', Uri.parse(urlOrPath));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw HttpException('Failed to download asset: HTTP ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? 0;
      final bytes = <int>[];
      int downloaded = 0;

      await for (var chunk in response.stream) {
        bytes.addAll(chunk);
        downloaded += chunk.length;
        if (contentLength > 0 && onProgress != null) {
          final progress = downloaded / contentLength;
          onProgress(progress);
        }
      }

      // Save to disk
      await localFile.writeAsBytes(bytes);
      if (kDebugMode) {
        print('AssetCacheService: Saved to cache -> ${localFile.path}');
      }
      return localFile.path;
    } catch (e) {
      if (kDebugMode) {
        print('AssetCacheService: Caching failed: $e');
      }
      // If download/cache fails, rethrow or return empty to handle fallback
      rethrow;
    }
  }

  /// Clears the entire disk cache for models
  Future<void> clearCache() async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      final dir = Directory(cacheDir.path);
      if (await dir.exists()) {
        final List<FileSystemEntity> entities = await dir.list().toList();
        for (var entity in entities) {
          if (entity is File && entity.path.endsWith('.glb')) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AssetCacheService: Failed to clear cache: $e');
      }
    }
  }
}

class FirebaseBackendService {
  FirebaseBackendService._();

  static final FirebaseBackendService instance = FirebaseBackendService._();

  Future<bool>? _initialization;
  bool _available = false;

  bool get isAvailable => _available;

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

      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );

      _available = true;
      return true;
    } catch (error) {
      _available = false;
      debugPrint('Firebase disabled: $error');
      return false;
    }
  }

  Future<FirebaseFirestore?> firestore() async {
    final initialized = await initialize();
    if (!initialized) {
      return null;
    }
    await _ensureAnonymousSession();
    return FirebaseFirestore.instance;
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
