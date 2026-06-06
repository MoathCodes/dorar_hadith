# بسم الله الرحمن الرحيم
# Dorar Hadith

# تغيير اللغة: [ 🇸🇦 AR](README_AR.md)

---

A Dart library to search and retrieve hadith and related data from Dorar Al-Sanniyah.

Inspired by and partially based on the repository [dorar-hadith-api](https://github.com/AhmedElTabarani/dorar-hadith-api) by [Ahmed Al-Tabarani](https://github.com/AhmedElTabarani).
Works with any Dart program without requiring Flutter.

[![pub package](https://img.shields.io/pub/v/dorar_hadith.svg)](https://pub.dev/packages/dorar_hadith)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Library Highlights

- Fast hadith search with filters by narrator, book, grade, hadith scholar (mohdith), and more
- Retrieve detailed hadith information
- Search and fetch hadith explanations (Sharh)
- Search for all available sharh by query
- Find similar hadiths and alternate sahih versions
- Thematic categories (التصنيف الموضوعي) on detailed hadith results
- Offline browsing for books, narrators, and hadith scholars (mohdith) used for filtering

### Search Capabilities

- Search by hadith text
- Filter by hadith grade
- Filter by hadith scholars (mohdith)
- Filter by narrators
- Filter by books
- Filter by hadith type (Qudsi, Athar, etc.)
- Pagination metadata

## Installation

Run:

```bash
dart pub add dorar_hadith
```

Or using Flutter:

```bash
flutter pub add dorar_hadith_flutter
```

Pure Dart/CLI users should use `dart pub add dorar_hadith`. Flutter apps should depend on [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter), which pulls in `dorar_hadith` transitively.

## Flutter Setup

Call `DorarHadithFlutter.ensureInitialized()` once in `main()` before using offline reference data or the narrator database:

```dart
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DorarHadithFlutter.ensureInitialized();
  runApp(const MyApp());
}
```

Pass `databaseDirectory` to override where the copied `rawi.db` is stored (defaults to the application support directory from `path_provider`).

See the [`dorar_hadith_flutter` README](dorar_hadith_flutter/README.md) for asset keys, failure modes, and advanced customization.

## Offline Data, Assets & Platform Behavior

Offline reference browsing uses bundled assets from the `dorar_hadith` package (declared in its `pubspec.yaml`):

| Asset | Path | Used by |
|---|---|---|
| Books | `assets/data/book.json` | `BookReferenceService` |
| Scholars (mohdith) | `assets/data/mohdith.json` | `MohdithReferenceService` |
| Narrators (rawi) | `assets/database/rawi.db` | `RawiDatabase` / `RawiReferenceService` |

API response caching uses a separate SQLite database (`cache.db` on native CLI, WebAssembly storage on web). It is independent of the offline reference assets above.

### Platform differences

**Dart CLI / pure Dart (native)** — default when you depend on `dorar_hadith` only:

- **JSON assets** — `FileAssetLoader` resolves files via `Isolate.resolvePackageUri('package:dorar_hadith/…')`, then falls back to paths relative to the current working directory.
- **`rawi.db`** — `connection_native.dart` opens the bundled database from the package URI, then tries several CWD-relative paths (see failure modes below).
- **`cache.db`** — created in the **current working directory**.

**Flutter (Android, iOS, Linux, macOS, Windows)** — use [`dorar_hadith_flutter`](dorar_hadith_flutter/README.md):

- Call `DorarHadithFlutter.ensureInitialized()` once before offline reference or narrator APIs. The core package registers `FileAssetLoader` on native targets, which does **not** read Flutter asset bundles.
- After initialization, JSON loads go through `rootBundle` with keys like `packages/dorar_hadith/assets/data/book.json`, and `rawi.db` is copied once into the application support directory (or a custom `databaseDirectory`) before opening.
- You do **not** need to re-declare `rawi.db` or the JSON files in your app `pubspec.yaml`; transitive package assets from `dorar_hadith` are bundled automatically.
- `dorar_hadith_flutter` uses `dart:io` and is intended for **native Flutter targets**, not Flutter Web.

**Web (Dart web / Flutter Web with `dorar_hadith` only)**:

- **JSON assets** — `WebAssetLoader` fetches via HTTP relative to `Uri.base` (non-200 responses become `AssetLoaderException`).
- **`rawi.db` and `cache.db`** — Drift `WasmDatabase` with `sqlite3.wasm` and `drift_worker.dart.js` served from your app root (`/sqlite3.wasm`, `/drift_worker.dart.js`). The initial `rawi.db` bytes are fetched from common Flutter Web asset URLs (see failure modes).
- Flutter Web apps should configure the core package directly; do not rely on `dorar_hadith_flutter.ensureInitialized()` on web.

### Offline failure modes

| Situation | When | What is thrown |
|---|---|---|
| JSON asset not found | `BookReferenceService` / `MohdithReferenceService` `initialize()` | `AssetLoaderException` — CLI: `Asset file not found. Tried package asset and local filesystem for: <path>`; web: `Failed to load asset: HTTP <status>` or `Failed to load asset via HTTP: <uri>` |
| Asset read error | File exists but cannot be read (CLI) | `AssetLoaderException` with `Failed to read asset file: <path>` and optional `cause` |
| No asset loader configured | `AssetLoader()` before any platform registration | `UnsupportedError`: `No AssetLoader has been configured for this platform…` |
| `rawi.db` not found (native CLI) | `RawiDatabase` query before DB is reachable | `Exception`: `Database file not found. Tried package asset and paths:` followed by `package:dorar_hadith/assets/database/rawi.db` and CWD fallbacks |
| `rawi.db` not fetchable (web) | `RawiDatabase` open on web | `Exception`: `Failed to initialize web database: Could not fetch bundled rawi.db.` with candidate asset URLs |
| Flutter offline APIs before `ensureInitialized()` | `client.bookRef`, `client.mohdithRef`, or `client.rawiRef` in a Flutter app | JSON: `AssetLoaderException` (filesystem lookup misses bundle assets). Narrators: native `Exception` (`Database file not found…`) because `RawiDatabase` still uses the CLI connection factory |
| Missing Flutter bundle asset | `ensureInitialized()` or reference `initialize()` after setup, asset stripped from build | `FlutterError` from `rootBundle` (typically `Unable to load asset: packages/dorar_hadith/…`). Not wrapped as `AssetLoaderException` |
| `ensureInitialized()` called twice | Second and later calls | **No error** — returns immediately (idempotent). The first `databaseDirectory` wins; later overrides are ignored |
| Invalid JSON after load | Corrupt `book.json` / `mohdith.json` | `FormatException` from `json.decode` (not a `DorarException`) |

Reference lookups by unknown ID return `null` (books, scholars) or empty lists (`get*ByIds` skips missing keys). They do not throw.

## Quick Start

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

void main() async {
  await DorarClient.use((client) async {
    // Search for hadiths about prayer
    final results = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );

    print('Found ${results.data.length} hadiths');

    // Print first hadith
    if (results.data.isNotEmpty) {
      final h = results.data.first;
      print('Hadith: ${h.hadith}');
      print('Narrator: ${h.rawi}');
      print('Scholar: ${h.mohdith}');
      print('Verdict: ${h.hukm}');
    }

    // You can return the result to use else where
    return results;
  });
}
```

For a complete example covering all library features, see:
[`example/example.dart`](example/example.dart)

## Usage

### Important Note
Search and list operations that support pagination return an `ApiResponse<T>` wrapper:
- The result: `data`
- Pagination metadata: `metadata` (`SearchMetadata`)

Methods that return `ApiResponse`: `searchHadith`, `searchHadithDetailed`, `searchSharh`, and `getUsulHadith` / `hadith.getUsul`.

Single-item lookups return the model directly: `getHadithById` → `DetailedHadith`, `getSharhById` → `Sharh`, `book.getById` → `BookInfo`, `mohdith.getById` → `MohdithInfo`, `getSimilarHadith` → `List<DetailedHadith>`, `getAlternateHadith` → `DetailedHadith?`. Offline reference lookups return `List<...>` or nullable items and do not use `ApiResponse`.

### Quick Hadith Search
Using `client.searchHadith` is fast and returns lightweight `Hadith` objects
directly from the public API.
- Results are limited to ~15 hadiths, and filters can be used.
- Only the textual fields (`hadith`, `rawi`, `mohdith`, `book`,
  `numberOrPage`, `grade`) are included in this response.
- Call `client.searchHadithDetailed` when you need IDs, sharh metadata, Dorar
  links, or any of the extended fields provided by `DetailedHadith`.

```dart
final results = await client.searchHadith(
  HadithSearchParams(value: 'الإيمان'),
);

for (var hadith in results.data) {
  print('${hadith.hadith}');
  print('Grade: ${hadith.hukm}');
}
```

### Detailed Search with Filters
Note: Due to how Dorar works, detailed search populates
`DetailedHadith.explainGrade` instead of `grade`, **to avoid these issues always use `DetailedHadith.hukm`.**

```dart
final params = HadithSearchParams(
  value: 'الصيام',
  page: 1,
  degrees: [HadithDegree.authenticHadith], // Only sahih
  mohdith: [MohdithReference.bukhari],
  searchMethod: SearchMethod.anyWord,
  zone: SearchZone.qudsi,
);

final results = await client.searchHadithDetailed(params);
```

### Get Hadith by ID
Returns a `DetailedHadith` with complete metadata when available.

```dart
final hadith = await client.getHadithById('12345');
print('Hadith: ${hadith.hadith}');
print('Book: ${hadith.book}');
print('Grade: ${hadith.hukm}');
```

### Similar, Usul (Sources), Alternate Sahih
Note: The `DetailedHadith` model has flags to check availability:
- `hasAlternateHadithSahih` for alternate sahih
- `hasSimilarHadith` for similar hadiths
- `hasUsulHadith` for sources

```dart
// Get similar
final similar = await client.hadith.getSimilar('12345');
// Or use the convenience method
final sameSimilar = await client.getSimilarHadith('12345');

// Get alternate sahih
final alternate = await client.hadith.getAlternate('12345');
// Or use the convenience method
final sameAlternate = await client.getAlternateHadith('12345');

// Get sources
final usul = await client.hadith.getUsul('12345');
print('Main hadith: ${usul.data.hadith.hadith}');
print('Sources: ${usul.data.count}');
// Or use the convenience method
final sameUsul = await client.getUsulHadith('12345');
```

### Search for Sharh (Explanation)
Note: When using `client.searchHadithDetailed`, if a hadith has a sharh, you will find its ID in `DetailedHadith.sharhMetadata`. Use it as follows:

```dart
// Get sharh by ID
final sharh = await client.sharh.getById('789');

// Search by sharh text
final sharhByText = await client.sharh.getByText('إنما الأعمال بالنيات');
// Or use the convenience method
final sameSharh = await client.getSharhByText('إنما الأعمال بالنيات');

// Search for all available sharh matching a query
final sharhResults = await client.searchSharh(
  HadithSearchParams(value: 'الصلاة'),
);
for (var s in sharhResults.data) {
  print('Sharh: ${s.sharhText}');
}
```

### Reference Data (Offline)
Reference data is used for filtering (hadith scholar [mohdith], book, narrator) and is available offline for speed and usability.

Flutter apps must call `DorarHadithFlutter.ensureInitialized()` first. See [Offline Data, Assets & Platform Behavior](#offline-data-assets--platform-behavior) for bundled assets, platform differences, and failure modes.

Note: Reference items contain only `id` and `name` (e.g., Sahih al-Bukhari). For full details, fetch via the API. See: “Get Book/Scholar Details”.

#### Search Scholars (Hadith scholars – mohdith)

```dart
// By name
final bukhari = await client.mohdithRef.searchMohdith('البخاري');

// By ID
final scholar = await client.mohdithRef.getMohdithById('256');

// List paginated
final allScholars = await client.mohdithRef.getAllMohdith(limit: 50);

// Multiple by IDs
final scholars = await client.mohdithRef.getMohdithByIds(['256', '179']);

// Shortcut
final results = await client.searchMohdith('أحمد');
```

#### Search Books

```dart
// By name
final sahihBooks = await client.bookRef.searchBook('صحيح');

// By ID
final book = await client.bookRef.getBookById('6216');

// List paginated
final allBooks = await client.bookRef.getAllBooks(limit: 100, offset: 0);

// Shortcut
final results = await client.searchBooks('سنن');
```

#### Search Narrators

```dart
// By name
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 10);

// By ID
final abuHurayrah = await client.rawiRef.getRawiById(1416);

// Paginated listing
final page1 = await client.rawiRef.getAllRawi(limit: 50, offset: 0);

// Counts
final total = await client.rawiRef.countRawi();
final searchCount = await client.rawiRef.countRawi(query: 'عبد الله');

// Shortcut
final results = await client.searchRawi('عمر');

// Important: dispose after use to avoid warnings
await client.dispose();
```

#### Predefined Constants
To make filtering easier without repeatedly searching, popular scholars, books, and narrators are provided as ready-to-use constants.
If you’d like to add more, please open an issue on GitHub.

```dart
// Sample scholar constants
MohdithReference.bukhari  
MohdithReference.muslim     
MohdithReference.abuDawud   
// ... 20 total

// Sample book constants
BookReference.sahihBukhari  
BookReference.sahihMuslim     
// ... 21 total

// Sample narrator constants
RawiReference.abuHurayrah     
RawiReference.aisha          
// ... 21 total

// Using constants in filters
final params = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  mohdith: [MohdithReference.bukhari],
  books: [BookReference.sahihBukhari],
);
final results = await client.hadith.searchViaSite(params);
```

### Get Book or Hadith Scholar (Mohdith) Details

```dart
// Book details from API
final book = await client.book.getById('123');
print('Book: ${book.name}');
print('Author: ${book.author}');

