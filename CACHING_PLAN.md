# Dorar Hadith - Caching System Plan

## بسم الله الرحمن الرحيم

This document outlines a comprehensive caching strategy for the `dorar_hadith` Dart package. The goal is to improve performance, reduce network requests, provide offline capability, and create a robust, maintainable caching architecture.

---

## Table of Contents

1. [Current State Analysis](#current-state-analysis)
2. [Proposed Architecture](#proposed-architecture)
3. [Implementation Phases](#implementation-phases)
4. [Detailed Technical Specifications](#detailed-technical-specifications)
5. [API Design](#api-design)
6. [Migration Strategy](#migration-strategy)
7. [Testing Strategy](#testing-strategy)
8. [Performance Considerations](#performance-considerations)

---

## Current State Analysis

### Existing Caching Implementation

The package currently uses a simple in-memory cache (`CacheManager`) with the following characteristics:

**Strengths:**
- ✅ TTL (Time-to-Live) support with configurable expiry
- ✅ Type-safe generic implementation
- ✅ Factory pattern (`getOrSet`) for lazy loading
- ✅ Statistics tracking (total/valid/expired entries)
- ✅ Max size limit with LRU-style eviction
- ✅ Zero dependencies for the cache itself

**Limitations:**
- ❌ **Non-persistent**: Cache is lost on app restart
- ❌ **Memory-only**: Large datasets consume RAM
- ❌ **No offline support**: Cannot serve cached data when offline
- ❌ **No cache invalidation strategy**: Only TTL-based expiry
- ❌ **No hit rate tracking**: `hitRate` is always 0.0
- ❌ **No cache warming**: Data must be fetched on first access
- ❌ **No compression**: Large responses stored as-is
- ❌ **Single cache instance shared**: All services share one cache

### Current Cache Usage by Service

| Service | Cache Usage | Data Type | Typical Size |
|---------|-------------|-----------|--------------|
| `HadithService` | URL-keyed responses | `ApiResponse<List<DetailedHadith>>` | ~50-500 KB per search |
| `SharhService` | URL-keyed responses | `Sharh` | ~5-20 KB per entry |
| `BookService` | URL-keyed responses | `BookInfo` | ~1-5 KB per entry |
| `MohdithService` | URL-keyed responses | `MohdithInfo` | ~1-10 KB per entry |

### Reference Services (Already Optimized)

| Service | Storage | Records | Status |
|---------|---------|---------|--------|
| `BookReferenceService` | In-memory JSON | ~685 books | ✅ Good |
| `MohdithReferenceService` | In-memory JSON | ~197 scholars | ✅ Good |
| `RawiReferenceService` | SQLite/Drift | ~11,436 narrators | ✅ Excellent |

---

## Proposed Architecture

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         DorarClient                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ HadithService│  │ SharhService │  │ BookService, etc.    │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
│         │                 │                      │              │
│         └─────────────────┼──────────────────────┘              │
│                           │                                      │
│                           ▼                                      │
│              ┌────────────────────────┐                         │
│              │     CacheManager       │ ◄─── Unified Interface  │
│              │   (Strategy Pattern)   │                         │
│              └───────────┬────────────┘                         │
│                          │                                       │
│         ┌────────────────┼────────────────┐                     │
│         ▼                ▼                ▼                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │  Memory     │  │  SQLite     │  │   Hybrid    │             │
│  │  Cache      │  │  Cache      │  │   Cache     │             │
│  │  (L1)       │  │  (L2)       │  │  (L1 + L2)  │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Cache Layers

**L1 - Memory Cache (Hot Cache)**
- Fast access for frequently used data
- Limited size (configurable, default ~100 entries)
- First-check for all cache operations
- Automatic promotion of L2 hits

**L2 - Persistent Cache (Cold Storage)**
- SQLite database using Drift (already a dependency)
- Unlimited storage (disk-based)
- Survives app restarts
- Supports offline mode

---

## Implementation Phases

### Phase 1: Enhanced In-Memory Cache (Quick Win)
**Estimated effort: 1-2 days**

1. Add hit/miss tracking for accurate statistics
2. Implement cache key namespacing per service
3. Add cache warmup capability
4. Implement smarter eviction (LRU with frequency)

### Phase 2: Persistent Cache Layer
**Estimated effort: 3-5 days**

1. Create `CacheDatabase` using Drift (similar to `RawiDatabase`)
2. Design cache table schema
3. Implement serialization for cached objects
4. Add read/write operations

### Phase 3: Hybrid Cache Strategy
**Estimated effort: 2-3 days**

1. Implement `HybridCacheManager` combining L1 + L2
2. Add automatic promotion/demotion between layers
3. Implement cache synchronization
4. Add background cleanup tasks

### Phase 4: Advanced Features
**Estimated effort: 3-5 days**

1. Implement cache invalidation patterns
2. Add offline mode detection and handling
3. Implement cache warming strategies
4. Add compression for large entries
5. Implement cache versioning for schema changes

---

## Detailed Technical Specifications

### Cache Database Schema

```dart
// lib/src/database/cache_database.dart

import 'package:drift/drift.dart';

class CacheEntries extends Table {
  /// Primary key - composed of namespace and key
  TextColumn get cacheKey => text()();
  
  /// Namespace for grouping (hadith, sharh, book, mohdith)
  TextColumn get namespace => text()();
  
  /// Serialized JSON data
  TextColumn get data => text()();
  
  /// Data type for deserialization
  TextColumn get dataType => text()();
  
  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime()();
  
  /// Expiry timestamp
  DateTimeColumn get expiresAt => dateTime().nullable()();
  
  /// Last access timestamp (for LRU)
  DateTimeColumn get lastAccessedAt => dateTime()();
  
  /// Access count (for frequency-based eviction)
  IntColumn get accessCount => integer().withDefault(const Constant(1))();
  
  /// Size in bytes (for memory management)
  IntColumn get sizeBytes => integer()();
  
  /// Compressed flag
  BoolColumn get isCompressed => boolean().withDefault(const Constant(false))();
  
  /// ETag for conditional requests (if server supports)
  TextColumn get etag => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {cacheKey};
}

@DriftDatabase(tables: [CacheEntries])
class CacheDatabase extends _$CacheDatabase {
  CacheDatabase(super.connection);
  
  @override
  int get schemaVersion => 1;
  
  /// Get a cache entry by key and namespace
  Future<CacheEntriesData?> getCacheEntry(String key, String? namespace) {
    final ns = namespace ?? 'default';
    return (select(cacheEntries)
          ..where((t) => t.cacheKey.equals('$ns:$key')))
        .getSingleOrNull();
  }
  
  /// Delete a cache entry
  Future<int> deleteCacheEntry(String key, String? namespace) {
    final ns = namespace ?? 'default';
    return (delete(cacheEntries)
          ..where((t) => t.cacheKey.equals('$ns:$key')))
        .go();
  }
  
  /// Update last access time and increment access count
  Future<void> touchEntry(String key, String? namespace) async {
    final ns = namespace ?? 'default';
    final fullKey = '$ns:$key';
    await (update(cacheEntries)..where((t) => t.cacheKey.equals(fullKey)))
        .write(CacheEntriesCompanion(
          lastAccessedAt: Value(DateTime.now()),
          accessCount: const Value.custom(CustomExpression('access_count + 1')),
        ));
  }
  
  /// Insert or update a cache entry
  Future<void> upsertCacheEntry({
    required String key,
    required String namespace,
    required String data,
    required String dataType,
    DateTime? expiresAt,
    required int sizeBytes,
    bool isCompressed = false,
    String? etag,
  }) async {
    final fullKey = '$namespace:$key';
    final now = DateTime.now();
    
    await into(cacheEntries).insertOnConflictUpdate(CacheEntriesCompanion.insert(
      cacheKey: fullKey,
      namespace: namespace,
      data: data,
      dataType: dataType,
      createdAt: now,
      expiresAt: Value(expiresAt),
      lastAccessedAt: now,
      sizeBytes: sizeBytes,
      isCompressed: Value(isCompressed),
      etag: Value(etag),
    ));
  }
  
  /// Clear all entries in a namespace
  Future<int> clearNamespace(String namespace) {
    return (delete(cacheEntries)
          ..where((t) => t.namespace.equals(namespace)))
        .go();
  }
  
  /// Delete expired entries
  Future<int> deleteExpired() {
    return (delete(cacheEntries)
          ..where((t) => t.expiresAt.isSmallerThanValue(DateTime.now())))
        .go();
  }
  
  /// Get total size of all cache entries
  Future<int> getTotalSize() async {
    final query = selectOnly(cacheEntries)
      ..addColumns([cacheEntries.sizeBytes.sum()]);
    final result = await query.getSingle();
    return result.read(cacheEntries.sizeBytes.sum()) ?? 0;
  }
  
  /// Count all entries
  Future<int> countEntries({String? namespace}) async {
    final query = selectOnly(cacheEntries)..addColumns([cacheEntries.cacheKey.count()]);
    if (namespace != null) {
      query.where(cacheEntries.namespace.equals(namespace));
    }
    final result = await query.getSingle();
    return result.read(cacheEntries.cacheKey.count()) ?? 0;
  }
}
```

### Cache Entry Model

```dart
// lib/src/models/cache_entry.dart

import 'dart:convert';

/// Represents a cached item with metadata
class PersistentCacheEntry<T> {
  final String key;
  final String namespace;
  final T value;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime lastAccessedAt;
  final int accessCount;
  final int sizeBytes;
  final bool isCompressed;
  final String? etag;

  const PersistentCacheEntry({
    required this.key,
    required this.namespace,
    required this.value,
    required this.createdAt,
    this.expiresAt,
    required this.lastAccessedAt,
    this.accessCount = 1,
    required this.sizeBytes,
    this.isCompressed = false,
    this.etag,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Duration get age => DateTime.now().difference(createdAt);
  
  Duration? get remainingTtl {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Update last access time and increment count
  PersistentCacheEntry<T> touch() {
    return PersistentCacheEntry<T>(
      key: key,
      namespace: namespace,
      value: value,
      createdAt: createdAt,
      expiresAt: expiresAt,
      lastAccessedAt: DateTime.now(),
      accessCount: accessCount + 1,
      sizeBytes: sizeBytes,
      isCompressed: isCompressed,
      etag: etag,
    );
  }
}
```

### Cache Strategy Interface

```dart
// lib/src/utils/cache/cache_strategy.dart

/// Cache statistics for monitoring
class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final double hitRate;
  final int hits;
  final int misses;
  final int sizeBytes;

  const CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.hitRate,
    this.hits = 0,
    this.misses = 0,
    this.sizeBytes = 0,
  });
}

/// Abstract cache strategy interface
abstract class CacheStrategy {
  /// Get a value from cache
  Future<T?> get<T>(String key, {String? namespace});
  
  /// Set a value in cache
  Future<void> set<T>(
    String key,
    T value, {
    String? namespace,
    Duration? ttl,
  });
  
  /// Check if key exists and is valid
  Future<bool> has(String key, {String? namespace});
  
  /// Remove a specific entry
  Future<void> remove(String key, {String? namespace});
  
  /// Clear all entries in a namespace
  Future<void> clearNamespace(String namespace);
  
  /// Clear all entries
  Future<void> clear();
  
  /// Get cache statistics
  Future<CacheStats> getStats({String? namespace});
  
  /// Remove expired entries
  Future<int> cleanup();
}
```

### Memory Cache Implementation

```dart
// lib/src/utils/cache/memory_cache.dart

/// In-memory cache entry with TTL support
class MemoryCacheEntry<T> {
  final T value;
  final DateTime createdAt;
  final Duration ttl;
  DateTime lastAccessedAt;
  int accessCount;

  MemoryCacheEntry({
    required this.value,
    required this.ttl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastAccessedAt = DateTime.now(),
       accessCount = 1;

  bool get isExpired => DateTime.now().isAfter(createdAt.add(ttl));
  
  MemoryCacheEntry<T> touch() {
    lastAccessedAt = DateTime.now();
    accessCount++;
    return this;
  }
}

class MemoryCache implements CacheStrategy {
  final Map<String, MemoryCacheEntry<dynamic>> _cache = {};
  final int maxSize;
  final Duration defaultTtl;
  
  // Hit/miss tracking
  int _hits = 0;
  int _misses = 0;

  MemoryCache({
    this.maxSize = 100,
    this.defaultTtl = const Duration(hours: 1),
  });

  @override
  Future<T?> get<T>(String key, {String? namespace}) async {
    final fullKey = _buildKey(key, namespace);
    final entry = _cache[fullKey];
    
    if (entry == null) {
      _misses++;
      return null;
    }
    
    if (entry.isExpired) {
      _cache.remove(fullKey);
      _misses++;
      return null;
    }
    
    _hits++;
    // Update access info
    _cache[fullKey] = entry.touch();
    
    if (entry.value is T) {
      return entry.value as T;
    }
    return null;
  }

  double get hitRate {
    final total = _hits + _misses;
    return total > 0 ? _hits / total : 0.0;
  }
  
  String _buildKey(String key, String? namespace) {
    return namespace != null ? '$namespace:$key' : key;
  }
  
  // ... rest of implementation
}
```

### SQLite Cache Implementation

```dart
// lib/src/utils/cache/sqlite_cache.dart

class SqliteCache implements CacheStrategy {
  final CacheDatabase _db;
  final JsonSerializer _serializer;
  
  SqliteCache({
    CacheDatabase? database,
    JsonSerializer? serializer,
  }) : _db = database ?? CacheDatabase(),
       _serializer = serializer ?? JsonSerializer();

  @override
  Future<T?> get<T>(String key, {String? namespace}) async {
    final entry = await _db.getCacheEntry(key, namespace);
    
    if (entry == null) return null;
    
    // Check if expired (expiresAt is nullable, null means no expiry)
    final isExpired = entry.expiresAt != null && 
        DateTime.now().isAfter(entry.expiresAt!);
    
    if (isExpired) {
      await _db.deleteCacheEntry(key, namespace);
      return null;
    }
    
    // Update access metadata
    await _db.touchEntry(key, namespace);
    
    // Deserialize
    return _serializer.deserialize<T>(entry.data, entry.dataType);
  }

  @override
  Future<void> set<T>(
    String key,
    T value, {
    String? namespace,
    Duration? ttl,
  }) async {
    final serialized = _serializer.serialize(value);
    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    
    await _db.upsertCacheEntry(
      key: key,
      namespace: namespace ?? 'default',
      data: serialized.data,
      dataType: serialized.type,
      expiresAt: expiresAt,
      sizeBytes: serialized.data.length,
    );
  }
  
  // ... rest of implementation
}
```

### Hybrid Cache (L1 + L2)

```dart
// lib/src/utils/cache/hybrid_cache.dart

class HybridCache implements CacheStrategy {
  final MemoryCache _l1Cache;
  final SqliteCache _l2Cache;
  final bool enableL2;
  
  HybridCache({
    MemoryCache? memoryCache,
    SqliteCache? sqliteCache,
    this.enableL2 = true,
  }) : _l1Cache = memoryCache ?? MemoryCache(),
       _l2Cache = sqliteCache ?? SqliteCache();

  @override
  Future<T?> get<T>(String key, {String? namespace}) async {
    // Try L1 first
    final l1Result = await _l1Cache.get<T>(key, namespace: namespace);
    if (l1Result != null) return l1Result;
    
    if (!enableL2) return null;
    
    // Try L2
    final l2Result = await _l2Cache.get<T>(key, namespace: namespace);
    if (l2Result != null) {
      // Promote to L1
      await _l1Cache.set(key, l2Result, namespace: namespace);
      return l2Result;
    }
    
    return null;
  }

  @override
  Future<void> set<T>(
    String key,
    T value, {
    String? namespace,
    Duration? ttl,
  }) async {
    // Write to both caches
    await _l1Cache.set(key, value, namespace: namespace, ttl: ttl);
    
    if (enableL2) {
      await _l2Cache.set(key, value, namespace: namespace, ttl: ttl);
    }
  }
  
  // ... rest of implementation
}
```

### JSON Serializer

```dart
// lib/src/utils/cache/json_serializer.dart

import 'dart:convert';

class SerializedData {
  final String data;
  final String type;
  
  SerializedData(this.data, this.type);
}

class JsonSerializer {
  /// Serialize an object to JSON string
  SerializedData serialize<T>(T value) {
    final type = T.toString();
    
    // Handle known types
    if (value is ApiResponse<List<DetailedHadith>>) {
      return SerializedData(
        jsonEncode(value.toJson((list) => list.map((h) => h.toJson()).toList())),
        'ApiResponse<List<DetailedHadith>>',
      );
    }
    
    if (value is ApiResponse<List<Hadith>>) {
      return SerializedData(
        jsonEncode(value.toJson((list) => list.map((h) => h.toJson()).toList())),
        'ApiResponse<List<Hadith>>',
      );
    }
    
    if (value is DetailedHadith) {
      return SerializedData(jsonEncode(value.toJson()), 'DetailedHadith');
    }
    
    if (value is Sharh) {
      return SerializedData(jsonEncode(value.toJson()), 'Sharh');
    }
    
    if (value is BookInfo) {
      return SerializedData(jsonEncode(value.toJson()), 'BookInfo');
    }
    
    if (value is MohdithInfo) {
      return SerializedData(jsonEncode(value.toJson()), 'MohdithInfo');
    }
    
    if (value is UsulHadith) {
      return SerializedData(jsonEncode(value.toJson()), 'UsulHadith');
    }
    
    // Fallback for primitives
    return SerializedData(jsonEncode(value), type);
  }
  
  /// Deserialize JSON string to typed object
  T? deserialize<T>(String data, String storedType) {
    final json = jsonDecode(data);
    
    // Match type and deserialize
    switch (storedType) {
      case 'ApiResponse<List<DetailedHadith>>':
        return ApiResponse<List<DetailedHadith>>.fromJson(
          json,
          (data) => (data as List).map((e) => DetailedHadith.fromJson(e)).toList(),
        ) as T;
        
      case 'ApiResponse<List<Hadith>>':
        return ApiResponse<List<Hadith>>.fromJson(
          json,
          (data) => (data as List).map((e) => Hadith.fromJson(e)).toList(),
        ) as T;
        
      case 'DetailedHadith':
        return DetailedHadith.fromJson(json) as T;
        
      case 'Sharh':
        return Sharh.fromJson(json) as T;
        
      case 'BookInfo':
        return BookInfo.fromJson(json) as T;
        
      case 'MohdithInfo':
        return MohdithInfo.fromJson(json) as T;
        
      case 'UsulHadith':
        return UsulHadith.fromJson(json) as T;
        
      default:
        // Attempt generic deserialization
        return json as T;
    }
  }
}
```

---

## API Design

### Updated DorarClient Options

```dart
class DorarClient {
  /// Creates a new Dorar client.
  ///
  /// [cacheStrategy] - Cache strategy to use (memory, sqlite, hybrid)
  /// [cacheConfig] - Configuration for the cache
  DorarClient({
    Duration timeout = const Duration(seconds: 15),
    CacheConfig? cacheConfig,
    DorarHttpClient? httpClient,
  });
}

class CacheConfig {
  /// Enable caching (default: true)
  final bool enabled;
  
  /// Cache strategy type
  final CacheStrategyType strategy;
  
  /// Default TTL for cache entries
  final Duration defaultTtl;
  
  /// Maximum L1 cache entries
  final int maxMemoryEntries;
  
  /// Maximum L2 cache size in MB
  final int maxDiskSizeMb;
  
  /// TTL overrides per namespace
  final Map<String, Duration> namespaceTtl;
  
  /// Enable offline mode support
  final bool enableOfflineMode;
  
  /// Compress entries larger than this size
  final int compressionThresholdBytes;
  
  const CacheConfig({
    this.enabled = true,
    this.strategy = CacheStrategyType.hybrid,
    this.defaultTtl = const Duration(hours: 24),
    this.maxMemoryEntries = 100,
    this.maxDiskSizeMb = 50,
    this.namespaceTtl = const {},
    this.enableOfflineMode = true,
    this.compressionThresholdBytes = 10240, // 10KB
  });
  
  /// Memory-only cache (fast, non-persistent)
  static const memory = CacheConfig(
    strategy: CacheStrategyType.memory,
    enableOfflineMode: false,
  );
  
  /// SQLite-only cache (persistent, slower)
  static const sqlite = CacheConfig(
    strategy: CacheStrategyType.sqlite,
    maxMemoryEntries: 0,
  );
  
  /// Hybrid cache (default, best of both)
  static const hybrid = CacheConfig();
  
  /// No caching
  static const none = CacheConfig(enabled: false);
}

enum CacheStrategyType {
  memory,
  sqlite,
  hybrid,
}
```

### Service-Level Cache Control

```dart
// Example: Hadith service with namespace
class HadithService {
  static const _namespace = 'hadith';
  
  final CacheStrategy _cache;
  
  Future<ApiResponse<List<DetailedHadith>>> searchViaSite(
    HadithSearchParams params, {
    CachePolicy? cachePolicy,
  }) async {
    final cacheKey = _buildCacheKey(params);
    
    // Check cache policy
    if (cachePolicy != CachePolicy.networkOnly) {
      final cached = await _cache.get<ApiResponse<List<DetailedHadith>>>(
        cacheKey,
        namespace: _namespace,
      );
      
      if (cached != null) {
        return cached.copyWith(
          metadata: cached.metadata.copyWith(isCached: true),
        );
      }
    }
    
    // Fetch from network
    final result = await _fetchFromNetwork(params);
    
    // Cache result (unless cacheOnly)
    if (cachePolicy != CachePolicy.cacheOnly) {
      await _cache.set(
        cacheKey,
        result,
        namespace: _namespace,
      );
    }
    
    return result;
  }
}

enum CachePolicy {
  /// Use cache if available, fallback to network
  cacheFirst,
  
  /// Use network first, fallback to cache
  networkFirst,
  
  /// Only use network, update cache
  networkOnly,
  
  /// Only use cache, fail if not available
  cacheOnly,
  
  /// Return cache immediately, update in background
  staleWhileRevalidate,
}
```

---

## Migration Strategy

### Phase 1: Non-Breaking Enhancement

1. Add new cache interfaces without modifying existing `CacheManager`
2. Create `CacheStrategy` abstract class
3. Make existing `CacheManager` implement `CacheStrategy`
4. Add new implementations alongside

### Phase 2: Gradual Adoption

1. Add `CacheConfig` to `DorarClient` with defaults matching current behavior
2. Allow opt-in to new cache strategies via config
3. Deprecate direct `CacheManager` usage in services

### Phase 3: Default Migration

1. Change default strategy to hybrid
2. Update documentation
3. Provide migration guide

---

## Testing Strategy

### Unit Tests

```dart
group('MemoryCache', () {
  test('should track hits and misses', () async {
    final cache = MemoryCache();
    
    await cache.set('key', 'value');
    await cache.get<String>('key'); // hit
    await cache.get<String>('missing'); // miss
    
    expect(cache.hits, equals(1));
    expect(cache.misses, equals(1));
    expect(cache.hitRate, closeTo(0.5, 0.01));
  });
});

group('SqliteCache', () {
  test('should persist across instances', () async {
    final db = CacheDatabase.forTesting();
    
    final cache1 = SqliteCache(database: db);
    await cache1.set('key', 'persistent value');
    
    final cache2 = SqliteCache(database: db);
    final result = await cache2.get<String>('key');
    
    expect(result, equals('persistent value'));
  });
});

group('HybridCache', () {
  test('should promote L2 hits to L1', () async {
    final l1 = MemoryCache();
    final l2 = SqliteCache();
    final hybrid = HybridCache(memoryCache: l1, sqliteCache: l2);
    
    // Set in L2 only
    await l2.set('key', 'value');
    
    // Get should promote to L1
    await hybrid.get<String>('key');
    
    // Should now be in L1
    final l1Result = await l1.get<String>('key');
    expect(l1Result, equals('value'));
  });
});
```

### Integration Tests

```dart
group('DorarClient with persistent cache', () {
  test('should use cached results on second call', () async {
    final client = DorarClient(
      cacheConfig: CacheConfig(strategy: CacheStrategyType.hybrid),
    );
    
    // First call - network
    final result1 = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة'),
    );
    expect(result1.metadata.isCached, isFalse);
    
    // Second call - cache
    final result2 = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة'),
    );
    expect(result2.metadata.isCached, isTrue);
    
    await client.dispose();
  });
  
  test('should work offline with cached data', () async {
    // Pre-populate cache
    final warmupClient = DorarClient();
    await warmupClient.searchHadith(HadithSearchParams(value: 'test'));
    await warmupClient.dispose();
    
    // Simulate offline
    final offlineClient = DorarClient(
      httpClient: MockOfflineHttpClient(),
    );
    
    final result = await offlineClient.searchHadith(
      HadithSearchParams(value: 'test'),
      cachePolicy: CachePolicy.cacheOnly,
    );
    
    expect(result.data, isNotEmpty);
  });
});
```

---

## Performance Considerations

### Memory Management

| Config | Typical Memory Usage | Recommended For |
|--------|---------------------|-----------------|
| Memory-only (100 entries) | ~5-50 MB | Mobile apps, low-memory devices |
| Hybrid (100 L1 + unlimited L2) | ~5-50 MB RAM + disk | Most applications |
| SQLite-only | ~1-5 MB RAM + disk | Background services |

### Disk Usage

| Cache Size | Estimated Records | Disk Space |
|------------|-------------------|------------|
| Light | ~500 searches | ~10 MB |
| Moderate | ~2000 searches | ~50 MB |
| Heavy | ~10000 searches | ~200 MB |

### Performance Benchmarks (Expected)

| Operation | Memory Cache | SQLite Cache | Hybrid (L1 hit) | Hybrid (L2 hit) |
|-----------|-------------|--------------|-----------------|-----------------|
| Read | < 1 ms | 5-10 ms | < 1 ms | 5-10 ms |
| Write | < 1 ms | 10-20 ms | 10-20 ms | 10-20 ms |
| Search (LIKE) | N/A | 20-50 ms | N/A | 20-50 ms |

### Cleanup Strategies

1. **Lazy cleanup**: Remove expired entries on access
2. **Periodic cleanup**: Background task every N minutes
3. **Size-based cleanup**: When max size exceeded, remove LRU entries
4. **Manual cleanup**: Expose `client.cleanupCache()` method

---

## Additional Features (Future Considerations)

### Cache Warming

```dart
/// Pre-populate cache with common searches
Future<void> warmupCache(DorarClient client) async {
  final commonSearches = ['الصلاة', 'الزكاة', 'الصيام', 'الحج'];
  
  for (final query in commonSearches) {
    await client.searchHadith(HadithSearchParams(value: query));
  }
}
```

### Cache Analytics

```dart
class CacheAnalytics {
  int totalHits;
  int totalMisses;
  int l1Hits;
  int l2Hits;
  Duration averageL1ReadTime;
  Duration averageL2ReadTime;
  int evictions;
  int expirations;
  DateTime lastCleanup;
  int diskUsageBytes;
}
```

### Conditional Requests (ETag Support)

```dart
// If Dorar API supports ETags in the future
class ConditionalCache {
  Future<T> getWithRevalidation<T>(
    String key,
    Future<T> Function(String? etag) fetcher,
  ) async {
    final cached = await _cache.get<CacheEntry<T>>(key);
    
    if (cached != null && !cached.isStale) {
      return cached.value;
    }
    
    try {
      final fresh = await fetcher(cached?.etag);
      await _cache.set(key, fresh);
      return fresh;
    } catch (e) {
      if (cached != null) {
        // Return stale data on network failure
        return cached.value;
      }
      rethrow;
    }
  }
}
```

---

## Summary

This caching plan transforms the simple in-memory cache into a robust, multi-layered caching system that:

1. **Maintains backward compatibility** - Existing API continues to work
2. **Provides persistence** - Data survives app restarts
3. **Enables offline mode** - Cached data available without network
4. **Improves performance** - Faster response times, reduced network calls
5. **Offers flexibility** - Configurable per use case
6. **Leverages existing dependencies** - Uses Drift (already in pubspec.yaml)

The phased implementation approach allows incremental delivery and testing, minimizing risk while delivering value at each phase.

---

*May Allah reward your efforts in serving the Hadith of His Prophet ﷺ.*
