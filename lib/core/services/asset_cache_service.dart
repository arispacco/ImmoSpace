import 'dart:io';
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