// Hadith scholar (mohdith) details from API
final scholar = await client.mohdith.getById('456');
print('Name: ${scholar.name}');
print('Bio: ${scholar.info}');
```

## Available Options

This section describes all models and options provided by the library.

### Hadith Models

The package now exposes two layered models:

- `Hadith`: Lightweight record returned by the official Dorar API. Contains the
  matn, narrator, scholar, source book, page/number, and grade.
- `DetailedHadith`: Extends `Hadith` with every extra bit of metadata collected
  from the Dorar website (IDs, sharh metadata, takhrij, related links, etc.).

```dart
class Hadith {
  final String hadith;              // Hadith text (matn)
  final String rawi;                // Narrator name
  final String mohdith;             // Scholar name
  final String book;                // Source book name
  final String numberOrPage;        // Page or hadith number in the source
  final String grade;               // Verdict shown by the API
}

class DetailedHadith extends Hadith {
  final String? hadithId;           // Unique hadith ID
  final String? mohdithId;          // Scholar ID
  final String? bookId;             // Book ID
  final String? explainGrade;       // Verdict text (detailed search)
  final String? takhrij;            // Takhrij / additional sources
  final List<HadithCategory> categories; // Thematic categories (التصنيف الموضوعي)
  final bool hasSimilarHadith;      // Similar narrations exist?
  final bool hasAlternateHadithSahih; // Alternate sahih available?
  final bool hasUsulHadith;         // Usul (sources) available?
  final String? similarHadithDorar;     // URL for similar narrations
  final String? alternateHadithSahihDorar; // URL for alternate sahih
  final String? usulHadithDorar;         // URL for usul sources
  final bool hasSharhMetadata;      // Sharh metadata included?
  final SharhMetadata? sharhMetadata; // Sharh metadata payload
}
```

`client.searchHadith` and the other API-backed endpoints return the lightweight
`Hadith` model. The site-powered endpoints (detailed search, similar,
alternate, usul) upgrade those results to `DetailedHadith`, populating IDs,
sharh metadata, related links, and the helper flags below.

Key helpers:
- `hasSimilarHadith` ⇒ call `client.hadith.getSimilar()`
- `hasAlternateHadithSahih` ⇒ call `client.hadith.getAlternate()`
- `hasUsulHadith` ⇒ call `client.hadith.getUsul()`
- `hasSharhMetadata` ⇒ inspect `sharhMetadata.id` or `sharhMetadata.sharh`
- `hukm` getter ⇒ reads `explainGrade` when filled, otherwise falls back to
  `grade` (ideal for printing a single verdict string)

### Sharh Model

Represents a hadith with its explanation.

```dart
class Sharh {
  // Base hadith info
  final String hadith;              // Hadith text
  final String rawi;                // Narrator
  final String mohdith;             // Scholar
  final String book;                // Source book
  final String numberOrPage;        // Page/hadith number
  final String grade;               // Grade
  final String? takhrij;            // Takhrij
  
