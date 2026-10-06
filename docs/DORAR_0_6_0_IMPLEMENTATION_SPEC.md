# Dorar Hadith 0.6.0 implementation and release specification

Date: **2026-10-06**, Asia/Riyadh. Status: **proposed implementation contract; no implementation or publication performed**.

Packages: `dorar_hadith` and `dorar_hadith_flutter`.

Evidence baseline: [Dorar upstream audit](DORAR_UPSTREAM_AUDIT_2026-10-06.md). Finding identifiers F01–F27 refer to that report. The report remains the evidence record; this document defines the behavior, implementation order, acceptance criteria, migration, and publication process.

## Contents

- [1. Intended outcome](#section-1)
- [2. Scope and package boundaries](#section-2)
- [3. Non-negotiable content and state contracts](#section-3)
- [4. Public API and model decisions](#section-4)
- [5. Endpoint implementation contracts](#section-5)
- [6. Empty, partial, error, and pagination behavior](#section-6)
- [7. Structured text and safe formatting](#section-7)
- [8. Raw-response cache implementation](#section-8)
- [9. Reference refresh and Arabic search](#section-9)
- [10. Flutter initialization and snapshot installation](#section-10)
- [11. Compatibility and migration guide](#section-11)
- [12. Implementation work packages and ordering](#section-12)
- [13. Test specification and finding traceability](#section-13)
- [14. Verification commands and CI](#section-14)
- [15. Documentation and distributable artifacts](#section-15)
- [16. Release candidate and stable publication runbook](#section-16)
- [17. Definition of done](#section-17)
- [18. Recorded implementation decisions (2026-10-06)](#section-18)

<a id="section-1"></a>

## 1. Intended outcome

Release both packages at **0.6.0** with correct endpoint-specific search, complete related-record retrieval, preserved explanation metadata, structured source-preserving content, refreshed reference data, safe cache behavior, and working upgrades for existing native Flutter installations.

All 27 findings must have a verified disposition before the stable release. A finding is addressed by implementing its supported capability or explicitly modeling an upstream limitation with honest output and tests. “Unknown” is a valid data value when the source lacks evidence; silently dropping data, inventing IDs, or returning a successful but misleading result is not.

The release must make formatting useful outside the hadith text itself: commentary paragraphs, separately cited narrations, glossary definitions, Qur'an citation links, and source chains must be accessible programmatically. Speaker attribution must remain independent of formatting. The audited source does not provide a reliable universal speaker annotation contract, so this release must support reviewed attribution while preserving unknown speakers by default.

This specification authorizes no upload by itself. It describes the later implementation and release task. No package code, manifests, assets, generated files, or application consumers are changed as part of writing this document.

### 1.1 Release baseline verified while writing this specification

| Item                               | Observed state                                                   | Required release action                                                  |
| ---------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Published core                     | `dorar_hadith` 0.5.0                                             | Publish 0.6.0 after the gates below                                      |
| Published Flutter adapter          | `dorar_hadith_flutter` 0.5.0                                     | Publish 0.6.0 after hosted core validation                               |
| Local core SDK constraint          | `>=3.13.0 <4.0.0`                                                | Verify the lower bound independently                                     |
| Local Flutter SDK constraints      | Dart `>=3.12.0`; Flutter `>=3.44.0`                              | Align with the core and tested Flutter baseline                          |
| Repository FVM toolchain           | Flutter 3.47.5 stable; Dart 3.13.4                               | Use this toolchain for repository checks                                 |
| Local Flutter publication settings | `publish_to: none`; core dependency `path: ..`                   | Replace with publishable hosted dependency settings                      |
| Reference database                 | Fixed `rawi.db`, schema 1                                        | Introduce a versioned reference snapshot and normalized search keys      |
| Native Flutter database copy       | Reuses an existing file indefinitely                             | Select the current versioned bundled snapshot on upgrade                 |
| Browser reference database         | Fixed persistent database name; initialization on first creation | Version the reference database identity on snapshot upgrades             |
| Cache                              | Format namespace 2; services store transformed model JSON        | Move service responses to raw-response caching                           |
| Release automation                 | No checked-in `.github` release workflow found                   | Provide reproducible local gates and CI; manual publishing is sufficient |

Both 0.5.0 publications were verified through the [core package page](https://pub.dev/packages/dorar_hadith/versions/0.5.0), [Flutter package page](https://pub.dev/packages/dorar_hadith_flutter/versions/0.5.0), and their public package metadata endpoints. Recheck version availability immediately before creating release candidates. If 0.6.0 has been used meanwhile, advance the common target to the next unused minor and update every example, constraint, tag, and checklist together.

<a id="section-2"></a>

## 2. Scope and package boundaries

### 2.1 Core package responsibilities

`dorar_hadith` owns transport, endpoint contracts, raw-response caching, parsers, public data models, structured documents, reference snapshots, Arabic search normalization, and Dart/native/browser database adapters.

The public client remains the normal entry point. New services must be available through `DorarClient`, not only through internal exports. Add `client.categories` and `client.referenceDiscovery` alongside the existing services. Existing directly constructed services must continue working with their documented injected HTTP client and cache, or receive an explicit migration path.

### 2.2 Flutter package responsibilities

`dorar_hadith_flutter` remains a **native Flutter adapter** for Android, iOS, Linux, macOS, and Windows. It owns bundle loading, application-support paths, reference snapshot installation, and persistent cache connection wiring.

It must not duplicate Dorar parsing or Arabic search rules. It must not require applications to declare the core package's transitive assets again. It continues to require a separate core import for core APIs; changing to re-export the entire core API is unnecessary for this release.

The adapter does not gain a required opinionated sharh widget. The core document representation and a small Flutter example must demonstrate safe rendering. Applications retain control of fonts, accessibility, themes, link actions, and religious-content presentation.

### 2.3 Tawaq integration is a separate follow-up

Per the user's scope clarification, this release implements and publishes the two packages independently of Tawaq. Do not modify Tawaq consumers, redesign its hadith feature, update its dependency/submodule pins, or make its application tests a package publication gate. Tawaq adoption will be requested after the package work is complete.

Keep package-level legacy JSON decoding, source integrity, migration documentation, and fresh hosted Dart/Flutter consumer validation in scope. These establish the SDK's contracts without requiring the existing application's heuristics to survive unchanged.

The preliminary app impact is recorded in [Tawaq follow-up map](TAWAQ_DORAR_0_6_0_FOLLOW_UP_MAP.md). It is an inventory for the later request, not an implementation requirement for this release.

### 2.4 Exclusions

This release does not promise a complete narrator corpus obtained by enumerating autocomplete, a unique-person narrator ontology, a translation/audio/private API inventory, an undocumented explanation-image service, or automatic trustworthy attribution of every quotation. The audit did not establish those upstream capabilities.

It does not introduce a mandatory LLM pipeline, silently replace source wording, classify arbitrary judgments using `contains('صحيح')`, or manufacture narrator/book/scholar IDs from matching names.

<a id="section-3"></a>

## 3. Non-negotiable content and state contracts

1. Preserve received religious text and source labels. Search normalization and display transformations are separate derived views.
2. Preserve one Dorar record assessment as its own record. Similar wording does not make assessments or citations interchangeable.
3. Keep the requested record, explanation-page header record, optional narration embedded inside commentary, and contextual narration separate.
4. Extract IDs only from actual IDs/links in the source. A missing ID is nullable and does not invalidate a text-only citation.
5. Distinguish advertised availability, fetched-empty content, failed retrieval, and unknown availability.
6. Treat missing local reference coverage differently from an invalid upstream identifier.
7. Preserve old saved JSON when adding metadata. Missing new fields decode to unknown/null/empty structural values, never invented facts.
8. Do not erase existing application data or reset databases to make an upgrade pass. Use additive migrations or separate versioned immutable reference stores.
9. Never run punctuation cleanup over serialized HTML or alter `hist-link`, `data-content`, URLs, or content inside religious prose.
10. A successful HTTP response is not sufficient evidence of a valid parsed result. Challenge pages, missing expected layout, partial records, and legitimate empty results have different outcomes.

<a id="section-4"></a>

## 4. Public API and model decisions

The names in this section are the target API. Adjustments discovered during implementation must be recorded here before release and must preserve the specified semantics. Avoid maintaining competing representations of the same authoritative fact.

### 4.1 Identifier boundaries

Introduce immutable, nominal value types for `HadithRecordId`, `SharhId`, `BookId`, `ScholarId`, `NarratorChoiceId`, and `CategoryId`. A `typedef` of `String` is insufficient when preventing accidental substitution is the goal.

- Store and serialize the upstream string value unchanged.
- Use domain-specific constructors and validators. Keep current hadith/sharh validation unless broader accepted IDs are demonstrated.
- Category IDs are opaque strings; no fixed ten-character or 32-character rule.
- Narrator choice IDs are filter-choice identifiers, including aliases and compound labels. They are not person identities.
- Top-level thematic selector values are a separate `CategorySelector` string, not a `CategoryId`.
- Provide explicit conversions from current reference objects and string IDs. Keep existing string/int entry points as documented adapters where signatures need not break.
- Never use an ID's apparent shape to move it between domains.

Existing model JSON keys such as `hadithId`, `bookId`, and reference `key` remain compatible. New typed IDs expose primitive values in JSON; do not replace stored strings with object-shaped IDs.

### 4.2 Search parameters

Add `HadithTypeFilter` with values `marfoo`, `qudsi`, `companionAthar`, and `withExplanation`, mapped to 0, 1, 2, and 4 respectively. These are **search scopes**; `withExplanation` must not be represented as a mutually exclusive narration ontology.

Extend `HadithSearchParams` with:

- `types: Set<HadithTypeFilter>`; empty means unrestricted.
- `sort: HadithSort?`; initial supported value `degree`, absent means upstream default.
- `optionalPhrases: List<String>`; zero to four source-form fields, preserving order and original text.

Retain `zone` as a deprecated legacy adapter for `all`, `marfoo`, `qudsi`, and `sahabaAthar`. Reject providing both `zone` and `types` rather than guessing precedence. `SearchZone.sharh` must return a clear unsupported-operation validation error explaining the new prose-search method; it must not return hadiths under an explanation-search label.

Use a separate `SharhTextSearchParams` for explanation-prose search. It contains primary text, page, and only filters confirmed for that layout. It has no ordinary specialist-tab toggle unless later evidence verifies one.

An empty primary hadith query is valid on the site when at least one nonblank optional phrase is present. Blank primary text with no usable phrase remains invalid. The quick JSON endpoint continues requiring its own verified query inputs.

### 4.3 Record and explanation metadata

Keep `Hadith` as the lightweight quick-API result. Do not add synthetic IDs to its results.

Extend `DetailedHadith` with source-preserving content, provenance where available, and structured references for explanation/asbab/related capabilities. Retain existing scalar fields and booleans as compatibility projections. The projections must not contain facts stronger than the structured source evidence.

Change `Sharh.hadith` to `DetailedHadith`, parsed from the **explanation page's header**. Deprecate `ExplainedHadith` for new service results; retain its old decoding and explicit conversion helper for existing callers. Its six shared required fields allow historical embedded JSON to be decoded into `DetailedHadith` with new fields absent.

Add:

| Type / field                 | Contract                                                                                                        |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `ExplanationReference`       | Explanation ID, URL, relationship `direct / similar / unknown`, original label, and advertised state            |
| `Sharh.document`             | Structural representation of the explanation body, including optional embedded narration and citation           |
| `Sharh.requestedHadithId`    | Present only if the caller fetched an explanation through a known originating record                            |
| `Sharh.explanationReference` | The actual observed originating relationship; direct `getById` has no assumed direct relationship               |
| `RelatedHadithResult`        | Requested ID, parsed source record, relationship kind, ordered related records, diagnostics/provenance          |
| `AsbabResult`                | Requested record, independently cited contextual narrations/documents, observed direct/similar/unknown relation |
| `UsulSource` additions       | Preserved source reference, raw chain content, raw narration content, optional document/citation fields         |

`SharhMetadata.id`, `isContainSharh`, and `sharh` remain available. `isContainSharh` continues to mean that text is included, not that the relationship is direct. `SharhMetadata.sharh` remains a legacy rendering of the full explanation body. New consumers use `document` to select commentary or separately cited material.

When a separately cited narration is present inside the explanation body, attach its own `DetailedHadith` when the markup supplies fields, or a partial `Citation` and preserved narration content when it does not. Never fill the page header's missing grade from that embedded narration.

### 4.4 Availability, provenance, and diagnostics

Use `Availability { advertised, notAdvertised, unknown }` for source capability advertisements. Absence of a link means `notAdvertised` only in a recognized complete capability section; an absent or unrecognized section means `unknown`.

Represent fetch outcome separately: success with items, success with zero items, not found, transport failure, or parse failure. Merely requesting `osoul=1`, `alts=1`, or `asbab=1` never changes advertisement state to true.

Extend `ApiResponse` metadata with:

- `ResultProvenance`: requested/final source URI where transport exposes it, endpoint kind, fetch timestamp, parser contract version, cache-hit status, and cache creation timestamp.
- `ParseDiagnostics`: `complete / partial / unknown`, candidate count, parsed count, skipped count, bounded warnings with stage/record ID/index, and failed subrequest summaries if applicable.
- `PageMetadata`, described in section 6.

Timestamps are client observations, not Dorar publication dates. Diagnostics must not log whole query text or whole religious documents by default. Preserve causes in typed exceptions without exposing secrets.

Default collection parsing is **strict**: fail with a typed parse exception if an identifiable candidate record cannot be parsed. Add an explicit per-operation `ParsePolicy.bestEffort` opt-in that returns partial data and diagnostics. The policy is local and is never sent to Dorar.

Legacy bare collection/singular methods use strict parsing. A failed fetch/parser must never turn into `[]` or `null`. Empty results and missing optional content must be demonstrated by a recognized upstream layout.

### 4.5 Citations, verdicts, chains, and dates

`Citation` contains original source name, original locator, optional known source ID/URL, and original takhrij text. Optional locator parsing returns a status and derived components; an ambiguous value remains intact and unclassified.

`Verdict` contains the raw judgment and optional derived classification, scope, and evidence. The raw judgment is authoritative. Search degree filters and derived verdict classifications remain separate. Unknown/mixed/qualified judgments are valid; “صحيح الإسناد” is not automatically flattened to an unconditional judgment on the whole narration.

No heuristic locator or verdict classification is required to ship 0.6.0. The types must support it safely, and initial parsers may produce only source-backed fields. If a derived parser is included, its grammar, ambiguity/abstention cases, and fixtures become release requirements.

Raw chains remain source text. Do not produce narrator identities or graph edges by splitting `عن` unless a separate reviewed enrichment contract is implemented later.

Add `EditionDate { raw, components, status }`. Components may carry a numeric year, `hijri / gregorian / unknown` calendar, and original component text. Strip bidi marks only from the derived parsing input. Preserve the original raw field.

`BookInfo.editionYear` remains for compatibility as the raw upstream date field rather than a digits-only truncation. This is a documented behavior change. `editionDate` is nullable for old JSON, and callers requiring a single numeric year must inspect the structured components and calendar explicitly.

<a id="section-5"></a>

## 5. Endpoint implementation contracts

### 5.1 Separate request serializers and capabilities

Replace the shared assumption that all search keys behave identically. One low-level URI encoder may be shared; endpoint serializers and capability validation must be distinct.

| Operation                     | Request contract                                                                                          | Result contract                                                                 |
| ----------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Quick hadith search           | `/dorar_api.json`, `skey`; verified scalar type support only                                              | `ApiResponse<List<Hadith>>`                                                     |
| Detailed site search          | `/hadith/search`, `q`, ordinary filters, repeated `t[]`, optional phrases, verified sort, specialist flag | `ApiResponse<List<DetailedHadith>>`                                             |
| Associated explanation search | Ordinary hadith-search layout, explanation references from matching records                               | Existing `SharhService.search` semantics, with honest unresolved/fetch outcomes |
| Explanation-prose search      | `/hadith/search`, `t=3`, separate prose-search inputs                                                     | `ApiResponse<List<SharhSnippet>>`                                               |
| Alternate collection          | `/h/{id}?alts=1`                                                                                          | `ApiResponse<RelatedHadithResult>`                                              |
| Similar collection            | `/h/{id}?sims=1`                                                                                          | `ApiResponse<RelatedHadithResult>`                                              |
| Circumstances                 | `/h/{id}?asbab=1`                                                                                         | `ApiResponse<AsbabResult>`                                                      |
| Sources                       | `/h/{id}?osoul=1`                                                                                         | Existing `ApiResponse<UsulHadith>`, corrected states and enriched sources       |
| Explanation detail            | `/hadith/sharh/{id}`                                                                                      | `Sharh` with complete header and structural body                                |
| Book card                     | `/hadith/book-card/{id}`; JSON-decoded HTML string                                                        | `BookInfo` with preserved dates                                                 |
| Current narrator choices      | `/hadith/rawi?rawi=…`                                                                                     | Observed `{text,value}` choices with partial-coverage provenance                |
| Books for scholar choices     | `/hadith/sources-by-mohadith?m[]=…`                                                                       | IDs/titles associated with assessments, not authorship                          |
| Thematic discovery/browse     | Four category surfaces below                                                                              | Selectors, category choices, hierarchy, category record pages                   |

Reject unsupported quick-API inputs **before making a request**. The minimum established behavior is unrestricted basic search and scalar qudsi filtering; extend the whitelist only after the phase-0 matrix verifies each behavior. In particular, reject prose search, type 4, multiple type selection, optional phrases, site sort, and specialist behavior on the quick endpoint until evidenced. Never silently discard an input or route to a different endpoint behind a method promising lightweight API results.

For ordinary site types, encode repeated `t[]=…` for 0/1/2/4. Empty selection omits the key. Deduplicate and deterministically order set-valued filters, but preserve optional-phrase order. Preserve the site's existing `all` flag representation where verified. Do not combine type 3 with ordinary types; return a validation error directing callers to prose search.

Use `Uri` encoding for Arabic, whitespace, `&`, `?`, `#`, and plus signs. No raw interpolation of query text. Remove duplicated URI encoders in `DorarEndpoints` and `QuerySerializer`, preserving documented public adapters where necessary.

### 5.2 Explanation-prose search

Add `SharhService.searchText(SharhTextSearchParams)` and `DorarClient.searchSharhText(...)`. Define `SharhSnippet` with explanation ID, source URL, retained snippet document/plain text, visible title or associated record label if present, and query/page metadata.

Recognize article anchors pointing to `/hadith/sharh/{id}`. This parser must not require `#home`, `#specialist`, or `a[xplain]`. A snippet must never be represented as a complete explanation or a hadith matn.

Prose search must not eagerly fetch every linked explanation. Callers can fetch selected snippet IDs. Keep existing `SharhService.search(HadithSearchParams)` as the **associated full-explanation search**: it searches ordinary hadith records, follows each matching explanation reference, and returns `ApiResponse<List<Sharh>>`. Decorate each returned explanation with that link's originating record ID and relationship. Preserve one result per observed originating link in upstream order, even if several records refer to the same explanation ID. The raw explanation fetch may be reused; different originating relationships must not be collapsed into one record.

Apply strict/best-effort policy to secondary explanation fetches as well as initial page parsing. Strict mode propagates a failed fetch with its originating reference; best effort reports each failure and the number of matching references versus fetched explanations. Neither mode silently treats a failed fetch as no explanation.

Keep `getByText` as its documented first-associated-explanation convenience and document source ordering. A text query alone does not prove exact record identity or a direct explanation relationship. It must preserve the chosen link's actual record/relation metadata and propagate errors rather than searching for an arbitrary successful fallback.

Verify totals and navigation links on this layout. Its observed first-page size is 15; do not borrow the ordinary-site cap or specialist metadata.

### 5.3 Alternate and similar collections

Add `HadithService.getAlternates(...)` and `getSimilarResult(...)`, with client conveniences. Preserve every recognized related record in source order.

- Identify the seed by the scoped original-record structure and record ID, not just `borderElements[0]`.
- Keep the seed separately. The new result's `related` list excludes it when its identity is verified.
- If the seed cannot be resolved, strict parsing fails rather than deleting an arbitrary first item. Best-effort results retain ambiguous records with diagnostics.
- Do not deduplicate different record IDs because text matches. Repeated exact records may be reported but must not disappear silently.
- Keep direct source links and available IDs/citations on every record.

Retain `getAlternate` as a deprecated first-item convenience over `getAlternates`, returning null only for a valid empty collection. Document first-in-upstream-order semantics and propagate errors.

Keep legacy `getSimilar` as its established ordered-list projection during 0.6.0; if the baseline fixtures establish that it includes the seed, preserve that behavior and document it. New consumers use the explicit-seed result. Do not silently change its seed inclusion.

### 5.4 Circumstances of narration

Add `HadithService.getAsbab(...)` and a client convenience. Parse capability links on ordinary record/search/explanation headers where present.

`AsbabResult` separates requested record, contextual narration, context citation/record ID if supplied, and observed relation label. At least direct, similar, and unknown relationships must be representable. Different context citations must never inherit the requested record's verdict or source locator.

Preserve contextual prose as a sourced document, including quotation and paragraph structure. Empty content, absent advertisement, and failed parsing are distinct states. Verify seed inclusion and multiple context blocks instead of assuming a single fixed second block.

### 5.5 Thematic categories

Add `CategoryService` as `DorarClient.categories` with:

1. `getRoots()` from `/hadith-category`: real options excluding the placeholder, retaining raw labels and selector values.
2. `search(query)` from `/hadith-category/newcats?cat=…`: HTML-anchor choices retaining category IDs and URLs.
3. `getChildren(selector)` from `/hadith-category/subcategories?category=…`: JSON ID/name mapping, with parent context from the request.
4. `browse(CategoryBrowseParams)` from `/hadith-category/cat/{id}`: record pages and endpoint-specific pagination.

`CategoryBrowseParams` carries category ID, page, specialist selection, local output format, and parse policy. Add additional inputs only if verified. Preserve hierarchy relationships actually supplied; don't construct a complete tree from labels or assume autocomplete enumerates all nodes.

The observed page size is 20 per tab. Category page 11 must remain accessible when advertised; do not apply ordinary-search page ten limits.

### 5.6 Optional phrases and sorting

Expose the four optional phrase fields as **source-form inputs**, not as a newly invented boolean query language. Serialize nonblank entries to `optional_phrase1` … `optional_phrase4`; retain positions if blank slots are supported and proven. Decide slot compaction from the phase-0 fixtures, then document it.

Required verification matrix: primary alone; optional alone; primary plus one optional; unmatched primary plus a matching optional; two/three/four optional fields; blank slots; exact/all/any search modes; excluded text; default/specialist; and two unrelated topics. Record observed behavior and supported combinations.

Support `sort=degree` with an enum. Preserve default order when absent. Test changed ordering with stable totals across at least prayer and fasting fixtures; no claim that source verdict strings determine this ordering locally.

### 5.7 Book choices associated with scholars

Add `ReferenceDiscoveryService` as `DorarClient.referenceDiscovery`, separate from offline reference services. Its `getBooksForScholars(List<ScholarId>)` returns source choice ID, raw title, selected scholar IDs, provenance, and coverage status. Its `searchNarratorChoices(String query)` is the explicit online narrator autocomplete method defined in section 9.3.

Offline author/category methods already removed in the local unreleased work must not be recreated using this endpoint. Name/docs must say “books associated with assessments by these scholars.” Verify two individual scholars and a multi-scholar request before describing union/intersection semantics. Until verified, support only the known individual request rather than pretending a multiple-selection contract.

### 5.8 Label-scoped metadata extraction

Introduce a shared scoped citation/header parser used by detailed records, explanation headers, embedded narration headers, and context records where their labels agree.

- Extract `الراوي`, `المحدث`, `المصدر`, `الصفحة أو الرقم`, `خلاصة حكم المحدث`, and `التخريج` from each header's own label/value relationship.
- Values may be plain spans, linked spans, or classless spans. Styling classes and element order are not field identifiers.
- Explicit unknown labels become diagnostics or retained raw fields; missing optional fields do not shift positional assignments.
- Scholar/book IDs are read only from their actual linked attributes/URLs.
- Keep header and embedded citations independently scoped; changing an embedded grade must not change the page header grade.

Extract direct/similar explanation labels at the link itself. Retain raw labels if an unrecognized relation is encountered.

<a id="section-6"></a>

## 6. Empty, partial, error, and pagination behavior

### 6.1 Empty results

A recognized quick API envelope with its valid empty-result HTML is successful data `[]`, length 0. A recognized empty ordinary/prose/category layout is likewise successful. Unknown/malformed envelopes, HTML challenges, and missing expected regions are parse/structure failures.

Detect the empty shape from captured source fixtures. Do not use “no `.hadith-info` found” alone as proof of a valid empty response. HTTP 404 remains not found; timeout/rate-limit/network errors remain their own typed errors.

For usul, a valid main record with zero source articles returns `sources: []`, count 0, and advertisement evidence from the source. It does not force `hasUsulHadith: true` and does not throw a nonexistent-resource exception solely because the list is empty.

### 6.2 Parsing policy

All recognized record candidates must be accounted for. Strict parsing requires parsed count = candidate count; a failure carries endpoint, stage, and candidate ID/index. Best effort returns valid candidates plus explicit partial diagnostics. Empty parsing of a nonempty candidate region is never complete success.

Unknown optional metadata can leave a successful record with warnings; required identity/text/citation structure failures cannot. Document this boundary per parser rather than wrapping the whole loop in `catch { continue; }`.

A partial result must not be cached as a complete parsed model. With raw caching, the same raw page remains available for deterministic re-parsing, with the current policy producing the same diagnostics.

### 6.3 Page metadata

Add `PageMetadata` with current page, observed page size, displayed total when known, displayed total pages when derived, accessible page limit when established, reachable total upper bound when derivable, truncation state, and next-page evidence.

Next-page evidence is `upstreamNavigation / pageSizeHint / knownLimit / unknown`. `hasNextPage` stays nullable. Full quick-API pages supply a hint, not a confirmed next page. The client must not make an extra hidden request just to turn the hint into certainty.

| Surface                       | Required metadata behavior                                                                                                                                      |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ordinary site search          | Keep displayed totals; separately expose observed max 10 pages / at most 300 accessible records; signal truncation when displayed totals exceed reachable range |
| Quick JSON search             | No invented authoritative total; a full observed page gives `pageSizeHint`; empty/short page uses established contract evidence                                 |
| Explanation-prose search      | Use its own navigation/count evidence and observed size 15; no ordinary-site cap                                                                                |
| Associated explanation search | Preserve underlying page metadata, distinguish candidate hadith count from returned/fetched explanation count                                                   |
| Thematic browse               | Use source navigation and observed size 20; allow verified pages beyond 10                                                                                      |

Legacy `SearchMetadata.total`, `totalPages`, and `hasNextPage` remain documented projections. Do not change `total` into the accessible cap. Expose truncation explicitly so callers can explain why a displayed 30,000-result tab cannot yield 30,000 records through ordinary search.

Negative/zero pages fail validation. An ordinary page beyond a verified limit should fail a specific range validation, not be mistaken for search with zero total matches. Category/prose page validation uses their own contract.

<a id="section-7"></a>

## 7. Structured text and safe formatting

### 7.1 Representation

Add a small serializable document model used by narration, explanation, context, and usul content:

| Element            | Required contents                                                                                                                |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| `SourcedDocument`  | Schema version, source URI, retained source fragment, canonical source text, structural blocks, inline annotations, content hash |
| `DocumentBlock`    | Kind, text range, source evidence, optional independently parsed citation/record, inline children                                |
| `InlineAnnotation` | Half-open text range, kind, source label/URL/definition, evidence; optional reviewed attribution                                 |
| `TextRange`        | UTF-16 code-unit start/end against the document's canonical source text                                                          |

Block kinds: narration, citation/metadata, commentary paragraph, chain, separator, list item, heading, and unclassified paragraph. Only assign a semantic kind when source structure supports it; retain unknown blocks rather than discarding them.

Inline kinds: ordinary link, glossary term, source-marked Qur'an citation, neutral quotation, and optional attribution. Nest/overlap rules must be explicit: links/glossary spans may sit inside quotation ranges; structural blocks partition the text; attribution cannot conflict without a diagnostic.

`sourceHtml` is the retained scoped DOM fragment before cleaning. DOM serialization may change equivalent entity spelling or attribute ordering; it is not claimed to be byte-identical to the original response. The raw-response cache preserves the received decoded response string. `sourceText` preserves the decoded text-node wording, punctuation, diacritics, and bidi characters, using documented structural separators. Exclude site navigation and UI actions by scoped content selection.

The document builder must produce stable canonical text and offset mapping before any display or search normalization. Hash the canonical text with its document schema identity, and preserve URI/record identity separately. Attribution imports must match this hash so stale offsets cannot style changed text.

### 7.2 Deterministic renderings

Provide core helpers for:

- Plain text of the full source document.
- Commentary-only text, preserving separate citation/narration access.
- A safe semantic HTML rendering generated from allowed blocks/annotations.
- Render tokens carrying ranges and source-backed kinds for custom Flutter/application rendering.

Render `<p>` as paragraph boundaries, `<br>` as a line break, `<hr>` as a separator, and lists/headings according to source structure. Collapse incidental HTML indentation in the rendering without globally collapsing block boundaries. Do not insert punctuation, translations, or missing quotation marks into source text.

Keep `removeHtml` supported as a deprecated local rendering selection: true produces documented plain text; false produces retained content markup. Both are generated from the same source response. New rich consumers use the document rather than parsing the returned display string again.

Prefix cleanup is restricted to a verified source numbering prefix at the start of a narration's display text. It never runs on source text or HTML. Distinguish a UI result number from numbers forming part of the narration. Internal `-`, em dashes, ellipses, URLs, attributes, and Arabic punctuation must remain unchanged.

If legacy plain output gains meaningful newlines, document it as a behavior change. Sharing/copying must preserve wording while respecting those paragraph boundaries.

### 7.3 Glossary and Qur'an citation retention

For every source `hist-link` term with `data-content`, retain occurrence range, visible term, decoded definition, and source evidence. Repeated occurrences are separate annotations. Never join them by name or calculate offsets on normalized Arabic.

Treat glossary definitions as source content; if they contain markup, preserve it separately and render it through the same allowed-element policy. Link actions should expose the original URI and visible label.

For Qur'an citation links, retain source label and absolute resolved URL. A tafsir path is a link destination, not an ayah identifier. Parse surah/ayah numbers only from a recognized explicit citation label, with a status and raw label; otherwise leave structured coordinates unknown. Test links whose path number differs from the visible ayah and labels containing multiple verses.

Source-marked Qur'an citation formatting is reliable. Braces or quotation marks alone do not establish divine speech or a canonical ayah reference.

### 7.4 Speaker attribution contract

Use a separate optional `AttributionAnnotation` containing role (`prophet / companion / scholar / divine / narrator / unknown`), optional original speaker name, span, evidence kind, review status, and document hash.

Supported evidence kinds are actual source speaker markup, reviewed annotation, and textual heuristic candidate. The audited pages contain no established universal speaker markup; do not create source-backed annotations from CSS color, hadith `rawi`, grading `mohdith`, quote marks, or the word `قال` alone.

Default behavior:

1. Render citations and commentary using structural evidence.
2. Render detected quotation punctuation with neutral quote styling.
3. Keep speaker unknown unless explicit source markup or a reviewed annotation establishes both speaker and span.
4. Preserve ambiguous dialogue and nested quotations unchanged.
5. Never present a heuristic candidate as confirmed Prophet/companion/scholar speech.

Provide validation/import support for reviewed annotations in 0.6.0. A valid annotation must match document hash and source identity, fall within bounds without splitting a surrogate pair, include reviewer/evidence metadata, and not conflict with another confirmed assignment.

An automatic text-cue experiment is optional, opt-in, and separate from normal parsing. If shipped, it must expose candidates/abstentions and must not change source text or default rendering. It cannot be marketed as a reliable complete classifier without independent reviewed evaluation. Failure to ship this experiment does not block the release; failure to ship safe structural formatting and the explicit unknown/reviewed-attribution contract does.

### 7.5 Attribution and formatting acceptance corpus

The corpus must include:

- All 24 audited explanation pages, including pages with and without embedded cited narrations.
- `2065`: alternating companion/Prophet dialogue after `قال`.
- `2981`: companion responses mixed with narration and separate source material.
- `148939`: an explicit `قال النووي` cue without universal boundary markup.
- `220601`: an unquoted Prophet attribution cue.
- `28565`: uneven/numerous quotation punctuation.
- `114935`, `226191`, and `2065`: source-marked Qur'an links with nontrivial path/label relationships.
- The 20 glossary-bearing narration entries from the six-topic sample, preserving all 71 occurrences.

Release requirements are exact source wording retention, valid ranges, preserved block boundaries, and **zero unsupported confirmed speaker assignments** in this corpus. Reviewed annotation fixtures test intentional confirmed assignments and rejected hash/range mismatches. If heuristic experiments are included, report false confirmed assignments, candidate errors, abstention rate, and coverage separately; passing by labeling nothing must not be described as high attribution coverage.

<a id="section-8"></a>

## 8. Raw-response cache implementation

### 8.1 Chosen design

Move cache ownership from individual transformed service results to a shared internal `CachedDorarTransport` over `DorarHttpClient` and the existing cache store. Cache the received response, then parse/render separately for each service and output request.

Do not retain parallel parsed-model caches in services. The same ordinary search URL may be used by hadith and associated-explanation parsers without a model-shape collision. A plain-text request followed by an HTML/document request must reuse the source response and produce the correct independent rendering.

Preserve existing public service constructors through an adapter that builds/uses the raw transport with their supplied client/cache. `DorarClient` composes a shared transport for its services.

### 8.2 Cache identity and payload

Use a new namespace, **format version 3**, with endpoint identity plus canonical request URI and any response-varying request options. Keep host identity explicit; do not assume `dorar.net` and `www.dorar.net` are interchangeable for all responses.

Canonicalization must preserve ordered optional phrase fields and repeated parameter semantics. Set-valued ID filters can be sorted/deduplicated before URI generation. Local rendering and parse policy do not participate in raw-response identity.

Store a versioned envelope containing response body string, successful HTTP status, content type/encoding metadata needed for interpretation, request/final URI where available, and creation/expiry timestamps. Extend HTTP transport return metadata without breaking existing `get`/`getHtml` conveniences.

Keep the current cache table schema if the envelope fits existing fields. Versioning the payload does not require dropping or resetting SQLite. Ignore v1/v2 payloads under the v3 namespace; expire/evict them through normal maintenance. Keep TTL, in-memory capacity, and SQLite row cap behavior documented and tested.

Never cache transport exceptions as successful responses. Recognized empty results are cacheable. A newly fetched body is admitted to persistent cache after basic endpoint envelope/layout validation; HTML challenges or unknown layouts must not poison a normal response key for seven days. A recognized layout with a malformed candidate can retain its raw source for diagnostics/reparse without being described as fully parsed data.

If a cached envelope is corrupt or invalid for its declared endpoint, treat it as a cache miss, remove that cache entry, and retry the network once through ordinary transport policy. If fresh parsing also fails, surface the typed error. Never loop indefinitely or erase the whole store.

### 8.3 Required cache scenarios

- Hadith search → associated explanation search and the reverse, same source URI.
- Plain → HTML → document and the reverse for two distinct record IDs and search queries.
- Memory hit, persistent hit after reopening, expiry, bounded eviction, and corrupt-entry recovery.
- v2 database retained across upgrade; v3 request never decodes a v2 model body.
- Strict and best-effort parsing of the same cached source produce their correct outcomes.
- Recognized empty search persists as empty; unknown/challenge response does not persist as a valid empty search.
- Two clients/services sharing one persistent store do not mix response models.

Measure representative cached explanation parsing against the existing package before making performance claims. Raw-source parsing on a cache hit is an intentional correctness tradeoff; optimize only if runtime evidence warrants it and without adding a second conflicting cache owner.

<a id="section-9"></a>

## 9. Reference refresh and Arabic search

### 9.1 Snapshot provenance

Add a bundled reference manifest with snapshot version, generation timestamp, source URLs, collection method, schema version, normalization version, record counts, content hashes, and coverage status for books, scholars, and narrator choices separately.

Add a reproducible refresh tool under `tool/`. It fetches Dorar directly, writes candidate snapshots to an output directory, produces added/removed/renamed-ID diffs, and validates before replacing committed assets. It never imports the Node assets as the authoritative current list.

No broad live fetch belongs in normal unit tests or application startup. Refresh is an explicit development/release operation. Keep request volume bounded, honor transport/rate-limit responses, and preserve previous snapshot assets if generation is incomplete.

### 9.2 Books and scholars

Use the current site's full select choices as a dated **current selection snapshot**, excluding placeholders and retaining any intended all-choice sentinel consistently.

- Include the audit's 89 missing book IDs and 14 missing scholar IDs, unless a fresh source snapshot documents a subsequent change.
- Retain renamed raw labels with current provenance and preserve previous labels as historical aliases where useful for search.
- Preserve historical scholar IDs 227/233/291 as historical entries rather than declaring them invalid because they disappeared from a select.
- Distinguish current selectable entries from historical lookup entries. Current browsing should not present retired entries as current site choices by default; explicit historical lookup remains possible.
- Provide conversion helpers between offline `BookItem`/`MohdithItem` and typed search references.
- Stop hard-coding stale counts in README/client/database comments. Counts come from the checked manifest or are described as snapshot-dependent.

Existing unreleased removals/corrections of book constants must be included in the final migration guide. Do not recreate removed constants using speculative source IDs.

### 9.3 Narrator choices

Treat the current bundled 11,436-row database as a baseline of observed choices, not a complete current narrator/person corpus.

Implement a documented online autocomplete method preserving every returned ID and raw label, plus `coverage: partial` and observed count. Extend the packaged snapshot only with choices actually observed in a documented bounded capture; keep the original IDs/labels and do not collapse same-name IDs.

At minimum, the release corpus must capture the four audited queries—Abu Hurayrah, Aishah, Abdullah ibn Umar, Anas ibn Malik—and include their newly observed choices. A 30-choice slice is not represented as all choices for that name.

Keep offline and online methods explicit. An offline lookup miss stays null/missing-local, not “invalid narrator.” Do not silently use an online request inside an offline method. Do not invent an ID-based online resolver if only name autocomplete is established.

### 9.4 Normalized narrator search storage

Add a `normalized_value` column to the existing `rawi` reference table, preserving the existing `key` and `value` columns and their IDs/raw labels. Bump the reference schema to 2 and record a normalization version in the manifest; regenerate the bundled database deterministically. `RawiItem` remains a raw-label public model and does not need to expose the internal normalized column.

Use the package's aligned equivalent of Tawaq `normalizeArabicForSearch` on **both** query and candidate keys: remove specified diacritics/tatweel; fold alef variants, ta marbuta, and alef maksura according to the existing shared rule set. This is a search-only operation.

Ensure `searchRawi` and `countRawi(query:)` use identical predicates. Escape literal `%`, `_`, and the escape character for literal substring search; don't let user text become accidental SQL wildcard syntax. Parameterize SQL values.

Deterministic pagination orders by a defined stable key. Keep existing integer lookup adapters but expose string/typed choice-ID conveniences so callers do not repeat conversion logic. Unknown nonnumeric IDs must not be silently coerced to zero.

If normalized substring search requires scanning, measure against the shipped snapshot. Do not claim that a normal B-tree makes a leading-wildcard substring search indexed. Avoid adding an FTS dependency unless measured behavior justifies it.

### 9.5 Reference store upgrades on every platform

Reference snapshot assets are immutable package data. Generate their SQLite schema metadata, including schema version 2, before packaging. Native Dart and managed native Flutter reference connections open them read-only; they must not run write migrations or mutate verified reference files. In particular, native Dart must not migrate or mutate a pub-cache file. New package versions naturally select new installed assets.

Native Flutter and browser persistence need explicit versioned identity:

- Native Flutter installs to a filename derived from reference snapshot/schema/hash, for example `rawi-<snapshot>-<hash>.db`.
- Browser opens a reference database name incorporating the same snapshot identity instead of always using `dorar_hadith_rawi_db`.
- Both select the new snapshot on an upgrade and leave prior files/stores intact. Cleanup can be a later explicit maintenance operation; do not delete old stores during this release migration.
- Keep API response cache identity/location separate. Refreshing a narrator snapshot does not clear API cache or application favorites.

For caller-supplied reference databases, preserve the caller's ownership. Provide/retain an explicit custom factory path; do not overwrite files because their names look like package defaults. The default 0.6.0 custom-database contract requires schema 2 and rejects incompatible schema with a clear documented error. Supply an explicit migration helper that creates and verifies a schema-2 managed copy of a schema-1 input, adding normalized keys without modifying the caller's original file. Callers opt into that copy and point their factory at it. Never perform a destructive reset.

<a id="section-10"></a>

## 10. Flutter initialization and snapshot installation

### 10.1 Initialization lifecycle

Keep `DorarHadithFlutter.ensureInitialized({Directory? databaseDirectory})` and `isInitialized`.

Implement a shared in-flight initialization future so simultaneous calls with the same configuration share one operation. Validate different directory arguments against the first in-flight/successful configuration and return a clear conflict error; replace the current silent “first directory wins” behavior and document this change.

Set initialized state only after bundle/manifest validation and managed snapshot installation succeed. A failure clears in-flight state and remains retryable. Do not partially publish new global asset/database factories on failure.

Applications must initialize before constructing clients/databases. No hot swapping already-open database instances during an initializer call. Multiple isolates require their own initialization/factories; do not claim the single-isolate future solves cross-process races.

### 10.2 Safe installation

1. Load and validate the reference manifest from the transitive core bundle.
2. Resolve the application-support directory or validated custom directory.
3. Locate the versioned managed filename.
4. If present, validate its expected hash/schema; reuse only the matching snapshot.
5. Otherwise read exactly the asset `ByteData` slice using offset and length, write a temporary file in the same directory, flush/close, verify hash and SQLite integrity/schema, then install under the versioned name.
6. Handle another initializer having installed the same verified target; no half-written file becomes the active database.
7. Configure asset, reference, and API cache factories together, then mark successful initialization.

All temporary files are managed package installation files, not user data. Failed-copy cleanup may remove the temporary file created by that attempt only. A corrupt existing versioned file must produce a recoverable repair path without deleting unrelated files. Preserve prior reference and cache files.

The exact cross-platform rename/install mechanism must be tested on Windows as well as POSIX. Verification uses a strong content hash recorded in the core manifest; use one small shared hashing dependency if required and include it in lower-bound/publication validation.

### 10.3 Advanced factories and errors

Extend `createFlutterConnectionFactory` with explicit snapshot identity/integrity inputs for managed copies. Retain its custom database filename behavior for callers who opt into custom ownership, with documentation that they manage refresh/migration. The normal initializer always uses the managed versioned mode.

`createFlutterCacheConnectionFactory` continues opening the writable API cache in application support, with no reference-asset copy. Propagate open failures without marking initialized.

Provide typed, actionable adapter errors for missing bundle asset/manifest, incompatible reference schema, failed integrity/copy, and configuration conflict. Preserve the underlying cause. Initialization should remain usable offline and must not fetch Dorar to validate assets.

### 10.4 Flutter acceptance scenarios

- Fresh install, second call, simultaneous calls, conflicting directories, and retry after failed asset/copy.
- Existing 0.5.0 `rawi.db` and `cache.db`: current versioned reference file selected; old files untouched; cache remains usable under new namespace.
- Snapshot A → snapshot B across independent runs/processes: B's new IDs and normalized search visible after reopening.
- Nonzero-offset `ByteData` proves that only its intended slice is copied.
- Truncated/corrupt copy never opens as valid; existing unrelated custom file remains untouched.
- Actual transitive JSON/DB/manifest assets load in a fresh hosted-package consumer without manual asset declarations.
- API cache persists in application support rather than process working directory.
- Disposal closes database/client resources before teardown or reopening; test initialization state is isolated between cases through internal test seams or separate processes.

<a id="section-11"></a>

## 11. Compatibility and migration guide

### 11.1 Version policy

Use 0.6.0 for both packages. This is a pre-1.0 minor release with intentional API/behavior changes; don't publish this work as 0.5.1. Preserve existing conveniences where they can remain honest, and name actual breaking changes in both changelogs.

Core target SDK constraint remains `>=3.13.0 <4.0.0`, subject to a real lower-bound test. Flutter target constraints are Dart `>=3.13.0 <4.0.0`, Flutter `>=3.47.5`, matching the verified native Flutter toolchain. If a lower Flutter bound is desired, prove it in CI before lowering the declared bound; do not leave a bound that cannot solve the core dependency.

Keep current dependency changes already present in the tree visible in release review. Do not perform an unrelated dependency sweep. Any new dependency must be justified by an actual requirement such as snapshot hashing.

### 11.2 Required migration topics

| Existing behavior                         | 0.6.0 migration                                                                                                      |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `zone` single selection                   | Use `types`; legacy ordinary zones adapt; prose zone gets a clear method-routing validation error                    |
| Prose search through hadith search        | Use `client.searchSharhText` and snippet IDs                                                                         |
| `Sharh.hadith` is `ExplainedHadith`       | Use `DetailedHadith`; old JSON decodes; explicit lightweight conversion remains available                            |
| `getAlternate` singular                   | Use `getAlternates` to retrieve all records; singular convenience stays first-item with propagated errors            |
| Legacy similar list                       | Keep documented baseline inclusion; use `getSimilarResult` for separated seed                                        |
| Prefix/punctuation-cleaned plain text     | Source wording preserved; plain view may retain punctuation and newlines previously lost                             |
| `editionYear` digits only                 | Raw date now retained; use `editionDate.components` for numeric/calendar needs                                       |
| Silently partial lists                    | Strict error by default; opt into best effort and inspect diagnostics                                                |
| Boolean related availability              | Inspect structured availability/fetch state; false must not imply an unavailable unknown capability                  |
| Fixed copied `rawi.db`                    | Default adapter selects a new versioned managed snapshot; custom factories manage custom DB compatibility explicitly |
| Reinitializing with a different directory | Conflict error instead of silently ignoring the new directory                                                        |
| Stale counts/labels/constants             | Snapshot metadata and documented constant removals/renames                                                           |
| Old SDK bounds                            | Document Dart 3.13 and verified Flutter baseline                                                                     |

### 11.3 Persisted JSON compatibility

Maintain fixtures of published 0.5.0 `DetailedHadith`, `Sharh`, `UsulHadith`, `BookInfo`, and reference JSON, including records without new fields. Decode without requiring new metadata, documents, or provenance. New serialization round-trips every source-backed addition.

Do not silently rewrite old saved religious strings to match live content. An old favorite may retain earlier plain text and lack rich structure; show it as legacy content and optionally fetch current detail through a separate explicit application action. A refresh must not change stable favorite identity or overwrite an independent source assessment.

Document that corrected renderings can affect consumer keys derived from text. Package record IDs/citations must remain stable and historical JSON must remain decodable. Tawaq identity and favorites/recent-history migration will be reviewed in its separate adoption task; it is not a package publication gate. The SDK release must not perform any app-store migration or erasure.

### 11.4 Existing unreleased changes

Before adding this work, inventory changes since the published 0.5.0 source and reconcile the existing `Unreleased` sections. Include current book constant corrections/removals, removed unused book metadata APIs, cache row caps, transport/header fixes, encoded text URLs, validator changes, and Flutter cache wiring in the final release notes if they are actually in the release artifact.

Correct the current cleaner description: a claim that cleanup “only strips prefixes” is insufficient until internal punctuation/HTML preservation tests pass. Remove test/documentation claims referring to integration files that do not exist. Release documentation must describe observed and tested behavior.

<a id="section-12"></a>

## 12. Implementation work packages and ordering

Every phase ends with a reviewable artifact and a gate. Tests for substantive parsing, persistence, and endpoint fixes are required; tests that merely mirror constructors or enum values do not count as verification.

| Phase | Work                                            | Deliverables                                                                                       | Gate                                                                           |
| ----- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| P0    | Lock source contracts and release baseline      | Fixture manifest, endpoint matrix, SDK API inventory, existing-change diff                         | Ambiguities affecting accepted API behavior resolved or explicitly unsupported |
| P1    | Define models/compatibility                     | IDs, references, document model, metadata, legacy decoding tests                                   | Published JSON decodes; package migration examples compile                     |
| P2    | Fix source preservation and metadata parsers    | Scoped header parser, safe content extraction, dates, glossary/Qur'an annotations                  | F11–F18/F21/F22 fixtures pass without wording corruption                       |
| P3    | Move response caching to transport              | v3 envelope, service integration, invalid-entry recovery                                           | F19/F20 cross-service/format/reopen regressions pass                           |
| P4    | Implement endpoint search and relation features | Serializers, prose search, collections, asbab, categories, scholar book choices, pagination/errors | F01–F10/F23/F24 acceptance cases pass                                          |
| P5    | Refresh reference snapshots and search storage  | Refresh tool, manifests, dated asset diff, normalized DB                                           | F25–F27 comparisons/search predicates pass                                     |
| P6    | Complete platform upgrades                      | Flutter atomic/versioned copy, browser identity, native read-only assets                           | Fresh/install/upgrade/custom-storage cases pass                                |
| P7    | Finish package examples and docs                | Independent Dart/Flutter examples, migration guide, changelogs                                     | Package/example/platform checks pass; safe attribution contract demonstrated   |
| P8    | Release candidate and hosted tests              | Core RC, Flutter RC, clean consumers, archive checks                                               | Hosted pair solves/loads assets/operates correctly                             |
| P9    | Stable publication and verification             | Core stable first, Flutter stable second, tags and release records                                 | Both hosted packages and fresh consumers verified                              |

Dependencies: P2 and P3 precede final service verification in P4. P5 precedes P6. P7 cannot close before P4/P6. P8 begins only after all deterministic release gates pass. Stable publication follows successful hosted candidate checks.

### 12.1 P0 evidence tasks

- Re-capture representative source fixtures directly from Dorar; don't assume temporary audit files will remain available.
- Preserve the audit's dated fixtures separately from current captures so genuine upstream changes are visible.
- Verify quick endpoint scalar types and all requested filters across two topics before advertising support.
- Verify ordinary mixed types, optional phrase slots, source-tab behavior, prose pagination, category URI/page keys, and multi-scholar book-choice semantics.
- Establish alternate/similar/asbab seed and item-count contracts from multiple pages, including empty variants.
- Capture a recognized empty response and an unrecognized/challenge response for each supported response family.
- Record exact source URLs, captured timestamps, payload hashes, expected layout, semantic assertions, and which facts are source observations versus derived parser behavior.
- Inventory published-vs-local SDK changes and representative package constructors/getters/JSON/migration examples. Use the separate Tawaq map only as follow-up context.

Unverified leads such as a “found scholars” preset or missing explanation-image triggers remain out of advertised capabilities unless new evidence establishes them. They do not become speculative blockers for the confirmed findings.

<a id="section-13"></a>

## 13. Test specification and finding traceability

### 13.1 Fixture standards

Use full response or scoped source fixtures appropriate to the parser. Metadata assertions must originate from manually inspected source labels/DOM, not existing lossy mapped JSON. Keep stable frozen assertions separate from live smoke assertions.

Minimum breadth: six ordinary topic queries, the 16 main explanation metadata pages, all 24 explanation formatting pages, 16 alternate pages, eight usul pages, six context pages, eight book cards, both audited category pages including page 11, and four narrator autocomplete queries. Where the audit demonstrates a single live edge case, add a second independent captured or synthetic **layout** case and label synthetic content; don't claim it was another real hadith.

Do not assert current totals as eternal upstream constants in live tests. Frozen snapshots may assert dated totals; live checks verify recognized layouts, invariants, nonignored filters, source metadata, and accessible navigation.

### 13.2 F01–F27 acceptance matrix

| Finding                     | Implementation owner             | Required acceptance evidence                                                                                                                      |
| --------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| F01 Site type ignored       | P4 endpoint serializers          | Prayer/fasting qudsi and prayer companion fixtures emit arrays and actually restrict results; quick scalar behavior tested independently          |
| F02 Prose-search layout     | P4 sharh service/parser          | Prayer/fasting/charity prose fixtures return snippet IDs/URLs; no ordinary-tab requirement; unsupported quick prose rejected                      |
| F03 Type 4/multiple         | P1/P4 search API                 | `withExplanation` works; 0+1 source selection preserved; type 3 excluded from ordinary combinations; labels accurate                              |
| F04 Lost alternatives       | P4 related service               | All 31 alternatives from the 16 audited pages retained; `Q0jZhzCM`, `Q3GV55o5`, `Kw3L9vhK` exercise multiple items and citations                  |
| F05 Missing asbab           | P4 context parser                | Six pages preserve requested/context records and direct/similar labels; absent/empty/failed outcomes distinct                                     |
| F06 Thematic browsing       | P4 category service              | Roots/HTML autocomplete/JSON children/browse parse; opaque IDs; both category page-11 fixtures return records                                     |
| F07 Sort/phrases            | P0/P4 search contract            | Two-topic degree order; full phrase matrix; optional-only valid; unmatched primary not mislabeled as blanket OR                                   |
| F08 Scholar source choices  | P4 online references             | Scholar 256 and 1420 choices retained with IDs/titles and assessment association; multi-input semantics proven or rejected                        |
| F09 Empty API error         | P4 response classification       | `zxqvnrplm` and `wqzxvnrplm` yield empty success; malformed/challenge bodies raise structure errors                                               |
| F10 Forced usul flag        | P1/P4 source parser              | `61NF8fB7` and synthetic no-source layout return count 0 without fabricated advertisement; nonempty examples preserve actual states               |
| F11 Lost sharh grade        | P2 scoped metadata               | All 16 main headers retain exact verdict; `137940`/`2981` regression; class/order variation; embedded grade can't overwrite header                |
| F12 Explanation relation    | P1/P2 links                      | All 87 sampled references retain their labels; 85 similar/two direct in frozen corpus; unknown label not forced direct                            |
| F13 Sharh metadata loss     | P1/P2 record model               | Header IDs/categories preserved on all 16; text-only scholar/book fields remain ID-null; linked IDs retained when present                         |
| F14 Flattened explanation   | P2/P7 documents                  | Embedded narration/citation and commentary separable; pure-commentary pages supported; source text preserved in both layouts                      |
| F15 Glossary lost           | P2 annotations                   | 71 occurrences retain term/definition and exact range across five glossary-bearing topics; repeated terms tested                                  |
| F16 Qur'an links lost       | P2 annotations                   | `114935`/`226191`/`2065` preserve label/URI; tafsir path not mistaken for ayah; multi-verse and unknown labels represented                        |
| F17 Dates truncated         | P2 book parser                   | `17632` bidi-prefixed 1356 H, `17629` mixed 1423 H/2002 G, ordinary date, absent and ambiguous dates retain raw values                            |
| F18 Derived types           | P1 typed citations/verdict/chain | Raw locator/verdict/chain round-trip; no fabricated narrator IDs; qualified/mixed judgments abstain from unsupported classification               |
| F19 Cache model collision   | P3 raw transport                 | Hadith/associated-sharh search both orders and two queries on memory/persistent cache cause no type errors                                        |
| F20 Cache format collision  | P3/P2 renderings                 | Two record IDs and queries exercise plain/HTML/document in both orders with one correct raw source                                                |
| F21 Destructive cleaning    | P2 source pipeline               | Internal hyphens/dashes, `hist-link`, `data-content`, URLs, Arabic punctuation intact; only verified display prefix removed                       |
| F22 Lost paragraphs         | P2 documents/rendering           | `p`/`br`/`hr`/lists and commentary boundaries survive; no global whitespace collapse; copy/plain output matches documented rendering              |
| F23 Silent partial failures | P1/P4 policies                   | Malformed second record fails strict; best effort reports index/ID/count; optional field absence allowed; fetch errors never map to null          |
| F24 Pagination ambiguity    | P4 page metadata                 | Ordinary page ten/eleven contrast; category page eleven works; prose own nav; quick full-page hint marked unconfirmed; totals/truncation separate |
| F25 Stale lists             | P5 refresh tools                 | Complete dated book/scholar diff, missing IDs/changed labels accounted for, historical IDs retained, lookup vs current-select distinction         |
| F26 Narrator coverage       | P5 snapshot/online service       | Actual baseline count verified; four live-choice captures retain new IDs/compound labels; partial coverage explicitly represented                 |
| F27 Asymmetric search       | P5 normalized DB                 | Abu Hurayrah/Aishah/ibn Umar variants yield identical ID sets/counts; ta marbuta/alef/tatweel checks; literal wildcards and stable paging         |

No finding may be closed only by updating prose. The matrix links required data/behavior to tests, fixtures, or a verified explicit unsupported capability. Add test paths and result references to this table as implementation progresses.

### 13.3 Additional integration gates

- Nominal IDs prevent cross-domain substitution in compile-time examples; JSON keeps primitive compatibility.
- New service methods are exported and reachable through the normal client.
- Legacy published JSON fixtures decode, new documents/metadata round-trip, and nullable fields remain unknown.
- No source/text range splits surrogate pairs; Arabic marks, bidi controls, and repeated terms have correct offsets.
- Source-preserving hashes reject stale reviewed attribution after a document changes.
- Core native assets open from an installed package without mutation; Flutter transitive assets work; browser snapshot B replaces active A identity without deleting stores.
- Independent package migration fixtures preserve historical JSON; package rendering examples do not confirm guessed speakers. Tawaq favorites/history/UI adoption is deferred.
- Browser local references/cache are tested with actual WASM/worker assets. Online Dorar access is tested from an actual browser origin; compilation alone does not establish CORS support.
- If cross-origin Dorar access is blocked, document the limitation and supported custom transport/proxy integration. Do not advertise unrestricted direct browser online access or invent an unauthenticated third-party proxy.

<a id="section-14"></a>

## 14. Verification commands and CI

Commands below are execution instructions for implementation, not claims that these checks have already been run. Run each group from the indicated working directory. Avoid using the parent application's package resolution as the only proof that a published package resolves independently.

### 14.1 Core package

Working directory: `packages/dorar_hadith`.

```bash
fvm dart pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart format --output=none --set-exit-if-changed lib test tool example
fvm dart analyze
fvm dart test --exclude-tags=live
fvm dart doc
fvm dart pub publish --dry-run
```

Create an `example/` directory with compiling core examples before using that command list. Change generator inputs and regenerate tracked outputs; do not hand-edit `.freezed.dart`, `.g.dart`, or Drift output. Ensure the `live` tag is actually applied to live tests and configured/documented; existing frozen `test/integration/snapshot_test.dart` must remain part of deterministic checks. Replace stale README commands naming missing files.

A separate lower-bound job uses Dart 3.13.0, resolves the declared minimum compatible dependency set, and runs analyzer/tests. If the constraint cannot resolve or generated APIs require a later SDK/dependency, tighten the real lower bound and retest rather than publishing a false compatibility claim. Keep lockfiles for applications/CI reproducibility as appropriate; library manifests must declare sound dependency ranges.

### 14.2 Flutter adapter

Working directory: `packages/dorar_hadith/dorar_hadith_flutter`.

```bash
fvm flutter pub get
fvm dart format --output=none --set-exit-if-changed lib test example
fvm flutter analyze --no-fatal-infos
fvm flutter test
fvm dart pub publish --dry-run
```

During local development, use an untracked `pubspec_overrides.yaml` pointing the hosted core dependency at `..`. For final hosted and archive validation, remove overrides from the disposable validation checkout and create a fresh consumer with no overrides. Do not delete the user's local development override to force a gate.

### 14.3 Tawaq checks deferred

Do not run Tawaq integration as a package release gate or change its source to make this release pass. Its adoption task will run root application analysis/tests and relevant UI/storage checks after its consumers are intentionally migrated. Root analysis excludes packages and never substitutes for the independent package checks above.

### 14.4 Platform evidence

| Platform             | Minimum release evidence                                                                                |
| -------------------- | ------------------------------------------------------------------------------------------------------- |
| Dart native / Linux  | Installed consumer online+offline smoke, cache reopen, read-only package reference assets               |
| Native Flutter Linux | Real app initialization, asset/reference refresh, persistent cache, structured Arabic rendering example |
| Android              | Build and device/emulator smoke for bundled assets, support directory, snapshot upgrade                 |
| iOS                  | Build and simulator/device smoke for bundle/support path and fresh initialization                       |
| macOS                | Build and app smoke for native database loading/assets                                                  |
| Windows              | Build and app smoke including atomic-copy/rename and reopen behavior                                    |
| Core web             | Browser build/run for references/cache WASM, upgraded snapshot, documented online transport behavior    |

Platform claims must correspond to passing evidence. Missing local hardware is handled through CI or another tested runner, not by claiming a Linux unit test verifies iOS/Windows. Record runtime and host configuration where performance or browser persistence claims are made.

### 14.5 CI and live smoke

Add CI for formatting, generation cleanliness, analysis, deterministic tests, lower-bound resolution, archive checks, and representative platform consumers. No live Dorar requests in routine pull-request tests.

Add a manual/scheduled bounded `live` suite for current contract recognition and release smoke. Run it before RC and stable promotion; reuse captures where possible. Report upstream unavailability/rate limiting separately from parser regressions. A skipped/unavailable live run is not passing release evidence: obtain a successful bounded run or resolve the changed contract before promoting stable.

The live suite must not impose brittle exact current counts. Validate two-topic filter effects, multiple related pages, source metadata correspondence, empty results, and both pagination families without crawling the corpus.

<a id="section-15"></a>

## 15. Documentation and distributable artifacts

Update core and Flutter README, changelogs, API docs, and a `docs/MIGRATING_TO_0_6_0.md` guide. Include:

- Endpoint capability differences and supported/unsupported filters.
- Associated explanation search versus prose snippets.
- Seed/related collection semantics and all-alternates example.
- Direct/similar/unknown explanations and separately cited context/narration.
- Document rendering, glossary/links, neutral quotation styling, and reviewed attribution.
- Raw dates/calendar inspection; source verdict/derived classification distinction.
- Empty/partial/error policies and truncation/next-page evidence.
- Reference provenance/current-vs-historical/partial narrator coverage.
- Native Flutter initialization, versioned copies, retry/conflict behavior, and custom database ownership.
- Native Flutter versus core browser responsibilities, required WASM assets, and tested CORS/transport limitations.
- SDK/dependency/JSON compatibility and existing unreleased removals.

Examples must compile and run against the release artifacts. Avoid showing unimplemented fields or impossible combination filters. Use source-based metadata for religious examples and keep derivations labeled.

### 15.1 Archive boundaries

The core package root contains the nested Flutter package. Add explicit publication exclusions so the core archive does not accidentally contain the entire companion package, its build output, temporary captures, or development artifacts.

Use `.pubignore` policies for each package and inspect the actual dry-run file list. Preserve required core assets (`book.json`, `mohdith.json`, reference manifest, `rawi.db`), generated Dart outputs, public library, license, README/changelog, examples, and migration documentation. Exclude `build/`, caches, SQLite journal files, temporary captures, untracked local override files, and nested adapter from the core archive.

Audit fixtures can stay in the repository without requiring their entire capture corpus in a pub archive. Package code must not depend on files excluded from the archive. Keep appropriate redistribution/source attribution for bundled reference data and examples; the existing code license alone does not establish the rights of every third-party asset.

Published packages need a license and resolvable hosted/SDK dependencies; a dry run lists the archive and validates publication conventions. See the official [publishing guide](https://dart.dev/tools/pub/publishing).

<a id="section-16"></a>

## 16. Release candidate and stable publication runbook

### 16.1 Freeze and prepare manifests

1. Recheck both packages' published versions and target availability.
2. Finish all F01–F27 dispositions, platform evidence, package migration tests, independent consumer examples, generation, docs, and bounded live checks. Tawaq adoption is excluded.
3. Capture baseline→release reference diffs and record manifest hashes/counts.
4. Set core to `0.6.0-rc.1`; set Flutter to `0.6.0-rc.1` with a hosted core constraint `^0.6.0-rc.1` for its candidate publication.
5. Remove Flutter `publish_to: none`. Keep development path wiring only in local overrides; no path/git core dependency in the distributable manifest.
6. Align SDK constraints and native Flutter platform metadata; ensure README claims match tested capabilities.
7. Commit reviewed sources/generated files/assets/docs in a clean release checkout. Preserve unrelated user work in the working tree.
8. Run core archive/dry-run checks and confirm the intended published contents.

Publishing validates the current package; prerelease suffixes identify release candidates. The official [publish command reference](https://dart.dev/tools/pub/cmd/pub-lish) describes dry-run validation and the propagation delay when publishing dependent packages.

### 16.2 Publish and test the core candidate

Working directory: core package at the candidate release revision.

```bash
fvm dart pub publish --dry-run
fvm dart pub publish
```

Do not skip validation to bypass an unresolved dependency or SDK error. Confirm the hosted metadata lists `0.6.0-rc.1` and retrieve/install that exact version in a new consumer outside the repository. Verify archive content, code/examples, offline lookups, JSON compatibility, document rendering, response cache behavior, and representative live requests.

Wait for the hosted version to resolve normally before publishing the dependent Flutter candidate. Record published package URI, archive hash/version metadata, source commit, and verification outcomes.

### 16.3 Publish and test the Flutter candidate

In a disposable clean candidate checkout, remove development overrides and resolve Flutter's hosted core constraint. Run its analyzer/tests/dry-run. Then publish:

```bash
fvm dart pub publish --dry-run
fvm dart pub publish
```

Create a new Flutter app outside the repository with exact candidate version pins for the core and adapter, avoiding a solver-selected different version. Run actual transitive asset initialization, reference queries, snapshot-upgrade simulation, and cache reopen on a native target. No manually duplicated package assets or path overrides are allowed in this consumer.

If either candidate needs code changes, publish `rc.2` in the same dependency order and repeat affected hosted verification. Published candidates cannot be overwritten.

### 16.4 Promote stable core

1. Resolve all candidate failures. Re-run affected checks when the candidate implementation changed.
2. Set core version to `0.6.0`. Set Flutter stable manifest version to `0.6.0` and its dependency to **`dorar_hadith: ^0.6.0`**. No prerelease constraint in the stable adapter.
3. Finalize dated changelogs/migration guide and inspect the release diff, generated cleanliness, manifests, asset hashes, and archives.
4. Commit the stable release sources. In the core directory, dry-run then publish core 0.6.0.
5. Verify hosted core 0.6.0 metadata and install the exact stable version in a clean Dart consumer.

The adapter's final hosted dependency cannot resolve until core stable is visible. Local candidate-pair validation happens before this point; final adapter hosted resolution happens immediately afterward.

### 16.5 Publish stable Flutter

After core 0.6.0 is available, use a clean checkout without overrides:

```bash
fvm flutter pub get
fvm flutter analyze --no-fatal-infos
fvm flutter test
fvm dart pub publish --dry-run
fvm dart pub publish
```

Verify that the resolved core is hosted 0.6.0 and that the Flutter archive has no path dependency or `publish_to: none`. Inspect any pub warnings and fix genuine issues before upload rather than forcing past them.

The stable hosted constraint `^0.6.0` and disposable local development overrides follow the official [dependency/override documentation](https://dart.dev/tools/pub/dependencies). Keep published manifests usable independently of this repository.

### 16.6 Tags and release records

Use distinct tags `dorar_hadith-v0.6.0` and `dorar_hadith_flutter-v0.6.0`, both pointing to the reviewed stable source revision when both releases came from that revision. Inspect existing remote tag conventions before introducing tags; never move a published tag to hide a correction.

Push the reviewed release commit/tags to the documented public GitHub repository used by package metadata. The repository also has a separate local `origin` remote, so the runbook must not assume `origin` is the public publication source.

Create separate package release notes if the repository uses hosted release entries. Record both pub.dev links, source commit/tag, SDK bounds, migration guide, reference snapshot ID/hash, checks, and any documented platform/coverage limitations. Leave Tawaq's dependency/submodule adoption to its later requested task.

No automated publishing workflow is mandatory for this release. If added, configure trusted publisher permissions separately and keep core-before-Flutter sequencing and hosted-consumer gates; do not embed long-lived pub credentials in the repository.

### 16.7 Post-publication verification and recovery

Both [core](https://pub.dev/packages/dorar_hadith) and [Flutter](https://pub.dev/packages/dorar_hadith_flutter) pages must list 0.6.0; fresh consumers must install it without overrides and load shipped assets. Re-run the bounded stable smoke once, and verify generated API docs/examples links after pub indexing finishes.

Publishing is not an atomic two-package transaction. If core succeeds and Flutter fails, keep the verified core release available and repair/publish the adapter; record the partial release state rather than announcing the pair complete.

Published versions are immutable. For an ordinary regression, prepare a tested patch release; do not overwrite an archive/tag, remove consumer data, or silently edit the reference snapshot in an existing version. Dependency mistakes may require a pub.dev retraction according to the current [package management guidance](https://dart.dev/tools/pub/publishing#manage-your-package); retraction is not deletion. Recheck the current policy at the time of recovery.

Avoid a blanket cache/database reset as a rollback. Preserve old reference stores and app data; select the last compatible package/snapshot through a documented application rollback when necessary. Keep source/content differences and remaining failures in the release record.

<a id="section-17"></a>

## 17. Definition of done

The work is complete only when:

- Every F01–F27 row has implementation/explicit limitation evidence and passing acceptance coverage.
- Correct endpoint filters, explanation-prose search, alternate collections, asbab, thematic browsing, and scholar-associated choices are reachable through the public client.
- Explanation headers/verdicts/IDs/categories and independent citations are preserved.
- Structured documents retain paragraphs, glossary terms, Qur'an URLs, chains, and original wording; unreviewed speakers remain unknown.
- Raw cache works across services/renderings and upgrades without model collisions or destructive store reset.
- Reference snapshots have reproducible provenance, current book/scholar coverage, honest partial narrator coverage, symmetric Arabic search, and working native/browser upgrade selection.
- Flutter initialization is atomic/retryable, preserves existing files, selects updated assets, and works in a hosted fresh consumer.
- Published package JSON remains decodable and SDK migration examples pass; the package never modifies application-owned stores.
- Package analysis, meaningful tests, generation, lower-bound/platform checks, independent examples, archive inspections, and bounded live smoke have documented passing results. Tawaq checks are deferred.
- Both stable packages are published, resolvable, tagged to reviewed sources, and verified from new consumers without local overrides.
- Release notes/migration documentation describe actual behavior changes, remaining upstream limits, and tested platform support accurately.

Writing this specification completes the planning artifact only. These implementation and publication gates remain future work.

<a id="section-18"></a>

## 18. Recorded implementation decisions (2026-10-06)

The implementation and verification record is [DORAR_0_6_0_IMPLEMENTATION_STATUS.md](DORAR_0_6_0_IMPLEMENTATION_STATUS.md). These adjustments preserve the preceding source/state contracts:

- Best-effort related collections allow an absent `source` if the requested seed cannot be identified. Every ambiguous record is retained with partial diagnostics; strict mode rejects the condition. An observed different seed ID is never replaced by the request ID.
- Qur'an references add `surahName` and parse explicit label verse lists. Numeric surah identity remains unknown without independently verified mapping; tafsir URL numbers are never used.
- Imported/rendered documents validate schema, text hash and structural/annotation ranges before use. Date component `raw` values retain original digits and bidi marks.
- The adapter SDK minimum is tightened to the actually verified Flutter 3.47.5, with Dart 3.13.0. The core was verified on both Dart 3.13.0 with downgraded dependencies and Dart 3.13.4.
- Custom migration outputs and async custom Flutter installation paths use exclusive creation so a concurrently created owner cannot be overwritten or deleted.
- Candidate adapter core dependency is an exact hosted `0.6.0-rc.1` pin. This deliberate RC pairing produces a tight-constraint validator warning; stable uses `^0.6.0`. Local overrides are excluded and hosted validation follows core publication.
- Publish the nested adapter from an isolated staged package directory. Ancestor ignore rules needed to protect the core archive exclude nested publication files.
- Actual browser WASM/reference/cache and A/B snapshot identity checks passed. Direct site and quick-API access were blocked by CORS from the tested origin; online browser use requires an application-owned server-side transport.
- No automatic speaker classifier was shipped. Reviewed annotations and neutral structural formatting satisfy the default contract; unsupported speaker assignment remains absent.
