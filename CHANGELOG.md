# Changelog

## Contents

- [0.6.0 (2026-10-06)](#section-1)
- [0.5.0](#section-2)
- [0.4.0](#section-3)
- [0.3.1](#section-4)
- [0.3.0](#section-5)
- [0.2.0](#section-6)
- [0.1.1 - 2025-11-11](#section-7)
- [0.1.0 - 2025-11-10](#section-8)

<a id="section-1"></a>

## 0.6.0 (2026-10-06)

### Added

- Typed identifiers and dynamic filters, endpoint capabilities, thematic discovery/browse, online scholar/book and narrator choices.
- Complete alternate collections, separately identified similar/context records, and explanation-prose search including AJAX paging.
- Source documents, block/range/link/glossary/Quran/neutral-quotation annotations, safe HTML, custom render tokens, and reviewed-attribution validation.
- Scoped header/embedded citation metadata, provenance/diagnostics/pagination, preserved bibliography dates, and reference manifests/refresh tooling.
- Schema-2 narrator keys with symmetric Arabic search/count and an explicit non-destructive custom-database migration helper.

### Changed

- `Sharh.hadith` now uses `DetailedHadith`; saved historical JSON remains readable.
- Strict parsing reports malformed candidates; best-effort operation is explicit.
- Raw-response cache format 3 prevents result-model and rendering collisions without resetting SQLite.
- Quick API inputs reject unverified marfoo/narrator scopes; site scopes serialize as repeated arrays.
- Native assets resolve from the installed package independently of working directory and open read-only.

Publication checks and platform coverage are recorded in the release guide.

### Changes included from earlier development

### Breaking

- Corrected `BookReference` IDs to match Dorar `book.json`; removed constants
  with no Dorar entry (`musnadAhmad`, `muwattaMalik`, `musnadDarimi`,
  `musannafIbnAbiShaybah`, `musannafAbdRazzaq`). Use `BookReferenceService.searchBook`
  to discover available books.
- Removed unused `BookItem.author` / `mohdithId` / `category` and
  `BookReferenceService.getBooksByCategory` / `getBooksByMohdith` (assets only
  provide `key`/`value`). Use `BookService.getById` for author and edition details.

### Fixed

- Site/detail cleaning removes verified display prefixes while retaining internal
  dashes, HTML attributes, Arabic marks, punctuation and block boundaries.
- Persistent cache keys are scoped with `CacheService.formatVersion` so
  upgrades ignore stale parsed matn instead of serving it until TTL expiry.
- `DorarHttpClient` sends browser-like default headers to reduce Dorar 403s.
- `SharhService.getByText` uses percent-encoded URLs via `DorarEndpoints.sharhByText`.
- `searchViaApi` / `searchViaSite` validate `value` and `page` locally.
- Fixed `RawiReference.anasBinMalik` Arabic label (`أنس بن مالك`).
- Docs and tests synced with nested `Sharh` / `MohdithItem` / book constants.

### Added

- `CacheDatabase.countCacheEntries()` and `evictOldestEntries()` for bounded SQLite cache eviction.
- `CacheService.maxSqliteRows` (default: 750) caps persistent cache rows with LRU eviction by `createdAt`.
- Periodic `clearExpiredCache()` every 50 cache writes.

### Changed

- `CacheService.set()` now enforces the SQLite row cap after each insert.

<a id="section-2"></a>

## 0.5.0

### Breaking

- Removed Flutter setup helpers (`configureFlutterAssetLoader`, `createFlutterConnectionFactory`, `FlutterAssetLoader`) from core exports. Flutter apps must use the new [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter) package.

### Added

- New companion package [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter) for Flutter asset and database wiring.
- Declared `flutter: assets:` in pubspec so bundled offline data ships correctly to Flutter consumers.

### Changed

- Default cache TTL increased from 1 day to 7 days (`CacheService`, `InMemoryCacheManager`).
- `sqlite3` dependency updated to `^3.2.0`.
- Bumped the minimum Dart SDK to 3.12.0.

### Fixed

- `AssetLoader.configure()` is no longer overwritten when the platform default loader registers after an explicit Flutter override.

<a id="section-3"></a>

## 0.4.0

### New Features

- **Sharh search**: Added `SharhService.search()` and `DorarClient.searchSharh()` to search for all available sharh (explanations) matching a query, matching the Node.js `getAllSharhUsingSiteDorar` endpoint.
- **Hadith categories**: `DetailedHadith` now includes thematic categories (التصنيف الموضوعي) parsed from Dorar.net search results via a new `HadithCategory` model.
- **Pagination metadata**: `SearchMetadata` now exposes `currentPageCount`, `total`, `totalPages`, `hasNextPage`, and `hasPrevPage` for both API and site search endpoints.
- **Convenience methods**: Added `getSimilarHadith()`, `getAlternateHadith()`, `getUsulHadith()`, `getSharhByText()`, and `searchSharh()` directly on `DorarClient` for quicker access.

### Fixes

- **Query serialization**: `removeHtml` and `specialist` are no longer sent upstream to Dorar.net, matching the Node.js middleware behavior that strips them before forwarding.
- **Grade fallback**: When `grade` is empty but `explainGrade` has a value, the parser now copies `explainGrade` to `grade`, matching the Node.js fallback behavior.
- **JSON serialization**: Fixed `toJson()` on nested Freezed objects (`ApiResponse`, `Sharh`, `DetailedHadith`) to properly call `.toJson()` on child models via `explicit_to_json: true`.

### Documentation

- Updated README (EN/AR) with examples for sharh search, convenience methods, categories, and expanded pagination metadata.

<a id="section-4"></a>

## 0.3.1

- Fixed a bug with the cache system where the removeHtml parameter doesn't effect the cache

<a id="section-5"></a>

## 0.3.0

- **New Feature**: Implemented a persistent caching system using Drift (SQLite).
  - Replaced the in-memory cache with a robust, persistent database (`cache.db`).
  - Supports native platforms (Windows, Linux, macOS, Android, iOS) using `sqlite3`.
  - Supports Web using `sqlite3.wasm` (requires `sqlite3.wasm` and `drift_worker.dart.js` in web root).
- **Improvement**: Enhanced `CacheService` to handle complex objects and metadata efficiently.
- **Internal**: Refactored database connection logic to support multiple databases (`rawi.db` and `cache.db`) seamlessly across platforms.

<a id="section-6"></a>

## 0.2.0

- Added the richer `DetailedHadith`/`ExplainedHadith` layers plus the unified
  `hukm` getter so consumers no longer juggle `grade` vs `explainGrade` when
  printing verdicts.
- Updated `DorarClient`/`HadithService` quick-search APIs to keep returning
  lightweight `Hadith` rows while detailed/site endpoints now surface the full
  `DetailedHadith` payloads.
- Switched `UsulHadith` to wrap the new `DetailedHadith` so similar/alternate
  flags and sharh metadata are always available.
- Introduced `DorarClient.use(...)` for one-off scripts—resources are disposed
  automatically after the provided callback completes.
- Refactored `Sharh` to expose the embedded `ExplainedHadith`, giving direct
  access to takhrij, pass-through helpers, and `Sharh.text` as an alias for the
  commentary body.
- Bumped the minimum Dart SDK to 3.10.0 (and `http` to 1.6.0) to pick up the
  latest language/runtime fixes.
- Moved asset-loader utilities under `src/utils/asset_loader/` with explicit
  registration hooks so each platform can configure its loader cleanly.
- Removed the deprecated `BookReference.popularBooks` helpers to avoid stale
  curated lists.
- Refreshed README (EN/AR) and dartdoc content to explain the new models and
  public API changes.

<a id="section-7"></a>

## 0.1.1 - 2025-11-11

- Small improvements

<a id="section-8"></a>

## 0.1.0 - 2025-11-10

- Initial public release of `dorar_hadith`.
- Hadith search via API and site (quick and detailed).
- Fetch hadith by ID, similar hadiths, alternate sahih, and usul (sources).
- Sharh (explanations) search and fetch by ID.
- Offline reference data services for books, scholars (mohdith), and narrators (rawi).
- Bundled SQLite database for narrators (rawi) with Drift ORM.
- Robust error handling with sealed `DorarException` hierarchy and helper messages.
- Arabic search utilities (fuzzy match, diacritics stripping).
- Extensive unit, integration, and snapshot tests.
- Example app under `example/` covering the main features.