  // Sharh info
  final bool hasSharhMetadata;      // Has sharh?
  final SharhMetadata? sharhMetadata; // Sharh metadata
  
  // Helper to access sharh text directly
  String? get sharhText => sharhMetadata?.sharh;
}
```

Usage:
```dart
final sharh = await client.sharh.getById('789');
if (sharh.hasSharhMetadata && sharh.sharhText != null) {
  print('Sharh: ${sharh.sharhText}');
}
```

### SharhMetadata

```dart
class SharhMetadata {
  final String id;                  // Sharh ID
  final bool isContainSharh;        // Whether sharh text is included
  final String? sharh;              // Sharh text (if any)
}
```

### HadithCategory

Represents a thematic category (التصنيف الموضوعي) extracted from Dorar.net search results. Each `DetailedHadith` may have zero or more categories.

```dart
class HadithCategory {
  final String id;                  // Category ID (hash from URL)
  final String name;                // Arabic category name
}
```

Usage:
```dart
final results = await client.searchHadithDetailed(
  HadithSearchParams(value: 'الصلاة'),
);

for (var hadith in results.data) {
  if (hadith.categories.isNotEmpty) {
    print('Categories:');
    for (var cat in hadith.categories) {
      print('  - ${cat.name} (${cat.id})');
    }
  }
}
```

### UsulHadith (Sources)

Represents a hadith with all its sources.

```dart
class UsulHadith {
  final DetailedHadith hadith;      // Detailed hadith with metadata
  final List<UsulSource> sources;   // All sources
  final int count;                  // Sources count
}

// Single source entry
class UsulSource {
  final String source;              // Source name and page
  final String chain;               // Chain of narration
  final String hadithText;          // Hadith text in this source
}
```

Example:
```dart
final usulResponse = await client.hadith.getUsul('12345');
final usul = usulResponse.data;

print('Sources: ${usul.count}');
for (var source in usul.sources) {
  print('Source: ${source.source}');
  print('Chain: ${source.chain}');
}
```

### BookInfo

Full book details (via API).

```dart
class BookInfo {
  final String name;                // Book name
  final String bookId;              // Unique ID
  final String author;              // Author
  final String reviewer;            // Reviewer
  final String publisher;           // Publisher
  final String edition;             // Edition
  final String editionYear;         // Year of edition
}
```

Usage:
```dart
final book = await client.book.getById('6216');
print('${book.name} - ${book.author}');
print('Publisher: ${book.publisher}');
```

### MohdithInfo

Full hadith scholar (mohdith) details (via API).

```dart
class MohdithInfo {
  final String name;                // Scholar name
  final String mohdithId;           // Unique ID
  final String info;                // Biography and details
}
```

Usage:
```dart
final mohdith = await client.mohdith.getById('256');
print('Name: ${mohdith.name}');
print('Bio: ${mohdith.info}');
```

### Reference Items

Lightweight items for offline filtering. All extend `ReferenceItem`.

#### BookItem

```dart
class BookItem extends ReferenceItem {
  final String id;                  // Book ID
  final String name;                // Book name
  final String? author;             // Author (if any)
  final String? mohdithId;          // Hadith scholar (mohdith) author ID
  final String? category;           // Category (if any)
}
```

Usage:
```dart
// Offline search in books
final books = await client.bookRef.searchBook('صحيح', limit: 10);
for (var book in books) {
  print('${book.name} - ${book.author}');
  
  // Get full details (online)
  final fullInfo = await client.book.getById(book.id);
}
```

#### MohdithItem

```dart
class MohdithItem extends ReferenceItem {
  final String id;                  // Scholar ID
  final String name;                // Scholar name
  final int? deathYear;             // Death year (Hijri)
  final String? era;                // Era (if any)
}
```

Usage:
```dart
// Offline search in scholars
final scholars = await client.mohdithRef.searchMohdith('البخاري', limit: 5);
for (var scholar in scholars) {
  print('${scholar.name}');
  if (scholar.deathYear != null) {
    print('Died in: ${scholar.deathYear} AH');
  }
}
```

#### RawiItem

```dart
class RawiItem extends ReferenceItem {
  final String id;                  // Narrator ID
  final String name;                // Narrator name
}
```

Usage:
```dart
// Offline narrator search
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 3);
for (var narrator in narrators) {
  print(narrator.name);
}

