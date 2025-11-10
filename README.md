# بسم الله الرحمن الرحيم
# Dorar Hadith

# تغيير اللغة: [ 🇸🇦 AR](README.md)

---

A Dart library to search and retrieve hadith and related data from Dorar Al-Sanniyah.

Inspired by and partially based on the repository [dorar-hadith-api](https://github.com/AhmedElTabarani/dorar-hadith-api) by [Ahmed Al-Tabarani](https://github.com/AhmedElTabarani).
Works with any Dart program without requiring Flutter.

[![pub package](https://img.shields.io/pub/v/dorar_hadith.svg)](https://pub.dev/packages/dorar_hadith)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Terminology

- In this README, the word "scholar" always means a hadith scholar (mohdith). We keep the term "mohdith" in code and types to match the API and models.

## Library Highlights

- Fast hadith search with filters by narrator, book, grade, hadith scholar (mohdith), and more
- Retrieve detailed hadith information
- Search and fetch hadith explanations (Sharh)
- Find similar hadiths and alternate sahih versions
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
flutter pub add dorar_hadith
```

## Quick Start

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

void main() async {
  // Create the client
  final client = DorarClient();

  try {
    // Search for hadiths about prayer
    final results = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );

    print('Found ${results.data.length} hadiths');

    // Print first hadith
    if (results.data.isNotEmpty) {
      final hadith = results.data.first;
      print('Hadith: ${hadith.hadith}');
      print('Narrator: ${hadith.rawi}');
      print('Scholar: ${hadith.mohdith}');
      print('Grade: ${hadith.grade}');
    }
  } on DorarException catch (e) {
    print('Error: ${getExceptionMessage(e)}');
  } finally {
    // Clean up resources (important: closes database connections)
    await client.dispose();
  }
}
```

For a complete example covering all library features, see:
[`example/example.dart`](example/example.dart)

## Usage

### Important Note
Most operations in `DorarClient` and the other services return results inside an `ApiResponse` object to simplify pagination.
`ApiResponse` has two members:
- The result: `data`
- Pagination metadata: `SearchMetadata`

This makes it easier to request the next page when needed.

### Quick Hadith Search
Using `client.searchHadith` is fast, but the hadith info is partial and without identifiers (`hadithId, bookId, etc`).
- Results are limited to ~15 hadiths, and filters can be used.
- Each result includes:
  - Text: `Hadith.hadith`
  - Narrator: `Hadith.rawi`
  - Scholar: `Hadith.mohdith`
  - Book: `Hadith.book`
  - Number or page in the book: `Hadith.numberOrPage`
  - Grade: `Hadith.grade`

```dart
final results = await client.searchHadith(
  HadithSearchParams(value: 'الإيمان'),
);

for (var hadith in results.data) {
  print('${hadith.hadith}');
  print('Grade: ${hadith.grade}');
}
```

### Detailed Search with Filters
Note: Due to how Dorar works, in detailed search the verdict appears in `explainGrade`, not `grade`.

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

```dart
final hadith = await client.getHadithById('12345');
print('Hadith: ${hadith.hadith}');
print('Book: ${hadith.book}');
print('Grade: ${hadith.grade}');
```

### Similar, Usul (Sources), Alternate Sahih
Note: The `Hadith` model has flags to check availability:
- `hasAlternateHadithSahih` for alternate sahih
- `hasSimilarHadith` for similar hadiths
- `hasUsulHadith` for sources

```dart
// Get similar
final similar = await client.hadith.getSimilar('12345');

// Get alternate sahih
final alternate = await client.hadith.getAlternate('12345');

// Get sources
final usul = await client.hadith.getUsul('12345');
print('Main hadith: ${usul.hadith.hadith}');
print('Sources: ${usul.count}');
```

### Search for Sharh (Explanation)
Note: When using `client.searchHadithDetailed`, if a hadith has a sharh, you will find its ID in `sharhMetadata`. Use it as follows:

```dart
// Get sharh by ID
final sharh = await client.sharh.getById('789');

// Search by sharh text
final sharhByText = await client.sharh.getByText('إنما الأعمال بالنيات');
```

### Reference Data (Offline)
Reference data is used for filtering (hadith scholar [mohdith], book, narrator) and is available offline for speed and usability.

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
final abuHurayrah = await client.rawiRef.getRawiById(4396);

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
// ... 17 total

// Sample book constants
BookReference.sahihBukhari  
BookReference.sahihMuslim     
// ... 20 total

// Sample narrator constants
RawiReference.abuHurayrah     
RawiReference.aisha          
// ... 21 total

// Using constants in filters
final params = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  mohdith: [MohdithReference.Bukhari],
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

### Hadith Model

Represents a hadith with all its related information.

```dart
class Hadith {
  // Basic hadith info
  final String hadith;              // Hadith text
  final String? hadithId;           // Unique hadith ID
  
  // Chain and scholars
  final String rawi;                // Narrator name
  final String mohdith;             // Scholar name
  final String? mohdithId;          // Scholar ID
  
  // Source info
  final String book;                // Source book name
  final String? bookId;             // Book ID
  final String numberOrPage;        // Page number or hadith number in the book
  
  // Grading and takhrij
  final String grade;               // Hadith grade (Sahih, Da'if, etc.)
  final String? explainGrade;       // Grade explanation
  final String? takhrij;            // Takhrij information
  
  // Relations and links
  final bool hasSimilarHadith;           // Has similar hadiths?
  final bool hasAlternateHadithSahih;    // Has alternate sahih?
  final bool hasUsulHadith;              // Has sources?
  
  // Dorar links
  final String? similarHadithDorar;        // Similar hadiths link
  final String? alternateHadithSahihDorar; // Alternate sahih link
  final String? usulHadithDorar;           // Sources link
  
  // Sharh info
  final bool hasSharhMetadata;      // Has sharh available?
  final SharhMetadata? sharhMetadata; // Sharh metadata (if any)
}
```

Important:
- Use `hasSimilarHadith` to check before calling `client.hadith.getSimilar()`
- Use `hasAlternateHadithSahih` before `client.hadith.getAlternate()`
- Use `hasUsulHadith` before `client.hadith.getUsul()`
- Use `hasSharhMetadata`; if true, you’ll find `sharhMetadata.id`

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

### UsulHadith (Sources)

Represents a hadith with all its sources.

```dart
class UsulHadith {
  final Hadith hadith;              // Base hadith
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

All search and retrieval operations return results inside `ApiResponse` to simplify pagination.

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
  final int? page;                       // Current page number
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

print('Page ${meta.page} of ???');
print('Results: ${meta.length}');
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

```dart
final client = DorarClient(
  timeout: Duration(seconds: 15),       // Request timeout (default: 15s)
  enableCache: true,                    // Enable cache (default: true)
  cacheTtl: Duration(hours: 24),       // Cache TTL (default: 24h)
);
```

### Cache Management

```dart
// Cache stats
final stats = client.getCacheStats();
print('Total entries: ${stats.totalEntries}');
print('Valid entries: ${stats.validEntries}');
print('Hit rate: ${(stats.hitRate * 100).toStringAsFixed(1)}%');

// Clear all cache
client.clearCache();

// Clear per-service cache
client.hadith.clearCache();
client.sharh.clearCache();
client.book.clearCache();
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

The library uses a sealed class hierarchy for exceptions, enabling safer handling with pattern matching.

#### DorarException Types

All errors extend `DorarException` with the following types:

```dart
// 1. Network error - connectivity issues
DorarNetworkException {
  final String message;
  final String? details;
}

// 2. Timeout - request took too long
DorarTimeoutException {
  final String message;
  final Duration timeout;
  final String? details;
}

// 3. Not found - missing resource
DorarNotFoundException {
  final String message;
  final String resource;
  final String? details;
}

// 4. Validation error - invalid input
DorarValidationException {
  final String message;
  final String? field;        // Field name
  final String? rule;         // Violated rule
  final String? details;
}

// 5. Server error - Dorar server issue
DorarServerException {
  final String message;
  final int statusCode;       // HTTP status code
  final String? details;
}

// 6. Parse error - response parsing issue
DorarParseException {
  final String message;
  final String? expectedType; // Expected type
  final String? details;
}

// 7. Rate limit - too many requests
DorarRateLimitException {
  final String message;
  final int? limit;           // Max requests
  final DateTime? resetAt;    // Reset time
  final String? details;
}
```

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

// 7. Clear cache
client.hadith.clearCache();
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
// (ID comes from hadith.sharhMetadata.id)
final hadith = await client.getHadithById('12345');
if (hadith.hasSharhMetadata && hadith.sharhMetadata != null) {
  final sharhId = hadith.sharhMetadata!.id;
  final sharh = await client.sharh.getById(sharhId);
  
  if (sharh.sharhText != null) {
    print('Sharh: ${sharh.sharhText}');
  }
}

// 3. Clear cache
client.sharh.clearCache();
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

// Clear cache
client.book.clearCache();
```

### Mohdith Service (Detailed)

Fetch detailed scholar info (requires internet).

```dart
// Get scholar by ID
final mohdith = await client.mohdith.getById('256'); // Imam al-Bukhari

print('Name: ${mohdith.name}');
print('Bio: ${mohdith.info}');

// Clear cache
client.mohdith.clearCache();
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
  '3662', // Sahih Muslim
]);

// 4. List all with pagination
final allBooks = await client.bookRef.getAllBookss(
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
final abuHurayrah = await client.rawiRef.getRawiById(4396);
print(abuHurayrah.name); // أبو هريرة عبد الرحمن بن صخر الدوسي

// 3. Get multiple by IDs
final multipleNarrators = await client.rawiRef.getRawiByIds([
  4396,   // Abu Hurayrah
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
