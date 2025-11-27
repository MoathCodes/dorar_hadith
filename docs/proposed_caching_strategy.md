# Proposed Caching Strategy for `dorar_hadith`

## Objective
Implement a robust, persistent, and efficient caching system to minimize network requests, improve response times, and allow offline access to previously fetched data.

## Core Philosophy
**"Leverage what we have."**
Since the package already depends on `drift` and `sqlite3` for the Narrator (Rawi) database, we should utilize this for the HTTP cache as well. This avoids adding new heavy dependencies (like `hive` or `stash`) while providing a robust, SQL-based caching solution.

## Architecture: Two-Layer Cache

We will implement a **L1/L2 Caching Strategy**:

1.  **L1: Memory Cache (RAM)**
    *   **Storage:** `LinkedHashMap` (Dart's in-memory map).
    *   **Policy:** LRU (Least Recently Used).
    *   **Capacity:** Small (e.g., 50-100 entries).
    *   **Speed:** Instant.
    *   **Persistence:** Cleared on app restart.

2.  **L2: Persistent Cache (Disk/SQLite)**
    *   **Storage:** `Drift` Database (`sqlite3`).
    *   **Policy:** Time-to-Live (TTL) + Capacity limits.
    *   **Capacity:** Large (e.g., 1000+ entries or MB limit).
    *   **Speed:** Fast (Disk I/O).
    *   **Persistence:** Survives app restarts.

## Detailed Design

### 1. The `CacheStore` Interface
To keep the system testable and flexible, we define an interface.

```dart
abstract class CacheStore {
  Future<CacheEntry?> get(String key);
  Future<void> set(String key, CacheEntry entry);
  Future<void> remove(String key);
  Future<void> clear();
}
```

### 2. `DriftCacheDatabase` (The L2 Store)
We create a new table `http_cache` in a Drift database.

**Schema:**
*   `key` (Text, PK): Unique hash of the request (URL + Params).
*   `body` (Text): The JSON response body.
*   `headers` (Text): JSON serialized headers.
*   `created_at` (Int/DateTime): Timestamp.
*   `expires_at` (Int/DateTime): When the entry becomes invalid.

**Why Drift?**
*   **ACID Compliance:** Safe concurrent access.
*   **Query Power:** Easy to implement "delete all expired" or "count entries".
*   **Cross-Platform:** Works on Mobile, Desktop, and Web (via WASM/JS).

### 3. `CacheManager` Refactoring
The `CacheManager` becomes the orchestrator.

*   **Read Flow:**
    1.  Check L1 (Memory). If hit, return.
    2.  Check L2 (Disk).
    3.  If L2 hit:
        *   Check expiry.
        *   If valid: Promote to L1, return.
        *   If expired: Delete from L2, return null.
    4.  Return null (Cache Miss).

*   **Write Flow:**
    1.  Write to L1.
    2.  Write to L2 (Fire-and-forget or await based on config).

### 4. Integration with `DorarHttpClient`
Modify `DorarHttpClient` to use the `CacheManager`.

```dart
// Pseudo-code inside get()
final cacheKey = _generateKey(url);
final cached = await _cacheManager.get(cacheKey);
if (cached != null) return cached.response;

final response = await _client.get(url);
await _cacheManager.set(cacheKey, response);
return response;
```

## Implementation Roadmap

1.  **Database Setup**:
    *   Create `lib/src/database/cache_database.dart`.
    *   Define `HttpCache` table.
    *   Run `dart run build_runner build`.

2.  **Cache Logic**:
    *   Refactor `lib/src/utils/cache_manager.dart` to support the L1/L2 architecture.
    *   Implement `MemoryCacheStore` and `DriftCacheStore`.

3.  **Client Integration**:
    *   Update `DorarClient` to initialize the cache database.
    *   Update `DorarHttpClient` to intercept requests.

4.  **Cleanup**:
    *   Add a method to `dispose()` the database connection.
    *   Add a scheduled task (or run on startup) to `delete from http_cache where expires_at < now()`.

## Pros & Cons

**Pros:**
*   **Zero New Dependencies:** Uses existing `drift` setup.
*   **Persistent:** Users can browse previously fetched hadiths offline.
*   **Performance:** Memory layer ensures UI remains snappy; Disk layer saves bandwidth.
*   **Scalable:** SQLite handles thousands of rows effortlessly.

**Cons:**
*   **Complexity:** Slightly more complex than the current `Map<String, dynamic>`.
*   **Async Overhead:** Disk access is async (Future), but this is standard for HTTP clients.

## Conclusion
This strategy transforms `dorar_hadith` from a simple API client into a robust data provider that respects user bandwidth and works reliably in flaky network conditions. It aligns perfectly with the existing architecture.