// Counts
final total = await client.rawiRef.countRawi();
final searchCount = await client.rawiRef.countRawi(query: 'عبد الله');
```

### ApiResponse

Paginated search operations return results inside `ApiResponse` to simplify pagination. Single-item lookups return the model directly (see [Important Note](#important-note)).

```dart
class ApiResponse<T> {
  final T data;                     // Actual data (hadith, list, etc.)
  final SearchMetadata metadata;    // Extra info about the result
}
```

Examples:
```dart
// Search returns ApiResponse<List<Hadith>>
final response = await client.searchHadith(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

print('Count: ${response.data.length}');
print('Current page: ${response.metadata.page}');
print('From cache: ${response.metadata.isCached}');

// Usul returns ApiResponse<UsulHadith>
final usulResponse = await client.hadith.getUsul('12345');
print('Sources: ${usulResponse.data.count}');
```

### SearchMetadata

Additional info about a search result.

```dart
class SearchMetadata {
  final int length;                      // Number of returned results
  final int? currentPageCount;           // Number of results on this page
  final int? total;                      // Total results across all pages
  final int? page;                       // Current page number
  final int? totalPages;                 // Total number of pages
  final bool? hasNextPage;               // Whether there is a next page
  final bool? hasPrevPage;               // Whether there is a previous page
  final bool? removeHtml;                // Whether HTML tags were removed
  final bool? specialist;                // Include specialist hadiths?
  final int? numberOfNonSpecialist;      // Non-specialist count
  final int? numberOfSpecialist;         // Specialist count
  final bool isCached;                   // Result from cache?
  final int? usulSourcesCount;           // Sources count (for Usul requests)
  
  // Create a modified copy
  SearchMetadata copyWith({...});
}
```

Usage:
```dart
final response = await client.searchHadith(params);
final meta = response.metadata;

if (meta.isCached) {
  print('Result is from cache - fast!');
}

print('Page ${meta.page} of ${meta.totalPages}');
print('Total results: ${meta.total}');
print('Results on this page: ${meta.currentPageCount}');

if (meta.hasNextPage == true) {
  print('More results available on the next page');
}
```

### HadithSearchParams

All search filters and parameters.

```dart
class HadithSearchParams {
  // Required
  final String value;                    // Search text
  
  // Optional - search options
  final int page;                        // Page (default: 1)
  final bool removeHtml;                 // Remove HTML (default: true)
  final bool specialist;                 // Include specialist hadiths (default: false)
  final String? exclude;                 // Words/phrases to exclude
  
  // Optional - filters
  final SearchMethod? searchMethod;      // Search method (all/any/exact)
  final SearchZone? zone;                // Hadith type (Marfoo/Qudsi/Athar/Sharh)
  final List<HadithDegree>? degrees;     // Filter by grade
  final List<MohdithReference>? mohdith; // Filter by scholars
  final List<BookReference>? books;      // Filter by books
  final List<RawiReference>? rawi;       // Filter by narrators
  
  // Create a modified copy
  HadithSearchParams copyWith({...});
}
```

Examples:

```dart
// Minimal search
final simple = HadithSearchParams(value: 'الصلاة', page: 1);

// With specific filters
final filtered = HadithSearchParams(
  value: 'الإيمان',
  page: 1,
  degrees: [HadithDegree.authenticHadith],      // Sahih only
  mohdith: [MohdithReference.bukhari],          // Al-Bukhari only
  books: [BookReference.sahihBukhari],          // Sahih al-Bukhari only
  searchMethod: SearchMethod.allWords,          // All words
  zone: SearchZone.qudsi,                       // Qudsi hadiths
);

// Advanced with exclusions
final advanced = HadithSearchParams(
  value: 'الجنة النار',
  page: 1,
  exclude: 'الدنيا',                           // Exclude the word "الدنيا"
  degrees: [
    HadithDegree.authenticHadith,
    HadithDegree.authenticChain,
  ],
  mohdith: [
    MohdithReference.bukhari,
    MohdithReference.muslim,
  ],
  searchMethod: SearchMethod.anyWord,           // Any word
  removeHtml: true,                             // Remove HTML
);

// Modify existing params
final modified = simple.copyWith(
  page: 2,                                      // Go to page 2
  degrees: [HadithDegree.authenticHadith],     // Add filter
);

final results = await client.searchHadithDetailed(advanced);
```

### HadithDegree

Static values representing hadith grading according to scholars.

```dart
enum HadithDegree {
  all,                   // All grades (no filter)
  authenticHadith,       // Scholars ruled the hadith itself as sahih
  authenticChain,        // Scholars ruled the chain as sahih
  weakHadith,            // Scholars ruled the hadith as weak
  weakChain,             // Scholars ruled the chain as weak
  
  // Each value has:
  final String id;       // ID used in the API
  final String label;    // Arabic label
}
```

Usage:
```dart
// Filter sahih only
final params = HadithSearchParams(
  value: 'الصدقة',
  page: 1,
  degrees: [HadithDegree.authenticHadith],
);

// Sahih (hadith or chain)
final params2 = HadithSearchParams(
  value: 'الصدقة',
  page: 1,
  degrees: [
    HadithDegree.authenticHadith,
    HadithDegree.authenticChain,
  ],
);

// Helpers
print(HadithDegree.authenticHadith.toString()); // Arabic label
print(HadithDegree.authenticHadith.toQueryParam()); // API id
```

### SearchMethod

How the text search is performed.

```dart
enum SearchMethod {
  allWords,                     // All words (AND)
  anyWord,                      // Any word (OR)
  exactMatch,                   // Exact phrase
  
  // Each value has:
  final String id;              // API id
  final String label;           // Arabic label
}
```

Usage:
```dart
// All words (AND)
final allWords = HadithSearchParams(
  value: 'الصلاة الزكاة',
  page: 1,
  searchMethod: SearchMethod.allWords, // Must contain both words
);

// Any word (OR)
final anyWord = HadithSearchParams(
  value: 'الصلاة الزكاة',
  page: 1,
  searchMethod: SearchMethod.anyWord,  // Contains either word
);

// Exact phrase
final exact = HadithSearchParams(
  value: 'إنما الأعمال بالنيات',
  page: 1,
  searchMethod: SearchMethod.exactMatch, // Exact phrase
);

// Helpers
print(SearchMethod.allWords.toString()); // "جميع الكلمات"
print(SearchMethod.allWords.toQueryParam()); // "w"
```

### SearchZone

Filters by hadith type.

```dart
enum SearchZone {
  all,                          // All hadiths (no filter)
  marfoo,                       // Marfoo (attributed to the Prophet ﷺ)
  qudsi,                        // Qudsi (from Allah)
  sahabaAthar,                  // Companions' athar
  sharh,                        // Explanations (shuruh)
  
  // Each value has:
  final String id;              // API id
  final String label;           // Arabic label
}
```

Usage:
```dart
// Qudsi only
final qudsi = HadithSearchParams(
  value: 'الجنة',
  page: 1,
  zone: SearchZone.qudsi,
);

// Marfoo only
final marfoo = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  zone: SearchZone.marfoo,
);

