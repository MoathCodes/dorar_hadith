# Dorar Hadith Caching System Plan

## Objectives & Constraints
- Deliver sub-200 ms repeat queries for hot endpoints while keeping cold-start behavior unchanged.
- Preserve correctness for religious texts (no stale mutations) by preferring short TTLs or validation requests when data is likely to change.
- Keep the package Flutter-free by relying on pure Dart IO primitives; platform adapters can plug in when Flutter context exists.
- Remain opt-in/opt-out via `DorarClient` so embedders can disable or override caching without forking the package.
- Provide diagnostics (hits/misses, eviction counts, entry age) surfaced through `CacheStats` for observability and future auto-tuning.

## Current State (as of Nov 2025)
- Single in-memory `CacheManager` shared by services; cleared wholesale via `clearCache()`.
- Key = raw URL string; lacks namespace/versioning causing accidental collisions when parameters change in serialization order.
- TTL uniform across all resources (default 24 h); not aligned with per-endpoint volatility.
- Cache survives only for process lifetime; CLI tools or short scripts miss cross-run reuse.
- No eviction strategy beyond optional `maxSize`; no distinction between high-value vs. low-value entries.
- No lock/shield against cache stampedes—multiple concurrent calls for same key execute duplicate HTTP work.
- Metrics exposed only for counts; hit rate is hard-coded `0.0` and not tracked.

## Proposed Architecture
### 1. Cache Facade & Policy Layer
- Introduce a `CacheFacade` injected into services that orchestrates multi-layer operations and enforces policies per resource type.
- Policy object describes TTL, priority, serialization, and whether the entry is eligible for disk persistence or revalidation.

```dart
class CachePolicy {
  final Duration ttl;
  final bool persist;
  final bool allowStaleWhileRevalidate;
  final Duration? staleGrace;
  final CachePriority priority; // hot, warm, cold
}
```

### 2. Layered Stores
1. **MemoryStore (Hot)**
   - Backed by existing `CacheManager`, updated to track hits/misses, insertion order, and per-entry TTL.
   - Adds `Future<T> readThrough(...)` with internal mutex (`package:async/async.dart` `Mutex`) to prevent stampedes.
2. **DiskStore (Warm)**
   - File-based store (e.g., JSON blobs under `${cacheDir}/dorar_hadith/`) using `File` APIs, hashed keys, and metadata header.
   - For Flutter, optionally plug in `path_provider`; for pure Dart, fall back to `.dorar_hadith_cache` under `Directory.systemTemp` or user cache dir env.
3. **Custom Store Hook**
   - `abstract class CacheStore` so embedders can provide Redis/Hive/etc. Implementation registered in `DorarClient(cacheStore: ...)`.

`CacheFacade` consults stores in order (memory → disk → remote). On hit, value is promoted upward (read-through promotion).

### 3. Cache Envelope & Keying
- Wrap payloads in `CacheEnvelope<T>` storing `payload`, `createdAt`, `ttl`, `etag/hash`, `policyId`, `schemaVersion`.
- Use deterministic key factory: `cache:<service>:<operation>:<hash(params)>` where params hashed after canonical JSON serialization to avoid order-related misses.
- Embed `schemaVersion` so structural changes automatically invalidate stale disk entries without manual clear.

### 4. Concurrency & Stampede Protection
- Maintain `Map<String, Future>` of in-flight fetches to dedupe concurrent callers.
- Optionally expose `CacheLockManager` so services awaiting same key share single network response.

### 5. Stale-While-Revalidate Option
- For heavy endpoints (`searchViaSite`, `getUsul`): serve stale result if within `staleGrace` (e.g., 5 min), trigger background refresh to update memory/disk.
- Implement via `CacheEnvelope.isStaleButValid(staleGrace)` and `CacheFacade.getOrUpdate`.

### 6. Metrics & Instrumentation
- Extend `CacheStats` with `hits`, `misses`, `evictions`, `diskHits`, `refreshCount`.
- Provide `Stream<CacheEvent>` for embedders to log/monitor.

### 7. Public API Changes
- `DorarClient` signature additions:
  - `CacheConfig` with `enableMemory`, `enableDisk`, `cacheDir`, `policies`, `maxEntries`, `onEvent` callback.
  - `CacheFacade get cache` to expose read-only stats/controls.
