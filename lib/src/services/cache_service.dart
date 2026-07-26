import 'dart:async';

import 'package:dorar_hadith/src/database/cache_database.dart';
import 'package:dorar_hadith/src/models/cache_entry.dart';
import 'package:drift/drift.dart';

class CacheService implements CacheStore {
  /// Bump when cached response body semantics change (e.g. hadith text cleaning).
  ///
  /// Keys are stored as `v{formatVersion}:…`, so older payloads are ignored
  /// immediately after upgrade instead of being served until TTL expiry.
  static const int formatVersion = 2;

  static const int _maintenanceInterval = 50;

  final CacheDatabase database;
  final Duration defaultTtl;
  final int maxCacheSize;
  final int maxSqliteRows;
  final InMemoryCacheManager _cacheManager;
  var _writesSinceMaintenance = 0;

  CacheService({
    required this.database,
    this.defaultTtl = const Duration(days: 7),
    this.maxCacheSize = 100,
    this.maxSqliteRows = 750,
    InMemoryCacheManager? cacheManager,
  }) : _cacheManager =
           cacheManager ??
           InMemoryCacheManager(defaultTtl: defaultTtl, maxSize: maxCacheSize) {
    unawaited(database.clearExpiredCache());
  }

  String _scopedKey(String key) => 'v$formatVersion:$key';

  CacheEntry _withScopedKey(CacheEntry entry) => CacheEntry(
    key: _scopedKey(entry.key),
    body: entry.body,
    header: entry.header,
    createdAt: entry.createdAt,
    expiresAt: entry.expiresAt,
  );

  @override
  Future<void> clear() async {
    _cacheManager.clear();
    await database.clear();
  }

  Future<void> dispose() async {
    _cacheManager.clear();
    await database.close();
  }

  @override
  Future<CacheEntry?> get(String key) {
    final scoped = _scopedKey(key);
    final memoryEntry = _cacheManager.get(scoped);
    if (memoryEntry != null) {
      return Future.value(
        CacheEntry(
          key: key,
          body: memoryEntry.body,
          header: memoryEntry.header,
          createdAt: memoryEntry.createdAt,
          expiresAt: memoryEntry.expiresAt,
        ),
      );
    }

    final dbEntryFuture = database.getCacheEntry(scoped);
    return dbEntryFuture.then((dbEntry) {
      if (dbEntry == null) return null;
      if (dbEntry.expiredAt.isBefore(DateTime.now())) {
        database.deleteCacheEntry(scoped);
        return null;
      }
      final entry = CacheEntry(
        key: key,
        body: dbEntry.body,
        header: dbEntry.header,
        createdAt: dbEntry.createdAt,
        expiresAt: dbEntry.expiredAt,
      );
      _cacheManager.set(_withScopedKey(entry));
      return entry;
    });
  }

  @override
  Future<void> remove(String key) {
    final scoped = _scopedKey(key);
    _cacheManager.remove(scoped);
    return database.deleteCacheEntry(scoped);
  }

  @override
  Future<void> set(CacheEntry entry) async {
    final scoped = _withScopedKey(entry);
    _cacheManager.set(scoped);
    final dbEntry = CacheTableCompanion(
      key: Value(scoped.key),
      body: Value(scoped.body),
      header: Value(scoped.header),
      createdAt: Value(scoped.createdAt),
      expiredAt: Value(scoped.expiresAt),
    );
    await database.insertOrUpdateCacheEntry(dbEntry);
    await _enforceSqliteRowCap(excludeKey: scoped.key);
    _writesSinceMaintenance++;
    if (_writesSinceMaintenance >= _maintenanceInterval) {
      _writesSinceMaintenance = 0;
      await database.clearExpiredCache();
    }
  }

  Future<void> _enforceSqliteRowCap({String? excludeKey}) async {
    if (maxSqliteRows <= 0) return;

    final count = await database.countCacheEntries();
    final overflow = count - maxSqliteRows;
    if (overflow <= 0) return;

    await database.evictOldestEntries(overflow, excludeKey: excludeKey);
  }
}

abstract class CacheStore {
  Future<void> clear();
  Future<CacheEntry?> get(String key);
  Future<void> remove(String key);
  Future<void> set(CacheEntry entry);
}

