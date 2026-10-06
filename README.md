# Dorar Hadith

[العربية](README_AR.md)

A Dart package for Dorar.net hadith search, explanations, related narrations, thematic categories and offline reference choices. The core works without Flutter; Flutter apps use `dorar_hadith_flutter`.

Version 0.6.1 requires Dart 3.13.0 or later. The Flutter adapter requires Flutter 3.47.5 or later. Read the migration guide before upgrading from 0.5.x.

## Contents

- [Setup](#setup)
- [Choose a search method](#choose-a-search-method)
- [Identifiers and discovered choices](#identifiers-and-discovered-choices)
- [Related hadiths and circumstances](#related-hadiths-and-circumstances)
- [Explanation text and safe formatting](#explanation-text-and-safe-formatting)
- [Speaker attribution](#speaker-attribution)
- [Thematic categories](#thematic-categories)
- [Offline references and upgrades](#offline-references-and-upgrades)
- [Browser setup](#browser-setup)
- [Cache and errors](#cache-and-errors)
- [Development and release](#development-and-release)

## Setup

Install the core package for Dart:

```sh
dart pub add dorar_hadith
```

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

Future<void> main() async {
  await DorarClient.use((client) async {
    final results = await client.searchHadithDetailed(
      const HadithSearchParams(
        value: 'الصلاة',
        types: {HadithTypeFilter.qudsi},
      ),
    );
    for (final record in results.data) {
      print('${record.hadithId}: ${record.hadith}');
      print('${record.book} | ${record.numberOrPage} | ${record.grade}');
    }
  });
}
```

For Flutter, install `dorar_hadith_flutter` and initialize it before creating a client:

```dart
WidgetsFlutterBinding.ensureInitialized();
await DorarHadithFlutter.ensureInitialized();
```

The adapter loads the core package's assets automatically. You do not need to list them in your app's `pubspec.yaml`. It stores verified reference copies in application support storage and keeps the writable API cache in a separate database.

## Choose a search method

| Method                                | Returns                                                                            | Pagination                                          |
| ------------------------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------- |
| `client.searchHadith(params)`         | Quick API results as lightweight `Hadith` records                                  | Usually 15 per page; total is unknown               |
| `client.searchHadithDetailed(params)` | `DetailedHadith` records with IDs, citations, categories and advertised links      | 30 per tab; ordinary search allows at most 10 pages |
| `client.sharh.search(params)`         | Full explanations linked from matching hadiths, with each originating relationship | Uses ordinary hadith search                         |
| `client.searchSharhText(params)`      | `SharhSnippet` results found inside explanation prose                              | 15 per page; later pages use AJAX fragments         |
| `client.categories.browse(params)`    | Hadiths in a thematic category                                                     | 20 per tab; separate from the ordinary search limit |

`SearchCapabilities.quick` and `.detailed` list supported options. A full quick or prose page suggests another page may exist; it does not prove it. Read `metadata.pagination.nextPageEvidence` and keep unknown totals null.

Detailed search accepts:

- `types`, `sort: HadithSort.degree` and up to four ordered `optionalPhrases`.
- Search method, excluded words, degrees, scholars, books and narrator choices.
- `specialist`, which selects Dorar's `متخصص` tab. It is a tab choice, not a hadith type.

The primary query can be empty when an optional phrase is nonblank. Empty phrase slots keep their position.

Quick search accepts text/page, the verified qudsi and companion scopes, search method, exclusions, degree, scholar and book filters. It rejects multiple scopes, explanation scope, optional phrases, sorting, specialist selection, marfoo scope and narrator-choice IDs before sending a request. Use detailed search for those filters.

`zone` is the legacy way to choose an ordinary scope. Use either `zone` or `types`. `SearchZone.sharh` is rejected; search explanation prose with this method:

```dart
final snippets = await client.searchSharhText(
  const SharhTextSearchParams(value: 'النية', page: 1),
);
final explanation = await client.sharh.getById(snippets.data.first.id);
```

## Identifiers and discovered choices

Hadith, explanation, book, scholar, narrator-choice and category IDs are separate types. `HadithRecordId('2065')` and `SharhId('2065')` are different identifiers. JSON stores their original string values. Existing methods that accept strings still work.

Use typed filters for choices returned by reference services:

```dart
final scholars = await client.searchMohdith('البخاري');
final books = await client.referenceDiscovery.getBooksForScholars(
  [scholars.first.typedId],
);
final results = await client.searchHadithDetailed(HadithSearchParams(
  value: 'الصيام',
  scholarIds: [scholars.first.typedId],
  bookIds: [BookId(books.data.first.id)],
));
```

`scholarIds`, `bookIds` and `narratorChoiceIds` replace the corresponding legacy `mohdith`, `books` and `rawi` lists. Choose one representation for each filter. Request IDs are deduplicated and sorted.

Books returned for scholars are sources associated with their hadith assessments. They are not necessarily books those scholars wrote. Result metadata keeps the selected scholar IDs and marks coverage as a current selection.

Narrator autocomplete makes an online request and has partial coverage:

```dart
final choices = await client.referenceDiscovery.searchNarratorChoices('أبو هريرة');
// Each ID is a filter choice; compound labels and aliases are not person identities.
```

## Related hadiths and circumstances

```dart
final alternatives = await client.getAlternates('i9N1PTUu');
final similar = await client.getSimilarResult('i9N1PTUu');
final circumstances = await client.getAsbab('wcyAMgeR');
final sources = await client.hadith.getUsul('j0j8uiR3');
```

Collection results separate the requested hadith from the related records and keep their source order. `getAlternates` returns every alternative. The legacy `getAlternate` returns the first, or null for a recognized empty collection.

`getSimilar` keeps its earlier behavior and includes the requested hadith in the list. Use `getSimilarResult` to get the source and related items separately.

Strict parsing is the default. A failed request, unknown layout or malformed record throws a typed exception. Choose `ParsePolicy.bestEffort` to retain valid records and receive candidate, parsed and skipped counts with bounded warnings. Its related-result source can be null when the requested seed cannot be identified; ambiguous records remain in the result.

Capability states (`advertised`, `notAdvertised`, `unknown`) describe what the source page advertises. They are separate from whether a later request succeeds. Fetching sources or circumstances does not add an advertisement. Each context record keeps its own scholar, verdict and locator.

## Explanation text and safe formatting

`Sharh.hadith` is a `DetailedHadith` parsed from the explanation page's header. `Sharh.embeddedHadith` holds a separately cited narration inside the body when its fields are available. `Sharh.document` holds the explanation's text, source HTML, blocks and annotations.

```dart
final explanation = await client.sharh.getById('137940');
final document = explanation.document!;
print(document.commentaryText);             // excludes embedded narration/citation
final safeHtml = renderDocumentHtml(document);
final tokens = documentRenderTokens(document);
```

Blocks distinguish narration, citation, commentary, chain, paragraph, heading, list item and separator. Annotations preserve each glossary term occurrence and definition, link label and destination, source-marked Quran links and neutral quotation spans.

Ranges are half-open UTF-16 offsets in `sourceText`: the start is included, the end is excluded. Compute them on source text, not normalized search text.

`quranReference` keeps the original label. Recognized labels supply the surah name and verse list; a numeric surah ID remains unknown without a verified mapping. Tafsir URL numbers are never used as ayah IDs. `Citation`, `Verdict` and `ParsedLocator` retain raw wording. Parsing does not assign an automatic verdict classification or narrator graph.

Source strings keep wording, punctuation, diacritics and bidi marks. Legacy plain display removes only a verified leading result number and preserves paragraph boundaries. `removeHtml: false` returns retained source markup. Use `renderDocumentHtml` to embed escaped HTML made from allowed elements. Glossary tooltips use escaped plain definitions; original definition HTML is available separately.

## Speaker attribution

The source's structural markup can support formatting. A narrator name, grading scholar, quotation mark, CSS color or `قال` alone cannot reliably identify a speaker's exact words.

Default parsing leaves speakers unconfirmed and styles quotations neutrally. Import reviewed annotations separately:

```dart
// Load an annotation produced by a trusted review process for this source.
final reviewed = AttributionAnnotation.fromJson(reviewedJson);
document.validateAttributions([reviewed]);
final tokens = documentRenderTokens(document, reviewedAttributions: [reviewed]);
```

Validation checks the document hash, source URI, evidence, reviewer and text range. It rejects stale hashes, ranges outside the text or across a surrogate pair, missing review evidence and conflicting confirmed assignments. Heuristic candidates cannot produce confirmed speaker styling. The review process remains responsible for whether the attribution itself is correct.

## Thematic categories

```dart
final roots = await client.categories.getRoots();
final children = await client.categories.getChildren(roots.data.first.selector);
final matches = await client.categories.search('الصلاة');
final page = await client.categories.browse(CategoryBrowseParams(
  categoryId: CategoryId(matches.data.first.id),
  page: 11,
));
```

Root selectors keep their exact source value, including significant trailing spaces. Leaf IDs are opaque strings. These methods expose observed categories; they do not claim a complete reconstructed hierarchy.

## Offline references and upgrades

`assets/data/reference_manifest.json` records the snapshot version, database schema, normalization version, counts, hashes, source captures, collection methods and coverage.

Current book and scholar choices work offline. Historical scholar IDs remain available for lookup but are excluded from default browsing. Changed names keep their earlier labels as search aliases.

Narrator choices combine a historical snapshot with sampled current autocomplete results. Coverage is partial. `RawiItem.name` keeps the original label; schema-2 `normalized_value` is a separate search key. Search and count apply the same Arabic normalization, escape literal `%` and `_`, and sort by ID. Search normalization does not change display text.

Native Dart reads immutable assets relative to the installed package, regardless of the working directory. Its writable cache defaults to `cache.db` in the working directory; configure a custom cache connection when needed. Native Flutter uses application support storage and verified, versioned copies, preserving old reference and cache files. Browser reference databases have snapshot-specific identities.

Custom narrator databases require schema 2. Create a new file to migrate:

```dart
await migrateReferenceDatabase(inputPath: 'custom-v1.db', outputPath: 'custom-v2.db');
// Configure your connection to the verified copy. The input remains untouched.
```

## Browser setup

Serve compatible `sqlite3.wasm` and `drift_worker.dart.js` at your app's base URL. The [Flutter example](https://github.com/MoathCodes/dorar_hadith/blob/main/dorar_hadith_flutter/example/README.md) explains the setup.

Browser tests from a localhost origin confirmed that Dorar blocks direct site and quick-API responses through CORS. Offline initialization does not contact Dorar. For online requests, supply an `http.Client` that routes requests through your own backend:

```dart
final client = DorarClient(
  httpClient: DorarHttpClient(client: yourHttpClient),
);
```

`yourHttpClient` is your application's transport. The package does not supply a public proxy. Transport failures stay visible as exceptions.

## Cache and errors

Services store validated raw responses in cache format 3, then parse and render each request locally. Plain text, HTML and document requests can reuse a response without mixing result models. Cache keys include endpoint, host, canonical URI and options that change the response. The stored response keeps its hash, status, content type, encoding, fetch time and final URI when the transport supplies it.

A corrupt entry is removed and fetched again. Unknown challenge pages are rejected instead of cached as empty results. Older cache namespaces are ignored without resetting SQLite.

Defaults are 100 memory entries, 750 SQLite rows and a seven-day lifetime. Explanation and scholar detail responses use 30 days.

`DorarSubrequestException` identifies a failed associated explanation and keeps the original `DorarException` in `cause`. Direct network, timeout, rate-limit, validation, not-found and parser errors keep their types. Call `dispose()` when finished, or use `DorarClient.use` to close clients and databases automatically.

## Development and release

Use FVM for repository Dart and Flutter commands. Normal tests use saved fixtures and run offline. Source capture and reference refresh are explicit development tasks. Fixtures and tools are excluded from pub archives.

Read the [migration guide](doc/MIGRATION_0_6_0.md) when upgrading from 0.5.x, and the [release guide](doc/RELEASE_0_6_0.md) when preparing a package upload. The [implementation record](https://github.com/MoathCodes/dorar_hadith/blob/main/docs/DORAR_0_6_0_IMPLEMENTATION_STATUS.md) links the audit, tests and platform results. Tawaq application adoption remains a separate task.