// Sahaba athar
final athar = HadithSearchParams(
  value: 'عمر بن الخطاب',
  page: 1,
  zone: SearchZone.sahabaAthar,
);

// Helpers
print(SearchZone.qudsi.toString()); // "الأحاديث القدسية"
print(SearchZone.qudsi.toQueryParam()); // "1"
```

### Client Options

You can customize `DorarClient` when creating it.

```dart
final client = DorarClient(
  timeout: Duration(seconds: 15),       // Request timeout (default: 15s)
  // Caching is enabled by default using a persistent SQLite database
  // (cache.db on native, WebAssembly on web)
);
```

### Persistent Caching

API response caching uses a persistent SQLite database (`cache.db` on native CLI, WebAssembly on web). It is separate from the offline reference assets (`book.json`, `mohdith.json`, `rawi.db`).

API responses are cached in a shared `CacheService` backed by SQLite (`cache.db`) plus an in-memory layer (default: 100 entries, 7-day TTL).
- **Native Platforms (CLI)**: `cache.db` is created in the current working directory.
- **Flutter (native)**: When using [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter), the offline `rawi.db` is copied into the application support directory and persists across restarts. API response caching follows the platform default (`cache.db` in the CWD unless you customize `CacheDatabase.configureConnection`).
- **Web**: Uses `sqlite3.wasm` and `drift_worker.dart.js` (see [Offline Data, Assets & Platform Behavior](#offline-data-assets--platform-behavior)).

A cache miss is not an error — the client fetches from Dorar.net and stores the result. Cached hits set `SearchMetadata.isCached` to `true` on `ApiResponse` results. Expired entries are deleted and treated as a miss. Corrupt cached JSON throws `FormatException` from `jsonDecode` (not a `DorarException`); call `client.clearCache()` to recover. SQLite or WebAssembly storage failures propagate as platform/Drift errors and are not wrapped.

All services share one cache. `client.clearCache()` and every `*.clearCache()` on API services (`hadith`, `sharh`, `book`, `mohdith`) clear the entire shared cache, not an isolated per-service store.

```dart
// Clear all cached API responses
await client.clearCache();

// Equivalent — clears the same shared cache
await client.hadith.clearCache();
```

### Resource Cleanup

Always call `dispose()` when done to close database connections and avoid warnings.

```dart
void main() async {
  final client = DorarClient();
  
  try {
    // Use the library
    final results = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );
  } finally {
    // Mandatory cleanup
    await client.dispose();
  }
}
```

### Error Handling

The library uses a sealed class hierarchy for exceptions, enabling safer handling with pattern matching. All API/network failures throw a `DorarException` subclass — there is no separate `DorarApiException` type. Offline reference asset/database failures are documented in [Offline failure modes](#offline-failure-modes); reference lookups by unknown ID return empty lists or `null` instead of throwing.

#### Exception naming

| What you catch | Notes |
|---|---|
| `DorarException` | Sealed base for all API/network errors listed below |
| `DorarTimeoutException` | Public timeout type; Dart's internal `TimeoutException` from `.timeout()` is caught inside `DorarHttpClient` and converted — callers never see it |
| `DorarValidationException` | Client-side input validation (`DorarValidationException`, not a generic `ValidationException`) |
| `FormatException` | Corrupt cached JSON or offline asset JSON after load — not a `DorarException` |

#### DorarException Types

All errors extend `DorarException` with the following types:

```dart
// Base — every subclass has:
sealed class DorarException {
  final String message;
  final dynamic details;      // optional extra context
  final int? statusCode;      // set on HTTP-related subclasses
}

// 1. Network error — connectivity or unexpected HTTP status (not 200/404/429/5xx)
DorarNetworkException { final String message; final dynamic details; }

// 2. Timeout — request exceeded timeout after retries (default: 3 attempts)
DorarTimeoutException { final String message; final Duration timeout; final dynamic details; }

// 3. Not found — HTTP 404 or domain-specific missing resource
DorarNotFoundException { final String message; final String resource; final dynamic details; }

// 4. Validation error — invalid client-side input before the request is sent
DorarValidationException { final String message; final String? field; final String? rule; final dynamic details; }

// 5. Server error — HTTP 5xx or unexpected/empty Dorar response payload
DorarServerException { final String message; final int statusCode; final dynamic details; }

// 6. Parse error — HTML/JSON parsing failed after a successful HTTP response
DorarParseException { final String message; final String? rawData; final Type? expectedType; final dynamic details; }

