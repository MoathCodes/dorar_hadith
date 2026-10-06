# Changelog

## Contents

- [0.6.0 (2026-10-06)](#section-1)
- [0.5.0](#section-2)

<a id="section-1"></a>

## 0.6.0 (2026-10-06)

- Verify transitive reference manifest/asset hashes and install immutable schema-2 snapshots atomically under versioned filenames.
- Preserve old references, mutable API cache, custom ownership, and unrelated files during upgrades.
- Share concurrent initialization, retry failures, reject conflicting configuration, and publish factories only after successful validation.
- Preserve ByteData slice offsets/lengths and expose typed actionable adapter errors.
- Isolate native SQLite imports from browser builds; browser setup uses the core snapshot-specific WebAssembly connection.
- Use the hosted core dependency `^0.6.0` and include an independent native/web example; exclude development overrides from package manifests.

Publication checks and platform coverage are tracked in the core release record.

### Changes included from earlier development

### Added

- `createFlutterCacheConnectionFactory`: opens `cache.db` in a writable app directory.
- `ensureInitialized()` now wires `CacheDatabase.configureConnection` alongside `rawi.db`, so API response caching uses the application support directory instead of the process working directory.

<a id="section-2"></a>

## 0.5.0

- Initial release: `DorarHadithFlutter.ensureInitialized()` wires asset loading and `rawi.db` for Flutter apps.
- Re-exports advanced hooks (`configureFlutterAssetLoader`, `createFlutterConnectionFactory`).
- Bumped the minimum Dart SDK to 3.12.0 and Flutter SDK to 3.44.0.
