/// A cache entry with expiry support.
class CacheEntry<T> {
  /// The cached value
  final T value;

  /// When this entry was created
  final DateTime createdAt;

  /// Time-to-live for this entry
  final Duration ttl;

  CacheEntry({required this.value, required this.ttl, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  /// Checks if this cache entry has expired
  bool get isExpired {
    final now = DateTime.now();
    final expiryTime = createdAt.add(ttl);
    return now.isAfter(expiryTime);
  }

  /// Gets the remaining time until expiry
  Duration get remainingTime {
    final now = DateTime.now();
    final expiryTime = createdAt.add(ttl);
    final remaining = expiryTime.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  String toString() =>
      'CacheEntry(value: $value, expired: $isExpired, remaining: ${remainingTime.inSeconds}s)';
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
class CacheManager {
  /// Internal storage for cache entries
  final Map<String, CacheEntry> _cache = {};

  /// Default time-to-live for cache entries
  final Duration defaultTtl;

  /// Maximum number of entries to keep in cache
  final int? maxSize;

  CacheManager({this.defaultTtl = const Duration(days: 1), this.maxSize});

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
  T? get<T>(String key) {
    final entry = _cache[key];

    if (entry == null) return null;

    // Check if expired
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    // Type-safe return
    if (entry.value is T) {
      return entry.value as T;
    }

    return null;
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
  Future<T> getOrSet<T>(
    String key,
    Future<T> Function() factory, {
    Duration? ttl,
  }) async {
    // Try to get from cache
    final cached = get<T>(key);
    if (cached != null) {
      return cached;
    }

    // Not in cache, call factory
    final value = await factory();

    // Cache the result
    set(key, value, ttl: ttl);

    return value;
  }

  /// Synchronous version of getOrSet for non-async factories.
  T getOrSetSync<T>(String key, T Function() factory, {Duration? ttl}) {
    // Try to get from cache
    final cached = get<T>(key);
    if (cached != null) {
      return cached;
    }

    // Not in cache, call factory
    final value = factory();

    // Cache the result
    set(key, value, ttl: ttl);

    return value;
  }

  /// Gets cache statistics.
  CacheStats getStats() {
    final total = _cache.length;
    final valid = validSize;
    final expired = total - valid;

    return CacheStats(
      totalEntries: total,
      validEntries: valid,
      expiredEntries: expired,
      hitRate: 0.0, // Would need hit/miss tracking for this
    );
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
  void set<T>(String key, T value, {Duration? ttl}) {
    // Remove oldest entry if at max size
    if (maxSize != null &&
        _cache.length >= maxSize! &&
        !_cache.containsKey(key)) {
      _removeOldest();
    }

    _cache[key] = CacheEntry(value: value, ttl: ttl ?? defaultTtl);
  }

  @override
  String toString() {
    final stats = getStats();
    return 'CacheManager(total: ${stats.totalEntries}, valid: ${stats.validEntries}, expired: ${stats.expiredEntries})';
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

/// Cache statistics information.
class CacheStats {
  /// Total number of cache entries
  final int totalEntries;

  /// Number of valid (non-expired) entries
  final int validEntries;

  /// Number of expired entries
  final int expiredEntries;

  /// Cache hit rate (0.0 to 1.0)
  final double hitRate;

  const CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.hitRate,
  });

  @override
  String toString() =>
      'CacheStats(total: $totalEntries, valid: $validEntries, expired: $expiredEntries, hitRate: ${(hitRate * 100).toStringAsFixed(1)}%)';
}