// 7. Rate limit — HTTP 429
DorarRateLimitException { final String message; final int? limit; final DateTime? resetAt; final dynamic details; }
```

#### HTTP layer (`DorarHttpClient`)

Every online API call goes through `DorarHttpClient` (default timeout: 15 seconds, max retries: 3, exponential backoff starting at 1 second).

| Condition | Exception | Retried? |
|---|---|---|
| `TimeoutException` on a request | `DorarTimeoutException` (after final attempt) | Yes |
| `http.ClientException` (connectivity) | `DorarNetworkException` (after final attempt) | Yes |
| HTTP 404 | `DorarNotFoundException` | No |
| HTTP 429 | `DorarRateLimitException` | No |
| HTTP 5xx | `DorarServerException` | No |
| Other HTTP status | `DorarNetworkException` | No |
| Unexpected error in HTTP client | `DorarNetworkException` | No |

`DorarException` subclasses raised by the HTTP layer are rethrown immediately without retry.

#### When each public API throws

| Method / service | `DorarValidationException` | Other `DorarException` | Returns empty/null instead |
|---|---|---|---|
| `searchHadith` / `hadith.searchViaApi` | — (no local validation) | Network/timeout/rate-limit; `DorarServerException` if response JSON is invalid or zero hadiths parse | — |
| `searchHadithDetailed` / `hadith.searchViaSite` | — | Network/timeout/rate-limit; `DorarServerException` if expected HTML tab is missing | Empty `data` list when page parses but has no hadiths |
| `getHadithById` / `hadith.getById` | Invalid `hadithId` | Network/timeout/404; `DorarServerException` if page structure is unexpected | — |
| `getSimilarHadith` / `hadith.getSimilar` | Invalid `hadithId` | Network/timeout/404 | Empty list |
| `getAlternateHadith` / `hadith.getAlternate` | Invalid `hadithId` | Network/timeout/404 | `null` when the page has no alternate block or parsing that block fails |
| `getUsulHadith` / `hadith.getUsul` | Invalid `hadithId` | Network/timeout; `DorarNotFoundException` when usul section is missing | — |
| `searchSharh` / `sharh.search` | Empty/too-long `value`; `page` not in 1–1000 | Network/timeout; `DorarServerException` if expected HTML tab is missing | Empty `data` when search finds no sharh IDs |
| `getSharhByText` / `sharh.getByText` | Empty/too-long `text` | Network/timeout; `DorarNotFoundException` when no sharh ID is found in search results | — |
| `getSharhById` / `sharh.getById` | Invalid numeric `sharhId` | Network/timeout/404; `DorarParseException` on parse failure | — |
| `book.getById` | Invalid numeric `bookId` | Network/timeout/404; `DorarParseException` on parse failure | — |
| `mohdith.getById` | Invalid numeric `mohdithId` | Network/timeout/404; `DorarParseException` on parse failure | — |
| `searchBooks`, `searchMohdith`, `searchRawi`, `*Ref.*` | — | `bookRef`/`mohdithRef`: `AssetLoaderException` on first load if assets missing (see [Offline failure modes](#offline-failure-modes)); `rawiRef`: generic `Exception` if `rawi.db` missing on native CLI | Empty list on no match; `get*ById` returns `null` |

Malformed JSON in an HTTP 200 body throws `FormatException` from `jsonDecode` (not `DorarException`). HTML/body parsing failures inside services become `DorarParseException`.

Input validation rules (client-side, before HTTP):
- Search text (`sharh.getByText`, `sharh.search` only): required, max 500 characters. **`searchHadith` and `searchHadithDetailed` do not validate `value` or `page` locally** — invalid values are sent to Dorar as-is.
- Page (`sharh.search` only): 1–1000.
- Hadith ID (`getById`, `getSimilar`, `getAlternate`, `getUsul`): non-empty alphanumeric plus `-` / `_`.
- Sharh / book / mohdith IDs: non-empty numeric strings.
- `DorarClient(timeout: ...)` / `DorarClient.use(timeout: ...)`: positive duration, max 5 minutes (validated in `DorarHttpClient` constructor).

#### Cache, disposal, and `DorarClient.use()`

- **Cache miss**: not an error; the client fetches and caches transparently.
- **Cache hit**: parsed response returned; `SearchMetadata.isCached = true` on `ApiResponse` results.
- **Expired entry**: deleted and treated as a miss.
- **Corrupt cached JSON**: `FormatException` from `jsonDecode` — clear with `client.clearCache()`.
- **Storage failure**: SQLite/Drift or WebAssembly errors propagate unwrapped (not `DorarException`).
- **`dispose()`**: closes the HTTP client, cache database, and narrator database; does not throw under normal use. Do not reuse a disposed client — create a new `DorarClient` or use `DorarClient.use()`.
- **`DorarClient.use(fn)`**: creates a client, runs `fn`, and always calls `dispose()` in a `finally` block (even when `fn` throws). Accepts an optional `timeout` (default: 15 seconds).

#### Comprehensive Handling with Switch Expression

```dart
try {
  final results = await client.searchHadith(
    HadithSearchParams(value: 'الصلاة', page: 1),
  );
} on DorarException catch (e) {
  // Pattern matching - compiler ensures coverage!
  final message = switch (e) {
    DorarNetworkException() => 
      '🌐 Network error: ${e.message}\n'
      'Please check your internet connection',
      
    DorarTimeoutException() => 
      '⏱️ Request timed out after ${e.timeout.inSeconds} seconds\n'
      'Try again later',
      
    DorarNotFoundException() => 
      '🔍 Not found: ${e.resource}\n'
      'Verify the identifier',
      
    DorarValidationException() => 
      '✋ Validation error: ${e.message}\n'
      '${e.field != null ? "Field: ${e.field}" : ""}',
      
    DorarServerException() => 
      '🖥️ Server error (${e.statusCode}): ${e.message}',
      
    DorarParseException() => 
      '📄 Parse error: ${e.message}',
      
    DorarRateLimitException() => 
      '🚫 Rate limit exceeded\n'
      '${e.resetAt != null ? "Retry after: ${e.resetAt}" : ""}',
  };
  
  print(message);
}
```

#### Helper Function for Error Messages

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

try {
  final results = await client.searchHadith(params);
} on DorarException catch (e) {
  // Use the helper
  print(getExceptionMessage(e));
}
```

## Available Services

`DorarClient` exposes multiple focused services, each responsible for specific functionality.

### Hadith Service

The core service for searching and fetching hadiths.

```dart
final client = DorarClient();

// 1. Quick search (API - ~15 results)
final quickResults = await client.searchHadith(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

// 2. Detailed search (Site - ~30 results)
final detailedResults = await client.searchHadithDetailed(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

// 3. Get by ID
final hadith = await client.getHadithById('12345');

// Or use the service directly
final sameResults = await client.hadith.searchViaApi(params);
final sameDetailed = await client.hadith.searchViaSite(params);
final sameHadith = await client.hadith.getById('12345');

// 4. Similar hadiths
if (hadith.hasSimilarHadith && hadith.hadithId != null) {
  final similar = await client.hadith.getSimilar(hadith.hadithId!);
  print('Found ${similar.length} similar hadiths');
}

// 5. Alternate sahih
if (hadith.hasAlternateHadithSahih && hadith.hadithId != null) {
  final alternate = await client.hadith.getAlternate(hadith.hadithId!);
  if (alternate != null) {
    print('Alternate sahih: ${alternate.hadith}');
  }
}

// 6. Usul (sources)
if (hadith.hasUsulHadith && hadith.hadithId != null) {
  final usulResponse = await client.hadith.getUsul(hadith.hadithId!);
  final usul = usulResponse.data;
  print('Sources: ${usul.count}');
  for (var source in usul.sources) {
    print('- ${source.source}: ${source.chain}');
  }
}

// 7. Clear shared cache (all API services)
await client.hadith.clearCache();
```

