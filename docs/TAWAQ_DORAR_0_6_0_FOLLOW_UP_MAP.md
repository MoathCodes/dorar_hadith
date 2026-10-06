# Tawaq adoption of Dorar 0.6.0: preliminary change map

Date: **2026-10-06**. Scope: a quick source-based map for the later Tawaq request. No application code changes are part of this document or the package release.

Depends on the implemented contracts in the [package specification](DORAR_0_6_0_IMPLEMENTATION_SPEC.md). Proposed package APIs below are not implemented yet. Reconcile this map with the final published API before changing Tawaq.

## Contents

- [1. Main change](#section-1)
- [2. Existing code → future change](#section-2)
- [3. Sharh: the largest removable workaround](#section-3)
- [4. Detail loading and relationships](#section-4)
- [5. Search and filters](#section-5)
- [6. Lookups, initialization, and caching](#section-6)
- [7. Saved data, identity, and sharing](#section-7)
- [8. Suggested order for the later request](#section-8)

<a id="section-1"></a>

## 1. Main change

Tawaq should become a consumer of structured Dorar content rather than reconstructing upstream structure from flattened strings. Several current workarounds directly overlap the package findings: sharh zone splitting, metadata extraction, lost paragraph recovery, singular alternatives, boolean availability, and pagination clamping.

The package can own source extraction and endpoint semantics. Tawaq still owns navigation, Riverpod state, loading/retry behavior, favorites, layouts, themes, accessibility, and export choices. Better SDK data will simplify these flows, but it does not automatically solve app-specific state or UI issues.

The package release must not wait for this adoption. The user will request the Tawaq work separately after the packages are finished.

<a id="section-2"></a>

## 2. Existing code → future change

Paths in this table are relative to Tawaq's root. The linked owner sections below provide the entry points.

| Area                     | Current behavior                                                                                      | Later Tawaq change                                                                                                                  | Priority                                                                  |
| ------------------------ | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Sharh structure          | Flat `sharhText` is split into matn/metadata/commentary using regex and text markers                  | Render `Sharh.document` blocks and separately cited narration directly; legacy string fallback for older content                    | First adoption                                                            |
| Metadata                 | App re-parses `الراوي`/`المحدث`/other labels from the body string                                     | Use the corresponding structured citation/header, keeping explanation header and embedded narration independent                     | First adoption                                                            |
| Paragraphs               | Normalizer collapses whitespace; renderer attempts to infer paragraphs from segment kinds/blank lines | Use source-backed paragraph/list/separator blocks and avoid re-normalizing their canonical text                                     | First adoption                                                            |
| Inline formatting        | App tokenizes quotes, gloss cues, section leads, and generic `قال …:` as `scholarLead`                | Use source glossary/link/citation annotations; keep optional editorial cues neutral and separate from confirmed speaker attribution | First adoption                                                            |
| Explanation relationship | Generic explanation section loads only a sharh ID                                                     | Carry originating record/reference; label direct versus similar explanation and show its own citation                               | First adoption                                                            |
| Alternatives             | Detail provider returns one nullable alternate and the pane renders one card                          | Fetch the complete related result and display its ordered collection                                                                | First adoption                                                            |
| Similar records          | Bare list has no explicit seed/relationship context                                                   | Use separated seed/related result; preserve record IDs and upstream ordering                                                        | First adoption                                                            |
| Usul                     | Section is gated by a boolean and empty results become a generic placeholder                          | Distinguish advertised capability, successful empty sources, and error; render citation/chain/narration separately                  | First adoption                                                            |
| Pagination               | App uses `totalPages` and clamps it after an empty later page                                         | Use accessible limits, truncation, and next-page evidence; keep the previous page on fetch failures                                 | First adoption                                                            |
| Filters                  | Single `SearchZone` selector includes sharh as if it were a hadith scope                              | Multi-select ordinary types; explanation prose becomes its own search mode                                                          | First adoption                                                            |
| Lookup choices           | Scholar/narrator repository comments say remote, but client methods actually use offline references   | Correct ownership/docs; refreshed offline lookups plus an explicit online narrator-choice flow when desired                         | First adoption                                                            |
| Saved favorites          | Detailed record JSON is persisted; fallback identity depends on text hash                             | Preserve old records/keys; consume new metadata when present without automatically rewriting old content                            | First adoption                                                            |
| Sharing                  | Card receives a flat sharh string, and usul rows display source/chain                                 | Export selected document sections with their own citations and relation labels; choose whether source narration is included         | First adoption                                                            |
| أسباب ورود               | No detail kind/section                                                                                | Add context section using independent citation and direct/similar relationship                                                      | Feature expansion                                                         |
| Thematic categories      | No category browse flow in inspected hadith screen                                                    | Add subject discovery/browse using category service and its own pagination                                                          | Feature expansion                                                         |
| Prose search             | Current zone selector routes through detailed hadith search                                           | Add snippet results and explanation navigation rather than treating snippets as hadiths                                             | First adoption if retaining the sharh option; otherwise feature expansion |
| Sort/phrases             | No sort/optional phrase fields in app filters                                                         | Expose degree ordering and verified source-form optional phrases in advanced search                                                 | Feature expansion                                                         |
| Scholar-associated books | Book lookup is independent of selected scholars                                                       | Optional dependent book choices, explicitly associated with assessments rather than authorship                                      | Feature expansion                                                         |
| Bibliography             | Book lookup choices provide ID/name; no full book-card flow identified in this pass                   | If adding source-book details, use raw/calendar-aware date components                                                               | Feature expansion                                                         |

“First adoption” means needed to correctly adopt the richer package contracts, not that Tawaq must change before package publication. Feature expansion is a separate product choice for the later request.

<a id="section-3"></a>

## 3. Sharh: the largest removable workaround

Entry points:

- [Sharh models](../../../lib/feature/hadith/domain/models/hadith_sharh_models.dart).
- [Zone splitter](../../../lib/feature/hadith/domain/services/hadith_sharh_zone_splitter.dart).
- [Metadata parser](../../../lib/feature/hadith/domain/services/hadith_sharh_metadata_parser.dart).
- [Normalizer](../../../lib/feature/hadith/domain/services/hadith_sharh_normalizer.dart).
- [Segment tokenizer](../../../lib/feature/hadith/domain/services/hadith_sharh_segment_tokenizer.dart).
- [Sharh renderer](../../../lib/feature/hadith/presentation/widgets/detail/hadith_sharh_text.dart).
- [Dorar text cleaner](../../../lib/core/text/dorar_text_cleaner.dart).

The current zone splitter searches for `الراوي` and guesses metadata termination from takhrij/verdict markers and blank lines. It also treats a four-to-seven-digit body as an ID placeholder. The metadata parser reconstructs fields from that guessed zone. The normalizer applies typography/artifact cleanup and collapses `\s+`, which includes newlines. The renderer later tries to recover paragraph starts from section-leading tokens or blank lines. These responsibilities overlap the source structure the new SDK will preserve.

For new documents, replace this pipeline with a small adapter from package blocks/annotations to app widgets/TextSpans. Retain shared theme and commentary rendering utilities where useful; avoid deleting shared typography infrastructure used by tafsir or other features. The Dorar-specific cleaner currently has only hadith consumers in the inspected source, but confirm references again before removing it.

Keep the existing string parser as a clearly identified fallback for records without documents during migration. Remove it only when legacy display is intentionally handled elsewhere. Do not force old content through a network refresh to make the renderer work.

Reliable new rendering includes paragraphs, glossary definitions, linked Qur'an citations, and independent narration/citation blocks. The generic `قال …:` token is not evidence that the speaker is a scholar. Neutral quotation styling can remain; confirmed Prophet/companion/scholar styling requires source evidence or a reviewed attribution matching the document. The package does not magically supply reliable speakers for every passage.

<a id="section-4"></a>

## 4. Detail loading and relationships

Owners: [detail provider](../../../lib/feature/hadith/presentation/provider/hadith_provider.dart) and [detail pane](../../../lib/feature/hadith/presentation/widgets/detail/hadith_detail_pane.dart).

The current provider returns `Object?` keyed by a detail-kind enum and string ID. The pane casts each kind to its expected shape. Moving alternatives from a nullable record to a collection and adding context results changes those casts. Prefer typed detail providers/results or a small typed union when doing that work, so a wrong payload shape is caught at the boundary.

A sharh-ID-only fetch does not retain why the original hadith linked to that explanation. Pass the selected record's `ExplanationReference` into the detail view and combine that relationship with the fetched explanation. Shared raw fetches by explanation ID can remain reusable; relation labels must be specific to the originating record.

Preserve lazy accordion fetching: only expanded remote sections currently watch their provider. Rich data does not justify fetching all alternates, context, usul, and explanations whenever a result card becomes visible.

Retain loading, retry, and error UI. Successful empty related content needs a distinct message from a failed request. Add localized direct/similar/unknown explanation/context labels, and keep each embedded/context record's verdict/source independent of the selected hadith.

<a id="section-5"></a>

## 5. Search and filters

Owners: [filter model](../../../lib/feature/hadith/domain/models/hadith_filters.dart), [filter form](../../../lib/feature/hadith/presentation/widgets/filters/hadith_filter_form.dart), [search provider](../../../lib/feature/hadith/presentation/provider/hadith_provider.dart), and [session state](../../../lib/feature/hadith/domain/models/hadith_session_state.dart).

Change the ordinary scope selector from one `SearchZone` to a type-filter set; migrate old all/marfoo/qudsi/companion selections explicitly. “Hadiths with explanations” is a search filter, not another speaker identity. Specialist still means the source's specialist/takhrij tab, not an authentication degree.

Remove sharh prose from the ordinary hadith-result path. If the feature remains visible, give it a distinct mode with `SharhSnippet` results, its own pagination, and navigation to full explanation detail. Existing result cards/bookmark actions expect `DetailedHadith`; they cannot safely receive explanation snippets. Mode switching should reset page/selection and avoid mixing cached session results.

If optional phrases are exposed, update validation: current pagination requires a nonempty primary query, so optional-only search needs a deliberate usable-query predicate. Recent searches currently store only strings; preserving advanced modes/phrases/filters would require a separate saved-search model migration, not simply changing the displayed label.

The current page controller preserves the previous page on errors and clamps `totalPages` when a later page is empty. Keep its recoverable state behavior, but use package-provided accessible bounds instead of discovering a cap by empty responses. Display truncated access separately from total matches. Category browsing must not inherit ordinary text-search page ten limits.

<a id="section-6"></a>

## 6. Lookups, initialization, and caching

Owners: [repository](../../../lib/feature/hadith/data/repository/hadith_repository.dart) and [initialization provider](../../../lib/core/bootstrap/app_init_providers.dart).

The app already waits for `DorarHadithFlutter.ensureInitialized()` before constructing `DorarClient`, and disposes the client with its provider. Keep that composition. Updated reference copies and cache namespaces are handled by the packages; Tawaq should not copy databases, clear cache files, or rebuild a second response cache to compensate.

`repository.searchRawi` and `searchScholars` are described as remote, but they delegate to offline client reference services. After the package refresh, symmetric Arabic search and newer reference choices improve the existing lookup flow without a network dependency. Add explicit online narrator autocomplete only if requested; show its partial choice coverage and preserve ID/label pairs. Similar labels are not grounds for merging IDs.

Keep Riverpod deduplication, auto-disposal, debouncing, and search-generation guards. These manage app lifecycle/stale UI work and remain useful after transport-cache fixes.

<a id="section-7"></a>

## 7. Saved data, identity, and sharing

Owners: [local database](../../../lib/feature/hadith/data/database/hadith_local_database.dart), [identity helper](../../../lib/feature/hadith/domain/models/hadith_identity.dart), [repository](../../../lib/feature/hadith/data/repository/hadith_repository.dart), [share dialog](../../../lib/feature/hadith/presentation/widgets/share/hadith_share_dialog.dart), and [share card](../../../lib/feature/hadith/presentation/widgets/share/hadith_share_card.dart).

Favorites store `DetailedHadith.toJson()` in a saved envelope. The package's backwards decoding should preserve these. New favorites can carry document/reference metadata; old favorites remain displayable without it. Refreshing a favorite should be an explicit action preserving its existing assessment/identity.

The identity helper already prefers a Dorar record ID, then falls back to book/locator/narrator/text `hashCode`. Corrected punctuation/newlines can change that fallback. Inventory real saved keys before redesigning identity, and preserve a mapping to existing keys if migration is needed. Do not relabel every favorite or assume wording equality means the same scholarly assessment.

The repository's `resolveDetails` uses exact-text search plus narrator/scholar matching and refuses an unrelated first result. Preserve that protection. New IDs help when already available; quick-API results still lack verified record IDs, so the spec does not eliminate all resolution ambiguity.

Sharing should consume the same structured content/relation context as the detail view. A similar explanation must not appear as a direct explanation of the selected record merely because both were exported together. Keep citations attached to embedded narration, context, and usul. Decide explicitly whether exports include commentary only, quoted narration, source chains, or all selected sections; retain current user-controlled inclusion settings and export loading/error guards.

<a id="section-8"></a>

## 8. Suggested order for the later request

1. Adopt the finished package versions/API; validate initialization and old favorite JSON without adding new UI features.
2. Replace the new-content sharh parsing pipeline with document rendering, preserving legacy fallback and safe attribution.
3. Migrate detail payloads and relationship labels; display all alternatives and correct usul/empty/error states.
4. Migrate ordinary filters and pagination; give the existing sharh option a valid separate flow or remove it until that flow is implemented.
5. Align sharing and identity/storage compatibility with the new content model.
6. Add optional features: context, thematic browsing, richer online choices, advanced phrases/sort, and book details.

Later validation should focus on existing favorites, selected-record identity, mixed dialogue, pure versus metadata-rich sharh, glossary/citation interactions, multiple alternatives, ordinary versus category paging, and copy/share output. Existing hadith tests provide the starting point; replace heuristic-parser assertions with document/rendering behavior for new content while keeping legacy coverage.

This is a preliminary dependency map, not a full app redesign or a claim that every current hadith issue comes from the SDK. Package implementation and publication proceed independently.