- Service-level manual invalidation: `client.hadith.clearCache(scope: CacheScope.memory)` etc.

## Resource-Specific Policies
| Resource | Suggested TTL | Persistence | Notes |
| --- | --- | --- | --- |
| `searchViaApi` | 6 h | Disk + Memory | API data rarely mutates quickly; enable stale-while-revalidate 10 min.
| `searchViaSite` | 12 h | Disk + Memory | Heavy parse cost, but include `staleGrace=30 min`.
| `getById` (hadith) | 7 d | Disk + Memory | Text rarely changes; version bump if HTML parser schema updates.
| `getSimilar`, `getAlternate`, `getUsul` | 7 d | Disk + Memory | Light churn; consider manual invalidation when Dorar adds new refs.
| `sharh.getById` | 3 d | Disk + Memory | Sharh text occasionally edited; moderate TTL.
| `book.getById`, `mohdith.getById` | 30 d | Disk only optional to save RAM.
| Reference assets (rawi DB, JSON) | Already offline; only metadata caches for derived queries (counts) optional.

## Invalidation & Consistency Strategy
1. **Versioned Keys**: bump `schemaVersion` when parser/output model changes.
2. **Manual Hooks**: expose `client.cache.invalidate(where: (entry) => entry.policyId == 'hadith:site')` for targeted clears.
3. **Size-based Eviction**: implement LRU per store with `maxEntries` and `maxBytes` thresholds.
4. **Event-triggered Flush**: on HTTP 404/410 for previously cached ID, purge entry immediately.
5. **Integrity Checks**: disk store writes alongside checksum; corrupted entries fallback to refetch.

## Implementation Phases
1. **Infrastructure (Week 1)**
   - Create `CachePolicy`, `CacheStore`, `CacheEnvelope`, `CacheEvent`.
   - Refactor existing `CacheManager` into `MemoryStore` implementing `CacheStore`.
2. **Disk Store (Week 1-2)**
   - Implement file-backed store with hashed filenames and JSON serialization.
   - Add simple migration that clears incompatible versions.
3. **Facade Integration (Week 2)**
   - Build `CacheFacade` orchestrating stores + dedupe logic.
   - Update `DorarClient` to own `CacheFacade` and expose configuration.
4. **Service Adoption (Week 2-3)**
   - Replace direct `CacheManager` usage in Hadith/Sharh/Book/Mohdith services with `CacheFacade.fetch()`.
   - Define per-method `CachePolicy`s near service implementation for readability.
5. **Telemetry & Testing (Week 3)**
   - Unit tests for MemoryStore & DiskStore (expiry, eviction, concurrency).
   - Integration tests using mock HTTP client to ensure cached responses skip network.
   - Add benchmark harness to compare before/after latency for repeated queries.
6. **Docs & Migration (Week 3-4)**
   - Update README cache section with new APIs, configuration snippets, and advanced usage (custom stores, prewarming).
   - Provide migration guide summarizing defaults and how to opt-out.

## Additional Enhancements (Stretch Goals)
- **Prefetch Profiles**: allow users to preload caches (e.g., `client.cache.prewarm(queries: ['الصلاة', 'الصيام'])`).
- **Background Sweeper**: optional timer to purge expired disk entries without blocking main thread.
- **Adaptive TTLs**: dynamically adjust TTL based on server-provided headers or observed change frequency.
- **Cache-Aware HTTP Client**: integrate ETag/Last-Modified if Dorar exposes them, enabling conditional requests.
- **CLI Tooling**: `dart run dorar_hadith:cache-info` to inspect cache contents for debugging.

## Risks & Mitigations
- **Disk Growth**: enforce `maxBytes` and provide `client.cache.trim()` to bound size.
- **Platform Paths**: supply sensible defaults and allow injection to avoid permission issues in web/wasm contexts (disk layer disabled automatically).
- **Thread Safety**: rely on isolates/futures; ensure disk operations serialized to avoid corruption (single async queue).
- **Breaking Changes**: keep existing constructor defaults to enable in-memory cache only; disk layer opt-in until stable.

## Success Criteria
- 80%+ hit rate for repeated search queries during integration tests with sample workloads.
- Disk cache reduces cold HTTP calls by ≥50% when running CLI utility twice in a row.
- No regressions in existing tests; new cache tests cover expiry, eviction, persistence, concurrency, and configuration overrides.
