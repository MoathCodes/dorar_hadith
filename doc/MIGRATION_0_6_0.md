# Moving from 0.5.x to 0.6.0

This guide applies to stable 0.6.0. It covers the two SDK packages; Tawaq application changes remain a separate task.

## Contents

- [Public and behavioral changes](#section-1)
- [Saved JSON and religious text](#section-2)
- [Cache upgrade](#section-3)
- [Native Flutter](#section-4)
- [Browser](#section-5)
- [Stable dependency configuration](#section-6)

<a id="section-1"></a>

## Public and behavioral changes

- `Sharh.hadith` is now `DetailedHadith`, including the explanation page's own header ID, categories, citation and verdict. Historical six-field embedded JSON still decodes. `ExplainedHadith.toDetailedHadith()` converts existing objects without fetching or manufacturing source data.
- `Sharh.document` exposes structural body content. Its `embeddedHadith`, when present, belongs to the independent body citation, not the header. `requestedHadithId` and `explanationReference` exist only when an originating record supplied them.
- `types` replaces new uses of legacy `zone`. Site scopes use repeated `t[]`. `SearchZone.sharh` raises a validation error; use `searchSharhText` for prose snippets. Associated full explanation search remains `sharh.search`.
- Quick API marfoo and narrator-choice filters are unverified and rejected. Detailed search supports them. Unsupported specialist/sort/phrases/multiple scopes/explanation scope are also rejected before a quick request. The SDK never silently switches endpoints.
- Dynamic typed filters (`scholarIds`, `bookIds`, `narratorChoiceIds`) accept discovered choices without requiring a predefined constant. Do not combine one with its corresponding legacy filter list.
- `getAlternates` returns every ordered alternative; `getAlternate` retains its first-item projection. `getSimilar` keeps its historical seed-included behavior; `getSimilarResult` separates seed and related items. Best-effort related results may have a null source when seed identity is unresolved, retaining all ambiguous records with warnings.
- Strict parsing is the default. Unknown/malformed layouts raise parser errors rather than becoming empty results. `ParsePolicy.bestEffort` is explicit and reports partial results. Associated fetch failures use the new `DorarSubrequestException`, retaining the original failure in `cause`; exhaustive exception switches must handle it.
- Meaningful paragraph boundaries and internal dashes survive plain rendering. Number-prefix cleanup runs only on display text. Raw/source HTML is not sanitized; use `renderDocumentHtml` for embedding.
- `BookInfo.editionYear` is the complete source date string, including calendar/bidi marks. Inspect `editionDate.components` for derived years/calendars. Never assume the raw field is a single Gregorian integer.
- `metadata.pagination` separates displayed totals from reachable limits. Ordinary site search page 11 is rejected; thematic browsing page 11 is valid. Full quick/prose pages provide hints, not authoritative totals.
- Current-reference browsing excludes historical scholars while ID lookup still finds them. Historical names remain searchable. Narrator choices remain partially covered and must not be interpreted as canonical person IDs.

<a id="section-2"></a>

## Saved JSON and religious text

Old hadith/explanation JSON remains readable with new fields absent. Do not rewrite saved strings to match new display formatting or live content. Missing rich structure marks legacy content; a current-detail fetch is a separate consumer decision. New typed IDs serialize to strings, and existing primitive ID keys remain unchanged.

A paragraph, quotation, narrator name, scholar name, or tafsir URL does not establish a speaker. Default documents have no confirmed speaker assignments. Review imported attributions against `sourceUri`, `contentHash`, evidence, reviewer and UTF-16 ranges. Do not compute offsets on normalized Arabic.

<a id="section-3"></a>

## Cache upgrade

Cache format 3 contains validated raw responses. SQLite tables remain intact; old namespaces are ignored and handled by normal expiry/eviction. Cache output is parsed anew for the requested rendering and policy. No application favorites/history store is migrated or erased.

<a id="section-4"></a>

## Native Flutter

Keep the same initialization call. Concurrent identical calls share one future; failures leave initialization retryable. Conflicting directory configurations raise `DorarFlutterAdapterException`. Global factories become visible only after assets and the managed reference installation validate.

The initializer uses `rawi-<snapshot>-v2-<hash>.db`, verifying hash, SQLite integrity, schema and count before installing/opening read-only. Existing `rawi.db`, old managed snapshots, `cache.db`, and unrelated files remain untouched. Do not delete the old file as an upgrade step.

For custom factories/files, the default contract requires schema 2. Run `migrateReferenceDatabase(inputPath: ..., outputPath: ...)` to create a verified managed copy, then point your factory at it. Existing output is refused, and the input is opened read-only. Custom filenames remain caller-owned and are not refreshed automatically.

<a id="section-5"></a>

## Browser

Serve compatible `sqlite3.wasm` and `drift_worker.dart.js` at the application base. Reference WebAssembly storage identity includes snapshot version, schema and content hash; cache storage remains separate. Native installation helpers are unavailable on web. Direct Dorar requests were blocked by CORS from the tested localhost browser origin; inject an application-owned proxy `http.Client` through `DorarHttpClient` for online browser access; asset/reference initialization works without contacting Dorar.

<a id="section-6"></a>

## Stable dependency configuration

Use `dorar_hadith: ^0.6.0` and `dorar_hadith_flutter: ^0.6.0`. Local path overrides belong in ignored `pubspec_overrides.yaml`, never distributable manifests.
