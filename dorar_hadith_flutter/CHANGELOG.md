# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

## Unreleased

### Added
- `createFlutterCacheConnectionFactory` — opens `cache.db` in a writable app directory.
- `ensureInitialized()` now wires `CacheDatabase.configureConnection` alongside `rawi.db`, so API response caching uses the application support directory instead of the process working directory.

## 0.5.0

- Initial release: `DorarHadithFlutter.ensureInitialized()` wires asset loading and `rawi.db` for Flutter apps.
- Re-exports advanced hooks (`configureFlutterAssetLoader`, `createFlutterConnectionFactory`).
- Bumped the minimum Dart SDK to 3.12.0 and Flutter SDK to 3.44.0.
