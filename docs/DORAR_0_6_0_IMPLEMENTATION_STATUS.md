# Dorar 0.6.0 implementation status and verification record

Date: 2026-10-06. Prepared package versions: **dorar_hadith 0.6.0** and **dorar_hadith_flutter 0.6.0**.

This record describes implemented SDK behavior and verification evidence. The owner selected direct stable 0.6.0 publication after the local checks, replacing the earlier RC sequence. Both stable versions are published and verified below.

Tawaq source, UI, favorites, recent history and app-store migrations remain outside this task. The application adoption map is still [the separate follow-up document](TAWAQ_DORAR_0_6_0_FOLLOW_UP_MAP.md).

## Contents

- [Evidence and baseline](#section-1)
- [Phase status](#section-2)
- [Public API inventory and ownership](#section-3)
- [Finding-by-finding traceability](#section-4)
- [Source formatting and attribution limits](#section-5)
- [Reference snapshot and store contracts](#section-6)
- [Local verification results](#section-7)
- [Actual browser evidence](#section-8)
- [Archive preparation and publication gates](#section-9)
- [Stable release verification](#section-10)

<a id="section-1"></a>

## Evidence and baseline

- The original [upstream audit](DORAR_UPSTREAM_AUDIT_2026-10-06.md) and [implementation specification](DORAR_0_6_0_IMPLEMENTATION_SPEC.md) remain the source of finding identifiers and acceptance contracts.
- There are **166 direct Dorar captures**, indexed in `test/fixtures/upstream_manifest.json`, with original URLs, timestamps, response status/content type, decoded-body SHA-256 and capture-file SHA-256.
- Captures cover six ordinary topics, all 24 explanation pages, 16 alternate pages, eight usul pages, six asbab pages, two-topic type/sort and phrase matrices, quick-API filters, empty variants, prose pagination, categories and reference discovery.
- `fixture_integrity_test.dart` verifies the entire index against capture bytes and the explicit request targets. Offline tests do not request Dorar.
- `capture_upstream_contracts.dart` skips existing captures by default, supports explicit selected/forced requests, archives previous capture bytes by hash before replacement, and rebuilds the fixture manifest. It does not scrape during startup.
- `upstream_expectations.json` records audited semantic expectations separately from payload hashes. Synthetic malformed/error cases are identified in tests rather than passed off as source observations.
- The published 0.5.0 archives were downloaded through pub.dev metadata and verified against their registry SHA-256. The pre-implementation checkout is `e08eb666697c2d2fb986d825f14d46042ec259ea`.
- [Published baseline diff](DORAR_0_6_0_PUBLISHED_BASELINE_DIFF.json) separates pre-existing unreleased library changes from this implementation. Core already differed from publication in 37 library files; the adapter differed in two. Generated-file changes are included in those counts.
- Both old archives contained build output: seven core build files and 12 adapter build files. The new archive boundaries exclude builds, caches, development overrides, fixtures, tools and the nested adapter from core.

<a id="section-2"></a>

## Phase status

| Phase                            | State                                  | Delivered evidence or remaining gate                                                                                                                                                                   |
| -------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| P0 Source contracts and baseline | Implemented for confirmed capabilities | Frozen/indexed captures, endpoint matrices, published baseline diff, API inventory below; unverified scopes are rejected or explicitly unknown                                                         |
| P1 Models and compatibility      | Implemented                            | Typed IDs, source documents, references, diagnostics/provenance, old saved JSON decoding, primitive identifier JSON                                                                                    |
| P2 Source parsers and formatting | Implemented                            | Scoped metadata, separate embedded citations, exact glossary occurrences, explicit citation labels, raw dates, range/hash validation, safe HTML/tokens                                                 |
| P3 Raw-response cache            | Implemented                            | Shared client transport, v3 envelope, format/model collision regressions, persistent recovery, no table reset                                                                                          |
| P4 Endpoints and discovery       | Implemented                            | Search serializers, prose/AJAX search, ordered relations, asbab/usul, categories and online choices                                                                                                    |
| P5 References and normalization  | Implemented                            | Dated source manifest, candidate-only reproducible refresh, history, schema-2 database, symmetric count/search                                                                                         |
| P6 Platform upgrades             | Implemented; local runtime verified    | Native read-only/atomic/versioned assets, adapter lifecycle/custom ownership, actual browser WASM/cache/A-B replacement; native Windows/macOS CI passed; Android/iOS device runtime remains unverified |
| P7 Examples and documentation    | Implemented; local gates passed        | Independent Dart/Flutter consumers, migration guide, package examples, Linux and web builds; remote Windows/macOS checks passed; Android/iOS device runtime remains additional coverage                |
| P8 Candidate publication         | Superseded by owner decision           | Direct stable 0.6.0 selected; no RC was published                                                                                                                                                      |
| P9 Stable publication            | Published and verified                 | Both 0.6.0 registry archives and hosted consumers verified; remote package/minimum/browser CI passed                                                                                                   |

<a id="section-3"></a>

## Public API inventory and ownership

| Surface                                                          | Implemented contract                                                                                                      |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `DorarClient.searchHadith` / `hadith.searchViaApi`               | Lightweight quick-API records; no manufactured site record IDs or total                                                   |
| `searchHadithDetailed` / `hadith.searchViaSite`                  | Detailed site records, selected source tab, source-backed links, diagnostics/provenance and reachable pagination          |
| `HadithSearchParams.types`                                       | Search scopes 0/1/2/4, repeated site arrays; legacy `zone` adapter cannot be combined with new scopes                     |
| `HadithSearchParams.sort`                                        | Explicit degree ordering for verified site search                                                                         |
| `optionalPhrases`                                                | Zero to four positional fields, including gaps and optional-only queries; no invented OR semantics                        |
| `scholarIds` / `bookIds` / `narratorChoiceIds`                   | Nominal dynamic filter IDs, sorted/deduplicated request sets; mutually exclusive with corresponding legacy object filters |
| `SearchCapabilities`                                             | Endpoint-specific supported inputs, page sizes and ordinary page cap                                                      |
| `getAlternates`                                                  | Seed and every alternative in source order; legacy first-item method remains                                              |
| `getSimilarResult`                                               | Separate source and related list; legacy `getSimilar` keeps seed-included projection                                      |
| `getAsbab`                                                       | Requested record and independently cited context documents; observed direct/similar/unknown relationship                  |
| `getUsul`                                                        | Source/chain/narration text and documents; actual source count; no fabricated advertised capability                       |
| `sharh.getById`                                                  | Explanation page header as `DetailedHadith`, complete grade, body document and independent embedded citation              |
| `sharh.search`                                                   | Full associated explanations with each originating record/link relationship retained, even when explanation IDs repeat    |
| `searchSharhText` / `sharh.searchText`                           | Prose snippets with IDs/URIs/documents; later pages request the observed AJAX layout                                      |
| `categories.getRoots/search/getChildren/browse`                  | Raw selectors, opaque IDs, HTML autocomplete, JSON hierarchy, category pagination                                         |
| `referenceDiscovery.getBooksForScholars`                         | Current assessed-source choices for the selected scholars, including multi-selection context                              |
| `referenceDiscovery.searchNarratorChoices`                       | Explicit online observed filter choices; partial coverage, never implicit offline network discovery                       |
| `book.getById`                                                   | Bibliography with complete raw edition date and optional parsed components                                                |
| `DetailedHadith`                                                 | Compatible scalars plus IDs/categories/raw metadata/content/provenance/capability references                              |
| `Sharh`                                                          | Header record, body document, optional independent embedded record, origin/reference and provenance                       |
| `ExplainedHadith.toDetailedHadith`                               | Explicit conversion of legacy objects without a fetch or invented fields                                                  |
| `SourcedDocument`                                                | Canonical decoded text, retained scoped HTML, schema/hash, structural blocks and occurrence annotations                   |
| `TextRange`                                                      | Half-open UTF-16 offsets with bounds and surrogate-boundary checks                                                        |
| `Citation` / `Verdict` / `ParsedLocator`                         | Raw source wording retained; optional derivations/evidence, no blanket grade classifier                                   |
| `QuranCitationReference`                                         | Explicit named-surah label and verse list; unknown numeric surah identity stays null; URI path is never an ayah source    |
| `AttributionAnnotation`                                          | Source identity/hash, reviewer/evidence/range checks; heuristic candidates cannot drive confirmed speaker styling         |
| `DocumentParser` / `renderDocumentHtml` / `documentRenderTokens` | Deterministic source structure, escaped allowed HTML, exact source substrings and neutral quotations                      |
| `ParsePolicy` / `ParseDiagnostics`                               | Strict failures by default; bounded best-effort warnings and candidate/parsed counts                                      |
| `ResultProvenance` / `PageMetadata`                              | Requested/final URI, encoding/status/fetched hash and cache state; displayed totals versus reachable limits/hints         |
| `ReferenceManifest` / `migrateReferenceDatabase`                 | Integrity/schema/snapshot identity; explicit exclusive-output copy migration without changing the original                |
| `DorarHadithFlutter.ensureInitialized`                           | Shared concurrent future, retry after failure, normalized directory configuration, validated factories after installation |
| Adapter advanced factories                                       | Caller-owned custom paths are never overwritten; managed snapshots and mutable caches have separate ownership             |

Existing public primitive-ID methods remain adapters. Typed choice IDs describe source domains, not a universal person identity. The target SDK is pure Dart; the adapter owns Flutter asset loading and writable native paths.

<a id="section-4"></a>

## Finding-by-finding traceability

Test paths are relative to the core package unless prefixed with the adapter directory. Tests exercise actual service/parser behavior against captures as well as identified synthetic failure cases.

| Finding                      | Implementation/disposition                                                    | Verification                                                                                                             |
| ---------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| F01 Ignored site type        | Repeated `t[]`; independent quick scalar policy                               | `test/integration/search_matrix_contract_test.dart`, query serializer tests, captured prayer/fasting type pages          |
| F02 Prose layout             | Separate snippet API; full first page and AJAX later pages                    | Upstream/source regression suites; nine prose captures including recognized empty variants                               |
| F03 Multiple/type 4          | Typed nonexclusive search scopes; quick combinations unsupported              | Search matrix and serializer tests; all eight two-topic ordinary type captures                                           |
| F04 Lost alternatives        | All related records retained with seed identity                               | Upstream suite checks all 31 alternatives across 16 audited pages; two actual empty variants; unresolved-seed regression |
| F05 Missing asbab            | Independent contextual citations and relationship heading                     | Source regression suite checks six pages and distinct requested/context records                                          |
| F06 Categories               | Roots, autocomplete, raw trailing selector spaces, children and browse        | Discovery/upstream suites, including actual category page 11; empty JSON child list recognized                           |
| F07 Sort/phrases             | Degree sort and positional fields; optional-only valid                        | Two-topic 24-case phrase matrix, two sort captures and URI validation tests                                              |
| F08 Scholar choices          | Online source choices with selected-scholar context                           | Discovery suite: 51 and 84 individual choices, combined 135-choice union                                                 |
| F09 Empty quick response     | Recognized empty success; challenges are structure errors                     | Actual two-token empties in upstream suite; unknown-response admission regression                                        |
| F10 Forced usul flag         | Advertisement comes from links; count comes from parsed sources               | Eight usul pages, source-empty fixture and synthetic no-advertisement cases                                              |
| F11 Lost sharh verdict       | Scoped page header; separate embedded grade                                   | Exact 16-header expectations plus all 24 explanation documents; 137940/2981 regressions                                  |
| F12 Explanation relation     | Observed direct/similar/unknown label retained                                | Six-topic corpus: 85 similar/two direct references; originating links survive associated search                          |
| F13 Sharh metadata           | Detailed page header with source-linked IDs/categories                        | Upstream/source suites, JSON round trips and legacy saved-content cases                                                  |
| F14 Flattened body           | Independent narration/citation/commentary blocks                              | All 24 explanation pages, with and without embedded narration, render-token substring checks                             |
| F15 Glossary loss            | Per-occurrence term/definition/HTML/range                                     | All 71 source nodes across six topics; see malformed-markup limitation below                                             |
| F16 Qur'an citation loss     | Label/absolute URI and explicit label verse lists                             | 114935/226191/2065 plus label tests; URL 107/1 is not confused with verses 4/5                                           |
| F17 Date truncation          | Whole raw field and calendar components retained                              | Book service fixtures and Arabic-digit/bidi/date validation regressions                                                  |
| F18 Missing derived types    | Typed raw citation/verdict/locator/chain models                               | Usul/context/explanation round trips; unsupported judgments/identities remain unclassified                               |
| F19 Model-cache collision    | Cache source responses, parse for each consumer                               | Hadith/associated explanation service tests; shared cache stores without model decoders                                  |
| F20 Format-cache collision   | HTML/plain/document generated after raw lookup                                | Real source regression/upstream tests across record/search/explanation formatting requests                               |
| F21 Destructive cleanup      | Verified display prefix only; source/HTML unchanged                           | Prefix tests, internal punctuation/attributes/URLs and all source annotation ranges                                      |
| F22 Paragraph loss           | Source paragraph/line/separator/list/heading structure                        | Document and render tests; all explanation documents; no global whitespace flattening                                    |
| F23 Silent partial failures  | Typed strict errors, explicit partial diagnostics, preserved subrequest cause | Malformed second record; corrupt cache recovery; missing associated explanation; seed mismatch/unknown identity          |
| F24 Pagination ambiguity     | Displayed total separate from cap/reachable count/hint                        | Ordinary page 11 rejected, category 11 accepted, prose AJAX/empty and quick page-size hints                              |
| F25 Stale references         | Source dated lists, historical entries and rename aliases                     | Reference diff/manifest, reproducible candidate bytes, current versus historical lookup tests                            |
| F26 Narrator coverage        | Merge explicit observed choices, retain raw compound labels                   | Four online-choice captures; 43 added choices; coverage explicitly partial                                               |
| F27 Asymmetric Arabic search | Shared normalized predicate/count, escaped literal wildcards, stable ordering | Reference suite covers Abu Hurayrah/Aishah/ibn Umar, marks/tatweel/alef/ta variants, count/page equivalence              |

<a id="section-5"></a>

## Source formatting and attribution limits

Structural formatting is implemented and source-backed. Default parsing produces **zero confirmed speaker assignments** across the 24 explanation pages. This is deliberate abstention where the source does not identify a complete speaker span; it is not a claim of automatic attribution accuracy or coverage.

- Quote punctuation produces neutral quotation spans.
- A hadith narrator, grading scholar, `قال`, CSS color or tafsir path cannot establish Prophet/companion/scholar/divine speech boundaries.
- Reviewed imported attributions require matching URI/hash, evidence, reviewer where applicable, valid UTF-16 spans and no conflicting confirmed overlap.
- JSON document imports and renderers reject incompatible schemas, stale text hashes, invalid/overlapping blocks and invalid annotation ranges.
- Qur'an links retain the named surah and explicit verse list only when the visible citation label matches the recognized layout. No numeric surah identity is inferred from a tafsir URL or an unchecked name mapping. Unrecognized labels retain raw label/URI and unparsed status.
- Qualified and mixed verdicts remain raw unless a separately verified enrichment supplies classification/scope/evidence. Locator and chain identity enrichment also abstains by default.
- Eight of the 71 glossary nodes occur as empty HTML5-recovered anchors in one malformed source record. Those source nodes retain definitions and zero-length ranges. The parser does not invent visible terms or move their definitions to another occurrence. The other 63 occurrences have exact visible term ranges.

<a id="section-6"></a>

## Reference snapshot and store contracts

Snapshot `2026-10-06.1` has database schema 2 and normalization version 1.

| Collection       | Count and coverage                                                                                            |
| ---------------- | ------------------------------------------------------------------------------------------------------------- |
| Books            | 774 current source choices; 89 added IDs, seven changed labels                                                |
| Scholars         | 208 current choices plus three historical lookup entries; 14 added IDs, three changed labels                  |
| Narrator choices | 11,479 observed rows: 11,436 historical baseline plus 43 newly observed choices; incomplete upstream coverage |

Historical scholar IDs 227/233/291 remain retrievable and are excluded from current selection browsing. Rename aliases support lookup without replacing current source wording. Narrator compound/alias labels and bidi marks remain in the raw display value. Normalized search keys are separate database columns.

`refresh_references.dart` builds new candidates, refuses an existing output, verifies capture hashes/status and emits source-ID/name differences. Repeated generation produced byte-identical committed books, scholars, database and manifest. It does not treat Node assets as current authority.

Native core package references resolve from the installed package independently of process CWD and open read-only. Flutter managed copies include snapshot/schema/hash in their filename, validate bytes/SQLite integrity/schema/count and install from verified temporary files. Mutable cache storage keeps its own identity. Custom schema-1 databases require an explicit copy migration; existing outputs and concurrently claimed outputs are refused. The original input remains unchanged.

A custom Flutter path created by another owner while an async asset loader is running is refused through exclusive file creation; it is not truncated. Regression tests cover both migration output races and this ownership race.

<a id="section-7"></a>

## Local verification results

Toolchain: FVM Flutter **3.47.5**, Dart **3.13.4**. Core lower-bound verification used a separate downloaded Dart **3.13.0** SDK with `pub downgrade`, in an isolated checkout.

| Check                                                           | Result                                                                                                                                                              |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Core `dart analyze` with strict casts/inference/raw types       | No issues                                                                                                                                                           |
| Core complete offline suite                                     | 363 tests passed                                                                                                                                                    |
| Minimum Dart 3.13.0 `pub downgrade`, analyze and complete suite | No issues; all 363 tests passed                                                                                                                                     |
| Adapter `flutter analyze`                                       | No issues                                                                                                                                                           |
| Adapter `flutter test`                                          | Seven tests passed, including custom-ownership race                                                                                                                 |
| Independent Flutter example analyze/test                        | No issues; one error-path widget test passed                                                                                                                        |
| Independent example Linux build                                 | Passed                                                                                                                                                              |
| Independent example JavaScript web build                        | Passed; no claim of Flutter Wasm-target support                                                                                                                     |
| Worker and browser smoke JavaScript compilation                 | Passed                                                                                                                                                              |
| Generated source stability                                      | Repeat generation left all generated-file hashes unchanged                                                                                                          |
| Current dependency locks                                        | `pub get --enforce-lockfile` passed separately for core/adapter                                                                                                     |
| Reference candidate reproduction                                | Books/scholars/database/manifest matched committed SHA-256 byte for byte                                                                                            |
| Fresh unrelated-CWD Dart consumer                               | 774 books, 208 scholars, 11,479 narrator choices, nonempty normalized query                                                                                         |
| Fresh independent Flutter consumer against staged pair          | Transitive rootBundle assets, manifest, managed database, normalized lookup, separate writable cache and preserved unrelated file passed                            |
| Browser reference runtime                                       | Actual SQLite/WASM worker loaded, 11,479 choices and Arabic results returned                                                                                        |
| Browser snapshot/cache runtime                                  | A/B have distinct persisted IDs; B returned its changed test row, A returned original row after restore; cache sentinel survived and both reference stores remained |
| Browser direct online access                                    | Site default preflight redirect failed; canonical site and quick endpoint also failed cross-origin; no-cors returned unreadable opaque status 0                     |
| Core isolated archive dry run                                   | No warnings; about 350 KB compressed, required assets included, no adapter/build/fixture/override payload                                                           |
| Adapter isolated archive dry run                                | Earlier RC check: about 53 KB compressed; final stable checks are recorded below                                                                                    |

The lower-bound run found an old transitive `frontend_server_client` selected by downgrade which assumed a removed SDK snapshot. The core dev dependency now requires `^4.0.0`, whose [upstream changelog](https://pub.dev/packages/frontend_server_client/changelog) documents the AOT SDK layout support. This changes test tooling, not runtime dependencies.

Temporary-file quota errors during simultaneous compiler runs were resolved by placing verification temporary files on the workspace filesystem. They were rerun; they are not reported as passing runs. An early attempt using the stale parent `.fvm/flutter_sdk` symlink selected Flutter 3.47.1; independent checks were repeated with the actual FVM-selected 3.47.5 SDK.

<a id="section-8"></a>

## Actual browser evidence

[Browser verification JSON](DORAR_0_6_0_BROWSER_VERIFICATION.json) records source A, a disposable changed B snapshot, and restored A. The B fixture changed one narrator label in the **served build copy only**, with a corresponding test version/hash. Committed source assets were never changed for that probe. Served build assets were restored afterwards.

The compiled `tool/browser_smoke.dart` queried the real browser databases, wrote its own test cache key, and reported the prior persisted value after a reference switch. It did not call Dorar or clear storage. The ordinary Flutter example also displayed the B row while B was served and returned to the source A reference after restoration.

Observed browser CORS failure remains a platform limitation. Online browser use requires an application-owned server-side `http.Client` transport supplied to `DorarHttpClient`. No public third-party proxy is bundled or assumed. Offline browser setup does not contact Dorar.

<a id="section-9"></a>

## Archive preparation and publication gates

`tool/prepare_release.dart` stages two independent directories and refuses an existing output or symbolic links. Core retains its required assets and documentation. The adapter retains its own source/license/example. Required core asset hashes are validated independently from the staged package. Neither archive contains raw captures, fixtures, build output, ignored local wiring or a nested second SDK. The [staged source manifest](DORAR_0_6_0_STAGED_SOURCE_MANIFEST.json) records the deliverable files with per-file sizes and SHA-256; it is a source-directory inventory, not a claim of a registry archive hash.

The nested adapter must be published from its **isolated staging directory**: core ignore rules deliberately exclude the nested adapter and therefore hide it during an in-place nested publication. Staging makes both package file lists independently reviewable.

Stable manifests use `^0.6.0` for the adapter's hosted core dependency. Prepublication local overrides are temporary and excluded from archives. Hosted validation runs without overrides after the core upload.

<a id="section-10"></a>

## Stable release verification

The owner selected stable 0.6.0 for both packages, authorized a push to main and publication, and left Tawaq adoption for a separate request. Final documentation includes matching English/Arabic core and adapter guides, tables of contents, and corrected offline-test instructions. The earlier RC publication sequence is superseded.

Final stable checks: core analyzer passed with 363 offline tests; adapter analyzer passed with seven tests. Both isolated archive dry runs have zero warnings. The prepublication adapter has one temporary path-override hint; its hosted check must remove that override. English/Arabic guides match in section order, code blocks and API identifiers. Markdown formatting and local links passed. Both packages were published in dependency order and downloaded again to verify their registry SHA-256 and archive boundaries. Independent Dart and Flutter consumers resolve hosted packages without overrides. They passed reference lookup, transitive asset loading, verified native storage and cache checks. The hosted Flutter example passed analysis and its widget test.

| Package                                                                              | Published version | Archive SHA-256                                                    |
| ------------------------------------------------------------------------------------ | ----------------- | ------------------------------------------------------------------ |
| [dorar_hadith](https://pub.dev/packages/dorar_hadith/versions/0.6.0)                 | 0.6.0             | `8f85f00efcfeb463c374e21e02115fb0af7153587f1dea9737e33e35aea92ae3` |
| [dorar_hadith_flutter](https://pub.dev/packages/dorar_hadith_flutter/versions/0.6.0) | 0.6.0             | `3da0599301dd1c55aaaf1e14460282b58f6d09ed732de7ed98248408fe057760` |

Release source commit `064c7b5` and CI correction commit `100ffed` were pushed to main on GitHub and the origin mirror. [Remote verification](https://github.com/MoathCodes/dorar_hadith/actions/runs/37504763528) passed on Linux, macOS and Windows, with separate minimum-Dart and browser-build jobs. Generated sources were clean. The initial CI failures came from Windows JSON line-ending conversion, a path-splitting test helper and recursive example lock enforcement. `.gitattributes`, platform-aware snapshot paths and separate adapter/example checks fixed those failures without changing published runtime code.

Pub.dev strips custom HTML anchors from README rendering. Some published 0.6.0 table-of-contents links therefore miss their targets. Main uses generated heading IDs instead, verified against actual pub.dev headings; English and Arabic examples and API content still match. The chosen published versions remain 0.6.0. A later patch is needed to update the registry README links.

Android/iOS device runtime remains untested. Browser CORS and partial narrator coverage remain documented limitations. [Machine-readable publication evidence](DORAR_0_6_0_PUBLICATION.json) contains archive URLs, sizes, hashes and check results.

The [release runbook](../doc/RELEASE_0_6_0.md) and [migration guide](../doc/MIGRATION_0_6_0.md) describe package publication and adoption. Tawaq adoption remains separate.