### Sharh Service

Search and retrieve hadith explanations.

```dart
// 1. Search by hadith text
final sharh = await client.sharh.getByText('إنما الأعمال بالنيات');

// You can also search in specialist hadiths
final specialistSharh = await client.sharh.getByText(
  'نص الحديث',
  specialist: true,
);

// 2. Get by ID
// (ID comes from DetailedHadith.sharhMetadata.id)
final hadith = await client.getHadithById('12345');
if (hadith.hasSharhMetadata && hadith.sharhMetadata != null) {
  final sharhId = hadith.sharhMetadata!.id;
  final sharh = await client.sharh.getById(sharhId);
  
  if (sharh.sharhText != null) {
    print('Sharh: ${sharh.sharhText}');
  }
}

// 3. Search for all sharh matching a query
final sharhResults = await client.searchSharh(
  HadithSearchParams(value: 'الصلاة'),
);
for (var s in sharhResults.data) {
  print('Hadith: ${s.hadith}');
  print('Sharh: ${s.sharhText}');
}

// 4. Clear shared cache (all API services)
await client.sharh.clearCache();
```

### Book Service (Detailed)

Fetch detailed book info (requires internet).

```dart
// Get book by ID
final book = await client.book.getById('6216'); // Sahih al-Bukhari

print('Book: ${book.name}');
print('Author: ${book.author}');
print('Reviewer: ${book.reviewer}');
print('Publisher: ${book.publisher}');
print('Edition: ${book.edition}');
print('Edition Year: ${book.editionYear}');

// Clear shared cache (all API services)
await client.book.clearCache();
```

### Mohdith Service (Detailed)

Fetch detailed scholar info (requires internet).

```dart
// Get scholar by ID
final mohdith = await client.mohdith.getById('256'); // Imam al-Bukhari

print('Name: ${mohdith.name}');
print('Bio: ${mohdith.info}');

// Clear shared cache (all API services)
await client.mohdith.clearCache();
```

### Book Reference Service (Offline)

Search available books without internet.

```dart
// 1. Search by name
final books = await client.bookRef.searchBook('صحيح', limit: 10);

// Or shortcut
final sameBooks = await client.searchBooks('صحيح');

for (var book in books) {
  print('${book.name} - ${book.author}');
}

// 2. Get by ID
final bukhari = await client.bookRef.getBookById('6216');
print(bukhari.name); // صحيح البخاري

// 3. Get multiple by IDs
final multipleBooks = await client.bookRef.getBooksByIds([
  '6216', // Sahih al-Bukhari
  '3088', // Sahih Muslim
]);

// 4. List all with pagination
final allBooks = await client.bookRef.getAllBooks(
  limit: 50,
  offset: 0,
);

// 5. Counts
final totalBooks = await client.bookRef.countBooks();
final sahihBooks = await client.bookRef.countBooks(query: 'صحيح');
print('Total books: $totalBooks');
print('"Sahih" books: $sahihBooks');
```

### Mohdith Reference Service (Offline)

Search available scholars without internet.

```dart
// 1. Search by name
final scholars = await client.mohdithRef.searchMohdith('البخاري', limit: 5);

// Or shortcut
final sameScholars = await client.searchMohdith('البخاري');

for (var scholar in scholars) {
  print('${scholar.name}');
  if (scholar.deathYear != null) {
    print('Death year: ${scholar.deathYear} AH');
  }
}

// 2. Get by ID
final bukhari = await client.mohdithRef.getMohdithById('256');
print(bukhari.name); // البخاري

// 3. Get multiple by IDs
final multipleScholars = await client.mohdithRef.getMohdithByIds([
  '256',  // al-Bukhari
  '261',  // Muslim
]);

// 4. List all with pagination
final allScholars = await client.mohdithRef.getAllMohdith(
  limit: 50,
  offset: 0,
);

// 5. Counts
final totalScholars = await client.mohdithRef.countMohdith();
final classicalScholars = await client.mohdithRef.countMohdith(
  query: 'أحمد',
);
print('Total scholars: $totalScholars');
```

### Rawi Reference Service (Offline)

Search available narrators without internet.

```dart
// 1. Search by name
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 10);

// Or shortcut
final sameNarrators = await client.searchRawi('أبو هريرة');

for (var narrator in narrators) {
  print(narrator.name);
}

// 2. Get by ID
final abuHurayrah = await client.rawiRef.getRawiById(1416);
print(abuHurayrah.name); // أبو هريرة عبد الرحمن بن صخر الدوسي

// 3. Get multiple by IDs
final multipleNarrators = await client.rawiRef.getRawiByIds([
  1416,   // Abu Hurayrah
  5593,   // Aishah
]);

// 4. List all with pagination
final allNarrators = await client.rawiRef.getAllRawi(
  limit: 100,
  offset: 0,
);

// 5. Counts
final totalNarrators = await client.rawiRef.countRawi();
final abdullahNarrators = await client.rawiRef.countRawi(query: 'عبد الله');
print('Total narrators: $totalNarrators');
print('"Abdullah" narrators: $abdullahNarrators');
```

### Predefined Filter Constants

The library provides predefined constants for common scholars, books, and narrators to simplify filtering.

#### MohdithReference (Scholars)