/// In-memory cache manager with time-to-live (TTL) support.
///
/// Example usage:
/// ```dart
/// final cache = CacheManager(defaultTtl: Duration(seconds: 5));
///
/// // Set a value
/// cache.set('key1', 'value1');
///
/// // Get a value
/// final value = cache.get('key1'); // 'value1'
///
/// // Check if key exists (and is not expired)
/// if (cache.has('key1')) {
///   print('Key exists and is valid');
/// }
///
/// // Clear all cache
/// cache.clear();
/// ```
class InMemoryCacheManager {
  /// Internal storage for cache entries
  final Map<String, CacheEntry> _cache = {};

  /// Default time-to-live for cache entries
  final Duration defaultTtl;

  /// Maximum number of entries to keep in cache
  final int? maxSize;

  InMemoryCacheManager({
    this.defaultTtl = const Duration(days: 7),
    this.maxSize,
  });

  /// Gets all cache keys (including expired entries).
  List<String> get keys => _cache.keys.toList();

  /// Gets the current number of cached entries (including expired).
  int get size => _cache.length;

  /// Gets all valid (non-expired) cache keys.
  List<String> get validKeys {
    return _cache.entries
        .where((entry) => !entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
  }

  /// Gets the number of valid (non-expired) entries.
  int get validSize {
    return _cache.values.where((entry) => !entry.isExpired).length;
  }

  /// Clears all cache entries.
  void clear() {
    _cache.clear();
  }

  /// Gets a cached value by key.
  ///
  /// Returns null if:
  /// - The key doesn't exist
  /// - The cached entry has expired
  ///
  /// Automatically removes expired entries.
  CacheEntry? get(String key) {
    final entry = _cache[key];

    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry;
  }

  /// Gets or sets a value using a factory function.
  ///
  /// If the key exists and is valid, returns the cached value.
  /// Otherwise, calls the factory function, caches the result, and returns it.
  ///
  /// Example:
  /// ```dart
  /// final result = await cache.getOrSet(
  ///   'user:123',
  ///   () async => fetchUser(123),
  ///   ttl: Duration(minutes: 5),
  /// );
  /// ```
  Future<CacheEntry> getOrSet(
    String key,
    Future Function() factory, {
    Duration? ttl,
  }) async {
    // Try to get from cache
    final cached = get(key);
    if (cached != null) {
      return cached;
    }

    // Not in cache, call factory
    final value = await factory();

    // Cache the result
    set(value, ttl: ttl);

    return value;
  }

  /// Synchronous version of getOrSet for non-async factories.
  CacheEntry getOrSetSync(
    String key,
    CacheEntry Function() factory, {
    Duration? ttl,
  }) {
    // Try to get from cache
    final cached = get(key);
    if (cached != null) {
      return cached;
    }

    // Not in cache, call factory
    final value = factory();

    // Cache the result
    set(value, ttl: ttl);

    return value;
  }

  /// Checks if a key exists and has not expired.
  bool has(String key) {
    final entry = _cache[key];

    if (entry == null) return false;

    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Removes a specific cache entry.
  void remove(String key) {
    _cache.remove(key);
  }

  /// Removes all expired entries.
  ///
  /// Returns the number of entries removed.
  int removeExpired() {
    final keysToRemove = <String>[];

    _cache.forEach((key, entry) {
      if (entry.isExpired) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      _cache.remove(key);
    }

    return keysToRemove.length;
  }

  /// Sets a cached value with an optional custom TTL.
  ///
  /// If the cache is at max size, removes the oldest entry first.
  void set(CacheEntry value, {Duration? ttl}) {
    // Remove oldest entry if at max size
    if (maxSize != null &&
        _cache.length >= maxSize! &&
        !_cache.containsKey(value.key)) {
      _removeOldest();
    }

    _cache[value.key] = value;
  }

  /// Removes the oldest cache entry.
  void _removeOldest() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    _cache.forEach((key, entry) {
      if (oldestTime == null || entry.createdAt.isBefore(oldestTime!)) {
        oldestKey = key;
        oldestTime = entry.createdAt;
      }
    });

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }
}