```dart
// 20 scholars
MohdithReference.all             // All (no filter) - ID: 0
MohdithReference.malik           // Imam Malik - ID: 179
MohdithReference.shafii          // Imam al-Shafi'i - ID: 204
MohdithReference.ahmad           // Imam Ahmad - ID: 241
MohdithReference.bukhari         // al-Bukhari - ID: 256
MohdithReference.muslim          // Muslim - ID: 261
MohdithReference.ibnMajah        // Ibn Majah - ID: 273
MohdithReference.abuDawud        // Abu Dawud - ID: 275
MohdithReference.tirmidhi        // al-Tirmidhi - ID: 279
MohdithReference.nasai           // al-Nasa'i - ID: 303
MohdithReference.sufyanThawri    // Sufyan al-Thawri - ID: 161
MohdithReference.ibnMubarak      // Abdullah b. al-Mubarak - ID: 181
MohdithReference.sufyanIbnUyaynah // Sufyan b. 'Uyaynah - ID: 198
MohdithReference.ishaqIbnRahawayh // Ishaq b. Rahawayh - ID: 238
MohdithReference.darimi          // al-Darimi - ID: 250
MohdithReference.ibnKhuzaymah    // Ibn Khuzaymah - ID: 311
MohdithReference.ibnHibban       // Ibn Hibban - ID: 354
MohdithReference.hakim           // al-Hakim - ID: 405
MohdithReference.bayhaqi         // al-Bayhaqi - ID: 458
MohdithReference.tabarani        // al-Tabarani - ID: 360

// Each value has id and name
final bukhari = MohdithReference.bukhari;
print(bukhari.id);    // "256"
print(bukhari.name);  // "البخاري"

// Use in filters
final params = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  mohdith: [MohdithReference.bukhari],
);

// Get numeric id if needed
final bukhariId = int.parse(MohdithReference.bukhari.id);
```

#### BookReference (Books)

```dart
// 21 books
BookReference.all                 // All (no filter)
BookReference.sahihBukhari        // Sahih al-Bukhari (6216)
BookReference.sahihMuslim         // Sahih Muslim (3088)
BookReference.arbainNawawi        // Al-Arba'in al-Nawawiyyah (13457)
BookReference.sahihMusnad         // Al-Sahih al-Musnad (96)
BookReference.sunanAbuDawud       // Sunan Abi Dawud (4549)
BookReference.jamiTirmidhi        // Jami' al-Tirmidhi (3662)
BookReference.sunanNasai          // Sunan al-Nasa'i (5766)
BookReference.sunanIbnMajah       // Sunan Ibn Majah (5299)
BookReference.musnadAhmad         // Musnad Ahmad (14)
BookReference.muwattaMalik        // Muwatta' Malik (6453)
BookReference.musnadDarimi        // Sunan al-Darimi (6277)
BookReference.sahihIbnKhuzaymah   // Sahih Ibn Khuzaymah (3024)
BookReference.sahihIbnHibban      // Sahih Ibn Hibban (5876)
BookReference.mustadrakHakim      // Al-Mustadrak (2800)
BookReference.sunanBayhaqiKubra   // Al-Sunan al-Kubra (7989)
BookReference.sunanDaraqutni      // Sunan al-Daraqutni (3233)
BookReference.musannafIbnAbiShaybah // Musannaf Ibn Abi Shaybah (6598)
BookReference.musannafAbdRazzaq   // Musannaf 'Abd al-Razzaq (7613)
BookReference.riyadSalihin        // Riyad al-Salihin (10106)
BookReference.bulughMaram         // Bulugh al-Maram (9927)

// Each value has id and name
final bukhari = BookReference.sahihBukhari;
print(bukhari.id);    // "6216"
print(bukhari.name);  // "صحيح البخاري"

// Use in filters
final params = HadithSearchParams(
  value: 'الزكاة',
  page: 1,
  books: [
    BookReference.sahihBukhari,
    BookReference.sahihMuslim,
  ],
);

// Get numeric id if needed
final bukhariId = int.parse(BookReference.sahihBukhari.id);
```

#### RawiReference (Narrators)

Note: There are ~14,000 narrators in the database, so only some companions are provided as constants.

```dart
// 20 companions
RawiReference.all                // All (no filter)
RawiReference.abuHurayrah        // Abu Hurayrah (1416)
RawiReference.aisha              // Aishah (6617)
RawiReference.ibnAbbas           // Ibn Abbas (2664)
RawiReference.ibnUmar            // Abdullah b. Umar (7687)
RawiReference.anasBinMalik       // Anas b. Malik (2177)
RawiReference.jabirIbnAbdullah  // Jabir b. Abdullah (3971)
RawiReference.abuSaidKhudri      // Abu Sa'id al-Khudri (779)
RawiReference.ibnMasud           // Abdullah b. Mas'ud (7918)
RawiReference.abuMusaAshari      // Abu Musa al-Ash'ari (1342)
RawiReference.umarIbnKhattab     // Umar b. al-Khattab (8918)
RawiReference.aliIbnAbiTalib     // Ali b. Abi Talib (8637)
RawiReference.abuBakr            // Abu Bakr al-Siddiq (455)
RawiReference.uthmanIbnAffan     // Uthman b. Affan (8310)
RawiReference.salmanFarisi       // Salman al-Farisi (5947)
RawiReference.muadhIbnJabal      // Mu'adh b. Jabal (10349)
RawiReference.abuDharr           // Abu Dharr al-Ghifari (667)
RawiReference.bilal              // Bilal b. Rabah (3808)
RawiReference.zaydIbnThabit      // Zayd b. Thabit (5545)
RawiReference.ubayyIbnKab        // Ubayy b. Ka'b (1695)
RawiReference.abuAyyub           // Abu Ayyub al-Ansari (129)

// Each value has id and name
final abuHurayrah = RawiReference.abuHurayrah;
print(abuHurayrah.id);    // "1416"
print(abuHurayrah.name);  // "أبو هريرة"

// Use in filters
final params = HadithSearchParams(
  value: 'الجنة',
  page: 1,
  rawi: [RawiReference.abuHurayrah],
);

// Get numeric id if needed
final abuHurayrahId = int.parse(RawiReference.abuHurayrah.id);

// To find more narrators, use the search service
final narrators = await client.rawiRef.searchRawi('عبد الله', limit: 10);
```

### Seeing "Unclosed database" Warning?

Always call `client.dispose()`:

```dart
final client = DorarClient();
try {
  // Use the library
} finally {
  await client.dispose(); // Mandatory
}
```

Or if you don't want to think about it, use `DorarClient.use` method instead, it will automatically dispose of the client after it finished:
```dart
final results = await DorarClient.use((client) async {
    return await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );
  });
```

## Migration (0.5.0)

If you previously called `configureFlutterAssetLoader` or `createFlutterConnectionFactory` from `dorar_hadith`, switch to [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter):

```dart
await DorarHadithFlutter.ensureInitialized();
```

Those helpers were removed from the core package in 0.5.0.

## Contributing

All forms of contributions are welcome.  
## License

MIT License - see [LICENSE](LICENSE) file.

## Architecture

```
DorarClient (Facade)
    ├── HadithService
    ├── SharhService  
    ├── BookService
    ├── MohdithService
    ├── MohdithRefService 
    ├── BookRefService 
    └── RawiRefService 
         └── HTTP Client + Cache
              └── HTML Parsers
```

— May Allah reward us and you.
