# Dorar upstream coverage, data loss, and text structure audit

Audit date: **2026-10-06**, Asia/Riyadh.

Purpose: provide evidence for a later remediation plan. This report does not implement fixes or prescribe a final architecture.

**Only this report was added to the repository. Library code, generated files, tests, bundled assets, dependencies, and public contracts were not changed.** Temporary capture and diagnostic files were kept outside the repository.

## Contents

- [1. Findings that matter most](#section-1)
- [2. Method, scope, and confidence](#section-2)
- [3. Endpoint capabilities are not interchangeable](#section-3)
- [4. Confirmed search and retrieval problems](#section-4)
- [5. Confirmed metadata and content loss](#section-5)
- [6. Cache and preservation defects that affect the audit's requested features](#section-6)
- [7. Reliable formatting and speaker attribution](#section-7)
- [8. Reference data drift and narrator identity](#section-8)
- [9. Useful types for a later design discussion](#section-9)
- [10. What is already covered, and what this audit did not establish](#section-10)
- [11. Test and documentation gaps](#section-11)
- [12. Suggested grouping for the future plan](#section-12)
- [Appendix A — All missing live book choices](#section-13)
- [Appendix B — Reproduction summary](#section-14)

<a id="section-1"></a>

## 1. Findings that matter most

The package already exposes most of the Node wrapper's original fields. The main problem is that the wrapper is an incomplete, sometimes lossy representation of today's Dorar site. Matching its output is insufficient to establish correctness.

The most consequential confirmed findings are:

1. Site narration-type filters use the wrong query shape. `t=1` and `t=2` are ignored by the current site; `t[]=1` and `t[]=2` work.
2. Searching within explanation prose returns a different HTML layout. Both current services expect hadith-result tabs and reject this successful upstream response as a 502 error.
3. Explanation-page verdicts are lost. All 16 explanation pages in the main sample displayed a verdict, but the parser's positional selector would produce an empty grade.
4. Multiple authentic alternatives are discarded. Nine of 16 tested alternate pages contained more than one alternative, while the package returns only the first.
5. Hadith search and explanation search share a cache key despite storing different model shapes. Calling them with the same parameters can throw a runtime type error.
6. The output format is missing from cache keys. Requesting HTML after a plain-text request can return the cached plain text.
7. The default text conversion drops useful structure: glossary definitions, Qur'an links, source boundaries, and the distinction between a direct explanation and an explanation of a similar hadith.
8. Bibliographic dates lose their calendar and sometimes their entire value. Two tested dates became empty because of a leading right-to-left mark.
9. The bundled filter lists are stale: 89 current book IDs and 14 current scholar IDs are absent. The live narrator autocomplete also returns many IDs absent from the bundled database.

The requested speaker-attribution investigation has an important boundary: **reliable structural formatting is possible; universal automatic identification of Prophet, companion, and scholar speech is not supported by the sampled upstream markup.** See section 7 for the evidence and an implementable conservative approach.

<a id="section-2"></a>

## 2. Method, scope, and confidence

### Revisions examined

| Component                     | Revision / version                                                                      |
| ----------------------------- | --------------------------------------------------------------------------------------- |
| Local package                 | `0.5.0`                                                                                 |
| Local repository HEAD         | `e08eb666697c2d2fb986d825f14d46042ec259ea`                                              |
| Node reference implementation | `28f2b3bd1fdaad7dd9e41ac1b42e5afce19a3a1f`                                              |
| Node source                   | [AhmedElTabarani/dorar-hadith-api](https://github.com/AhmedElTabarani/dorar-hadith-api) |

### What was actually checked

- Read the package's models, endpoint builders, serializers, parsers, services, cache behavior, reference assets, and relevant tests.
- Read the original Node mapper, search and explanation services, validators, and reference data.
- Used the shared browser to access Dorar itself and make same-origin requests to its site and JSON endpoint. The Node intermediary was not used for live data.
- Compared native HTTP requests with the package's browser-like headers. Those requests succeeded; an initial plain Python request without those headers received a 403 response.
- Executed temporary Dart diagnostics with the project's FVM-pinned Dart SDK against the actual package sources. These used a temporary in-memory cache substitute, so they did not open or modify the application's persistent databases.
- Replayed small captured live HTML fragments through the real parsers to isolate behavior from transport and caching.

### Breadth of the sample

The primary search sample covered six unrelated query texts, their default first pages, and **173 result entries representing 172 distinct Dorar record IDs**. Distinct record IDs are not necessarily distinct underlying narrations; different scholarly assessments can refer to the same narration.

| Query                | Displayed default-tab total | Sampled entries | Entries with glossary terms | Entries with أسباب ورود links | Explanation links | Links labeled as a similar explanation |
| -------------------- | --------------------------: | --------------: | --------------------------: | ----------------------------: | ----------------: | -------------------------------------: |
| الصلاة               |                      11,173 |              30 |                           2 |                             2 |                17 |                                     16 |
| الصيام               |                       1,112 |              30 |                           1 |                            12 |                22 |                                     22 |
| الزكاة               |                       1,134 |              30 |                           4 |                             0 |                16 |                                     16 |
| إنما الأعمال بالنيات |                          23 |              23 |                          12 |                             0 |                23 |                                     23 |
| بر الوالدين          |                          38 |              30 |                           0 |                             0 |                 8 |                                      8 |
| الوضوء               |                       1,229 |              30 |                           1 |                             0 |                 1 |                                      0 |
| **Total**            |                           — |         **173** |                      **20** |                        **14** |            **87** |                                 **85** |

There were 71 glossary occurrences across these entries. The remaining two explanation links were labeled as direct explanations.

Additional checks covered:

- 16 explanation pages for verdict and metadata handling.
- 24 explanation pages for semantic markup, including seven found through searches for scholar names or speech cues, plus explanation 2981.
- 16 alternate pages across prayer, fasting, charity, parents, and ablution.
- Eight usul pages, including one without sources.
- Six أسباب ورود pages, including direct and similar contextual material.
- Eight book cards, including two recently added book IDs.
- Full current book and scholar option lists, and narrator autocomplete queries for four names.
- Ordinary search pagination and thematic category pagination, including page 11.
- Search sort order, optional phrase inputs, empty results, and endpoint-specific type behavior.

### Confidence labels used below

- **Live + Dart:** reproduced through the package against the current upstream service.
- **Live + source:** observed in multiple upstream responses and tied to an explicit parser/model omission.
- **Source-confirmed:** established by code inspection or a deterministic isolated reproduction; corpus-wide frequency is not claimed.
- **Design opportunity:** useful representation that is not currently available as an authoritative upstream field.
- **Unverified:** a lead that was inspected but did not establish an active feature or contract.

This is a broad audit, not a complete crawl of Dorar's corpus or a guarantee about every undocumented endpoint. Counts and layouts are dated observations. Unknown or unavailable data must remain distinguishable from confirmed absence.

<a id="section-3"></a>

## 3. Endpoint capabilities are not interchangeable

| Upstream surface                            | Observed structure                              | Useful data / behavior                                                               | Important limit                                                         |
| ------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| `/dorar_api.json?skey=…`                    | JSON with `ahadith.result`, whose value is HTML | Basic text, narrator, scholar, source, number/page, verdict                          | No record IDs or authoritative total in tested responses                |
| `/hadith/search?q=…`                        | `#home` and `#specialist` result tabs           | IDs, related links, categories, glossary attributes, explanation relationship labels | Ordinary search serves at most ten pages in tested broad queries        |
| `/hadith/search?q=…&t=3`                    | Articles linking to explanation pages           | Search snippets from explanations                                                    | Neither ordinary result tab nor `a[xplain]` layout                      |
| `/h/{id}`                                   | Detailed record block                           | Record assessment and related capabilities                                           | Some relationships are not encoded in the current model                 |
| `/h/{id}?alts=1`                            | Original record followed by alternatives        | One or several alternative records                                                   | Current package takes index 1 only                                      |
| `/h/{id}?sims=1`                            | Collection of record blocks                     | Similar records                                                                      | Collection semantics need to distinguish seed and related items         |
| `/h/{id}?osoul=1`                           | Main record plus source articles                | Source reference, chain, narration text                                              | No per-chain narrator IDs in the sampled markup                         |
| `/h/{id}?asbab=1`                           | Main record plus contextual narration           | Direct or similar circumstances of narration                                         | Not implemented by the package                                          |
| `/hadith/sharh/{id}`                        | Record header plus explanation content          | Verdict, categories, record ID, optional cited narration, links, commentary          | Default string model loses these boundaries                             |
| `/hadith/book-card/{id}`                    | JSON-encoded HTML string                        | Five bibliography fields plus title                                                  | Date is text, not a calendar-free integer                               |
| `/hadith/rawi?rawi=…`                       | JSON array of `{text, value}`                   | Current narrator filter choices                                                      | Alias strings and compound narrator choices are separate IDs            |
| `/hadith/sources-by-mohadith?m[]=…`         | JSON rows `{id, title}`                         | Books associated with selected scholar's assessments                                 | Association does not mean authorship                                    |
| `/hadith-category`                          | Thematic search/browse page                     | Top-level category choices                                                           | Top-level values are Arabic strings, not the leaf category hashes       |
| `/hadith-category/newcats?cat=…`            | HTML category links                             | Thematic autocomplete                                                                | Not the Node reference asset format                                     |
| `/hadith-category/subcategories?category=…` | JSON mapping leaf IDs to names                  | Category hierarchy discovery                                                         | IDs have more than one observed length                                  |
| `/hadith-category/cat/{id}`                 | Two tabs of category results                    | Browse by subject independently of text search                                       | 20 entries per tab per page in tested categories; pages beyond ten work |

Dorar's [official API article](https://dorar.net/article/389) documents JSON/JSONP access to the lightweight endpoint. It does not establish that every site filter, metadata field, or page shape is exposed identically by that endpoint.

<a id="section-4"></a>

## 4. Confirmed search and retrieval problems

### F01 — Site type filters silently fail

**Confidence:** Live + Dart. **Priority:** high correctness impact.

The serializer currently sends `zone.id` as scalar `t` to both endpoints. On the current site, ordinary type filters need an array-shaped parameter.

| Query  | Parameter      | Default-tab total |
| ------ | -------------- | ----------------: |
| الصلاة | no type filter |            11,173 |
| الصلاة | `t=1`          |            11,173 |
| الصلاة | `t[]=1`        |                96 |
| الصلاة | `t=2`          |            11,173 |
| الصلاة | `t[]=2`        |               630 |
| الصيام | no type filter |             1,112 |
| الصيام | `t=1`          |             1,112 |
| الصيام | `t[]=1`        |                25 |

The package's actual `searchViaSite(... zone: SearchZone.qudsi)` returned 11,173 and 1,112, respectively. This is an ignored filter, not merely a difference in result ordering.

Reproduction sources: [prayer scalar filter](https://dorar.net/hadith/search?q=الصلاة&t=1), [prayer working filter](https://dorar.net/hadith/search?q=الصلاة&t%5B%5D=1), [fasting working filter](https://dorar.net/hadith/search?q=الصيام&t%5B%5D=1).

Owner: [query_serializer.dart](../lib/src/http/query_serializer.dart), `serializeHadithParams`; [search_params.dart](../lib/src/models/search_params.dart).

**Planning implication:** serializers and supported capabilities must be endpoint-specific. Preserve the old single-zone API through a deliberate compatibility decision; do not simply change every endpoint to arrays without verification.

### F02 — An explanation search mode is exposed but cannot be parsed

**Confidence:** Live + Dart. **Priority:** high.

Both `t=3` and `t[]=3` on the site produced explanation-search articles, with anchors such as `/hadith/sharh/30320`, rather than `#home` / `#specialist` hadith blocks. Prayer, fasting, and charity each returned this layout with 15 articles in the tested first page.

`HadithService.searchViaSite` and `SharhService.search` both require an ordinary result tab. Actual Dart calls using `SearchZone.sharh` returned `DorarServerException: Invalid response structure from Dorar (status: 502)` despite upstream HTTP 200.

The lightweight JSON endpoint with `t=3` still returned ordinary hadith records in the tested prayer requests. It did not provide this explanation-search feature.

Sources: [prayer explanation search](https://dorar.net/hadith/search?q=الصلاة&t=3), [fasting explanation search](https://dorar.net/hadith/search?q=الصيام&t=3), [charity explanation search](https://dorar.net/hadith/search?q=الزكاة&t=3).

**Planning implication:** distinguish “find explanations associated with matching hadith text” from “search the explanation prose.” They have different result types and parsers. A snippet result should retain its explanation ID, URL, and query context.

### F03 — Missing type 4 and multiple type selection

**Confidence:** Live + source. **Priority:** medium feature coverage.

The site form includes `t[]=4`, labeled **الأحاديث المشروحة**, and allows multiple checkboxes. `SearchZone` has no value for type 4 and `HadithSearchParams` permits only one zone.

For prayer, `t[]=4` changed totals from 11,173 / 33,666 to 5,546 / 13,265 for the default/specialist tabs. `t=4` did not change the site totals. Combining `t[]=0&t[]=1` produced 10,543 / 32,189.

Type 4 means hadiths with explanations; it must not be described as آثار التابعين. Type 3 means searching within explanations, and has a separate result layout. Combining type flags involving 3 needs additional contract testing before a final API is chosen.

Source: [hadiths with explanations](https://dorar.net/hadith/search?q=الصلاة&t%5B%5D=4).

### F04 — Authentic alternatives are a collection, not always a single record

**Confidence:** Live + source; first-only behavior also exercised through Dart. **Priority:** high data coverage.

`getAlternate` intentionally returns `DetailedHadith?`, but the upstream page can contain several alternatives. `_parseHadithFromBorderElement(borderElements[1])` discards every later block. The Node service makes the same first-only choice.

| Original record | Topic sample | Upstream alternatives |
| --------------- | ------------ | --------------------: |
| `i9N1PTUu`      | Prayer       |                     1 |
| `BRpyQaPP`      | Prayer       |                     1 |
| `Q0jZhzCM`      | Prayer       |                     2 |
| `is6eZe9m`      | Prayer       |                     2 |
| `WYtt5aj3`      | Prayer       |                     3 |
| `QXETlI6C`      | Prayer       |                     3 |
| `vG9L36PK`      | Prayer       |                     3 |
| `6y6pYWK6`      | Prayer       |                     3 |
| `Q3GV55o5`      | Fasting      |                     3 |
| `QPQEXsVj`      | Fasting      |                     3 |
| `RKi1asJG`      | Charity      |                     1 |
| `O7sx39P0`      | Charity      |                     1 |
| `kHeZ3ULL`      | Parents      |                     1 |
| `Kw3L9vhK`      | Parents      |                     2 |
| `DMyQ3Zkn`      | Ablution     |                     1 |
| `VGfHSGLl`      | Ablution     |                     1 |

Nine of 16 pages had more than one alternative. Together these pages contained 31 alternatives; first-only retrieval exposes 16.

Sources: [two alternatives](https://dorar.net/h/Q0jZhzCM?alts=1), [three fasting alternatives](https://dorar.net/h/Q3GV55o5?alts=1), [two parents alternatives](https://dorar.net/h/Kw3L9vhK?alts=1).

**Planning implication:** add an explicit collection capability while deciding whether the existing singular method remains a convenience. Retain the source record, related record IDs, relation kind, and upstream ordering.

### F05 — أسباب ورود is missing, including direct/similar relationship information

**Confidence:** Live + source. **Priority:** substantial missing content.

The site exposes `?asbab=1`, which is absent from endpoint builders, parsers, services, and models. Fourteen entries in the primary search sample advertised it.

Six pages were inspected: `wcyAMgeR`, `ROZIcbYR`, `uZlt2txC`, `ZjENE1Ik`, `SYZx1Nyk`, and `3Ti4cYfm`. All returned HTTP 200 with an original block and a contextual narration. The first was headed as direct circumstances; the other five as circumstances for a similar narration.

The contextual block is independently sourced. For example, the narrator in the original `ROZIcbYR` record was unspecified, while the contextual narration identified a narrator. Its text must not be merged into the original matn or presented as an exact explanation of that record.

Sources: [direct context](https://dorar.net/h/wcyAMgeR?asbab=1), [similar context](https://dorar.net/h/ROZIcbYR?asbab=1), [fasting context](https://dorar.net/h/uZlt2txC?asbab=1).

**Planning implication:** represent a contextual narration and its own citation, with a relation enum such as direct/similar/unknown. Some contextual record IDs appear in editorial `data-pk` markup rather than a share-link `tag`; extraction needs explicit tests.

### F06 — Thematic browsing is missing even though leaf category labels are parsed

**Confidence:** Live + source. **Priority:** medium.

`HadithCategory(id, name)` captures badges from individual records, but the package cannot discover top-level categories, search categories, retrieve subcategories, or browse a category's hadiths.

The thematic page had 179 top-level select options including the placeholder. The subcategory endpoint returned a JSON object mapping leaf IDs to labels. The category autocomplete returned HTML anchors.

Two category pages each returned 20 entries per tab. Their pagination reached 38 and 81 specialist pages, respectively; page 11 returned 20 default-tab entries on both. The ordinary text-search ten-page cap is therefore **not** a site-wide constraint.

Sources: [thematic browser](https://dorar.net/hadith-category), [category example](https://dorar.net/hadith-category/cat/f274e082cc20c93e2d217355f9ee05d4), [second category](https://dorar.net/hadith-category/cat/501a2ed19fdb5c247307c56d389cc8b7).

**Planning implication:** do not reuse ordinary-search page size/caps blindly. Top-level categories and hashed leaf IDs need distinct representations. Preserve IDs as opaque strings; observed leaf IDs include ten-character and longer hashes.

### F07 — Missing sort and optional-phrase search controls

**Confidence:** Live + source. **Priority:** medium.

The site form supports `sort=degree` and four `optional_phraseN` inputs. The package has neither.

- `sort=degree` changed the first result for prayer and fasting without changing the displayed totals.
- Prayer plus `optional_phrase1=الصيام` returned 243 default-tab matches, compared with 11,173 for prayer alone.
- An empty `q` with `optional_phrase1=الصيام` returned 1,112 matches. The package requires a nonempty primary text, so this form cannot currently be expressed.
- An unmatched primary query plus an optional prayer phrase still returned zero. Optional phrases should not be modeled as a blanket OR with the primary query. Their combinations need a dedicated test matrix.

Source: [sort example](https://dorar.net/hadith/search?q=الصيام&sort=degree), [optional phrase example](https://dorar.net/hadith/search?q=الصلاة&optional_phrase1=الصيام).

**Planning implication:** capture verified semantics before naming typed operators. A maximum of four UI fields is an observed UI limit, not yet a documented server limit.

### F08 — Current book choices can be discovered by scholar

**Confidence:** Live + source. **Priority:** optional useful capability.

The live site's JavaScript uses `/hadith/sources-by-mohadith`. Requests for scholar 256 and 1420 returned 51 and 84 `{id, title}` rows respectively. The package has no equivalent discovery method or association metadata.

This associates a scholar's assessments with source books. It must not be interpreted as a list of books authored by that scholar.

Sources: [scholar 256 sources](https://dorar.net/hadith/sources-by-mohadith?m%5B%5D=256), [scholar 1420 sources](https://dorar.net/hadith/sources-by-mohadith?m%5B%5D=1420).

### F09 — Legitimate empty API results are reported as server errors

**Confidence:** Live + Dart. **Priority:** correctness of empty state.

Both exact queries `zxqvnrplm` and `wqzxvnrplm` returned HTTP 200 with zero `.hadith-info` elements. The corresponding site searches also returned zero results.

`searchViaApi` throws `DorarServerException(... status: 502)` whenever the parsed list is empty. Actual Dart requests reproduced this for both queries. An empty successful response must be distinguishable from malformed HTML or an upstream error.

Sources: [first empty API query](https://dorar.net/dorar_api.json?skey=zxqvnrplm&st=p), [second empty API query](https://dorar.net/dorar_api.json?skey=wqzxvnrplm&st=p).

### F10 — Usul availability can contradict the returned source list

**Confidence:** Live + Dart for a no-source case; source-confirmed mechanism. **Priority:** moderate contract correctness.

Eight usul pages were inspected. Seven provided source articles, with two to five sources in most examples. `61NF8fB7` returned the main record but no source articles.

The actual package returned `count: 0` together with `hadith.hasUsulHadith: true`. `includeUsulFlag: true` forces this flag during all usul requests, regardless of parsed source availability. The method documentation also suggests a not-found exception when no usul exists, which does not describe this successful zero-source result.

Source: [no-source example](https://dorar.net/h/61NF8fB7?osoul=1).

**Planning implication:** define separately whether an upstream capability was advertised, whether a request succeeded, and whether any sources were returned. The live no-source example is singular; the unconditional code path establishes that it is not dependent on that record's particular wording.

<a id="section-5"></a>

## 5. Confirmed metadata and content loss

### F11 — Explanation verdicts are dropped

**Confidence:** Live + Dart. **Priority:** high.

`SharhParser.parseSharhPage` uses the document's `.primary-text-color` elements positionally. Current pages place the verdict in a span without that class. Five matching elements therefore mean narrator, scholar, book, number, and takhrij—not an absent verdict.

All 16 main-sample pages had five matching elements and a separately labeled verdict. The current parser would return an empty grade for all 16:

`122219`, `137940`, `111245`, `220601`, `220598`, `220599`, `229936`, `229941`, `229938`, `74201`, `203759`, `211139`, `114935`, `226191`, `2065`, `231281`.

These pages included positive assessments, weak assessments, and chain-specific assessments. Actual Dart calls and captured-parser runs for `137940` and `2981` returned empty grades while the site displayed a verdict.

Sources: [137940](https://dorar.net/hadith/sharh/137940), [2981](https://dorar.net/hadith/sharh/2981), [229936](https://dorar.net/hadith/sharh/229936), [231281](https://dorar.net/hadith/sharh/231281).

**Planning implication:** extract by labels within a scoped header. Do not fill the parent record's grade from a different narration embedded inside its explanation.

### F12 — Direct versus similar explanation is lost

**Confidence:** Live + source. **Priority:** high attribution impact.

Search links explicitly distinguish `شرح الحديث` and `شرح حديث مشابه`. The current parser keeps only the `xplain` ID and availability flag.

In the main sample, 85 of 87 explanation links were marked as similar. This is not an uncommon edge case. `isContainSharh` describes whether a response contains text; it does not express the relationship between the requested record and the explanation's cited narration.

Sources: [prayer results](https://dorar.net/hadith/search?q=الصلاة), [intention results](https://dorar.net/hadith/search?q=إنما%20الأعمال%20بالنيات).

**Planning implication:** retain an explicit direct/similar/unknown relationship and keep the requested record separate from the narration actually being explained.

### F13 — Explanation models discard IDs, categories, and related capabilities

**Confidence:** Live + source. **Priority:** medium/high for programmatic use.

The explanation-page record header exposes a Dorar record ID and category badges, plus some related links. The model embeds `ExplainedHadith`, which cannot hold record ID, scholar ID, book ID, categories, or the same related-content metadata as `DetailedHadith`.

All 16 checked explanation pages exposed a header record ID and categories. For example, explanation 137940 retained record ID `wcyAMgeR` in the DOM; the returned `Sharh` cannot expose it.

Scholar/book IDs should be kept when actually present. Some explanation headers contain text-only metadata rather than the linked card attributes seen in ordinary search, so their IDs cannot always be recovered directly. Name matching is not a reliable substitute.

Owner: [sharh.dart](../lib/src/models/sharh.dart), [hadith.dart](../lib/src/models/hadith.dart), [sharh_parser.dart](../lib/src/parsers/sharh_parser.dart).

### F14 — Explanation text conflates a cited narration, citation fields, and commentary

**Confidence:** Live + source. **Priority:** high formatting and attribution value.

Fifteen of the 16 main-sample explanation bodies began with a separate cited narration block, `.app-hadith-info` metadata rows, a takhrij paragraph, and an `<hr>`, followed by the actual commentary. Explanation 2981 also had this structure.

The whole sibling's `.text` becomes one `SharhMetadata.sharh` string. This loses the boundary between quoted source material and commentary and also hides the fact that the cited narration can differ from the header record.

Eight other examined pages lacked this embedded source wrapper, so its presence cannot be mandatory. A body without the wrapper still needs to be preserved intact.

**Planning implication:** optionally retain the embedded cited narration and its citation independently of commentary blocks. This is a structural extraction, not a claim that every word in the narration is spoken by one person.

### F15 — Glossary definitions are not represented

**Confidence:** Live + source. **Priority:** substantial enrichment opportunity.

Dorar inserts vocabulary explanations as anchors with `class="hist-link"` and `data-content`. Default plain text keeps the visible term but drops its definition.

The primary sample included 20 entries with 71 glossary occurrences, across prayer, fasting, charity, intentions, and ablution. Examples include records `j0j8uiR3`, `7PS5RHwH`, `QPQEXsVj`, `yZ2YjRBk`, `xa4BE1oU`, and `vpbbgKle`.

Sources: [j0j8uiR3](https://dorar.net/h/j0j8uiR3), [intentions search](https://dorar.net/hadith/search?q=إنما%20الأعمال%20بالنيات), [ablution search](https://dorar.net/hadith/search?q=الوضوء).

**Planning implication:** expose term/definition annotations with source-anchored spans. String replacement by term alone is unsafe when the same term occurs several times. Preserve the upstream definition and do not manufacture additional definitions.

### F16 — Qur'an citations and link destinations are flattened away

**Confidence:** Live + source. **Priority:** useful reliable formatting.

At least explanations `114935`, `226191`, and `2065` contained explicit anchors to Dorar tafsir pages. Plain text preserves labels but loses the destination and typed citation identity.

An important trap: `/tafseer/31/5` had the visible citation label `[لقمان: 14]`. The final path component is not safely interpretable as the cited verse number. Likewise `/tafseer/107/1` accompanied a label for verses 4 and 5.

Sources: [2065](https://dorar.net/hadith/sharh/2065), [114935](https://dorar.net/hadith/sharh/114935), [226191](https://dorar.net/hadith/sharh/226191).

**Planning implication:** preserve the label and URI separately. Verse metadata should come from an explicit citation label or a separately verified tafsir contract, not an assumed URL convention.

### F17 — Edition dates lose calendars, secondary dates, and bidi-prefixed values

**Confidence:** Live + Dart. **Priority:** bibliography correctness.

`BookParser` applies `^\d+` to the date string and returns only the first numeric run. A leading U+200F right-to-left mark survives `.trim()` and prevents a match.

| Book ID | Upstream date content                    | Current result        |
| ------- | ---------------------------------------- | --------------------- |
| 6216    | `1400هـ`                                 | `1400`, calendar lost |
| 3088    | `1374هـ`                                 | `1374`, calendar lost |
| 528     | `1421هـ`                                 | `1421`, calendar lost |
| 17632   | U+200F followed by `1356هـ`              | Empty string          |
| 17629   | U+200F followed by `1423هـ - 2002م`      | Empty string          |
| 13559   | `1409هـ`                                 | `1409`, calendar lost |
| 13457   | Explicit source value indicating no date | Empty string          |
| 17594   | `1415هـ`                                 | `1415`, calendar lost |

The two empty dates reproduced through the actual `BookService` against Dorar. The “no date provided” case should remain different from “a provided date was not parsed.”

Sources: [17632 card](https://dorar.net/hadith/book-card/17632), [17629 card](https://dorar.net/hadith/book-card/17629), [6216 card](https://dorar.net/hadith/book-card/6216).

**Planning implication:** retain a raw date string, optional parsed Hijri/Gregorian components, and parse status. No calendar conversion is required to preserve what the source supplied.

### F18 — Structured citations, chains, and verdicts are useful types, but not all fields are upstream data

**Confidence:** Design opportunity grounded in live structures.

Current fields such as `numberOrPage`, `takhrij`, `UsulSource.source`, and `UsulSource.chain` retain valuable text but provide little structure.

Eight usul pages demonstrated separately marked source references and chain text. Examples included source/article counts of three for `j0j8uiR3`, three for `BRpyQaPP`, three for `wcyAMgeR`, and five for `xa4BE1oU`.

The sampled source spans did not contain a book-ID link. The blue chain span contained text, not a typed list of narrator entities. Consequently:

- Book title plus volume/page components can be parsed as optional derived data while retaining the original reference.
- A chain can be displayed as a distinct section reliably, but automatic narrator splitting/linking is a separate interpretation problem.
- A takhrij string can mention multiple works and variant relationships. It must not be split into authoritative citations with a simplistic comma rule.
- `HadithDegree` values are broad search buckets. They are not a complete verdict enum and are not a record's authoritative classification.
- “Chain authentic,” “record authentic,” a judgment about a named narrator, and a combined/qualified judgment should not collapse into a single boolean.

Sources: [usul example](https://dorar.net/h/j0j8uiR3?osoul=1), [multiple intention sources](https://dorar.net/h/xa4BE1oU?osoul=1).

<a id="section-6"></a>

## 6. Cache and preservation defects that affect the audit's requested features

### F19 — Different response models share the same cache key

**Confidence:** Live + Dart and isolated reproduction. **Priority:** high runtime correctness.

Hadith search and explanation search build the same site URL from the same parameters. All services share one `CacheService`, and each stores its already-transformed model under that URL.

`searchViaSite` stores a list of `DetailedHadith`; `SharhService.search` expects a list of nested `Sharh` models. Reading the former as the latter produces a runtime type error. This reproduced with both prayer and fasting requests.

A representative diagnostic was:

```text
_TypeError: type 'String' is not a subtype of type 'Map<String, dynamic>' in type cast
```

The cache's format-version prefix does not distinguish service, operation, or response shape. The Node implementation also caches transformed responses by upstream URL, so the source of the collision predates Dart; strong Dart decoding makes the mismatch particularly visible.

Owner: [dorar_client.dart](../lib/src/client/dorar_client.dart), [hadith_service.dart](../lib/src/services/hadith_service.dart), [sharh_service.dart](../lib/src/services/sharh_service.dart), [cache_service.dart](../lib/src/services/cache_service.dart).

**Planning implication:** choose between caching raw transport responses or explicitly identifying transformed response types in keys. This is a prerequisite for reliable rich/plain content and overlapping services.

### F20 — Output format does not participate in cache identity

**Confidence:** Live + Dart. **Priority:** high for the requested text formatting.

`removeHtml` is intentionally not sent upstream, but cache entries contain parsed output and use only the upstream URL. Fetching an explanation as plain text and then requesting `removeHtml: false` returns the cached plain text.

This reproduced for explanation IDs 137940 and 2981. The isolated diagnostic also confirmed that the plain and requested-HTML outputs were identical and contained no tags.

The same key construction exists in hadith search, single hadith retrieval, similar/alternate/usul retrieval, book lookup, and scholar lookup. The wider scope is source-confirmed; it was not independently exercised on every service.

**Planning implication:** callers cannot currently rely on HTML mode to recover glossary definitions, links, or speech/source boundaries after an earlier plain request.

### F21 — Text cleaners alter internal punctuation and HTML attributes

**Confidence:** Source-confirmed deterministic reproduction, with recurring upstream markup. **Priority:** source preservation.

The detail cleaner uses a global `-\s*:?\s*` replacement. The explanation parser similarly replaces `-\s*` globally. Neither is limited to a leading display prefix.

When applied to `innerHtml`, these expressions also change attribute and class names:

```html
<!-- Input -->
<a class="hist-link" data-content="meaning">term</a>
<!-- Current detail-cleaner output -->
<a class="histlink" datacontent="meaning">term</a>
```

Internal dash punctuation in plain text also disappears. A live search record `t8jgxGXi` contained internal dashes, while the contextual narration in the asbab example used dashes around a parenthetical description.

The current text-cleaner tests explicitly expect internal dashes to disappear in detail mode. Those tests establish Node parity, not preservation of sourced text. Search mode's global numbering regex also needs review for embedded numeric sequences; an actual affected corpus example of that separate issue was not established in this audit.

**Planning implication:** keep source HTML and text immutable, and treat removal of a verified display prefix as a narrow transformation. Never run text cleanup regexes over HTML markup.

### F22 — Paragraph and line-break handling is not reliable

**Confidence:** Source-confirmed; live pages contain the relevant structures. **Priority:** formatting.

The explanation parser uses `.text`, which does not express `<br>`/`<hr>`/paragraph boundaries as a typed document. Formatting then depends on incidental whitespace in the original HTML.

The utility named `extractText` inserts newlines for block elements, but `stripHtml` invokes `cleanWhitespace`, whose first replacement collapses all `\s+` to one space. This removes the newlines it just inserted. It therefore cannot currently serve as a reliable structure-preserving fallback.

Owner: [html_stripper.dart](../lib/src/utils/html_stripper.dart).

**Planning implication:** derive plain text from an explicit block tree, with defined paragraph and line-break behavior, while preserving the original content separately.

### F23 — Partial parsing and fetch failures are silently converted into incomplete results

**Confidence:** Source-confirmed. **Priority:** diagnosability and completeness.

Several loops catch exceptions and continue. Explanation search skips individual explanation fetch failures, similar/search parsing skips malformed records, and alternate parsing can return null after an exception.

No response field identifies skipped records, failed explanation IDs, or partial completeness. A caller cannot distinguish “upstream has no such item” from “the package failed to parse or fetch an item.”

This audit did not establish a broad live failure rate for these paths. The defect is the information contract: when a failure happens, evidence about it is discarded.

**Planning implication:** retain partial-result diagnostics without turning valid empty results into errors. Do not silently cache an incomplete result as if it were a complete successful page.

### F24 — Pagination metadata does not fully describe what can be retrieved

**Confidence:** Live + source. **Priority:** programmatic completeness.

- Ordinary text search served 30 entries on page 10 and zero on page 11 for prayer and fasting. The package already correctly caps ordinary-search `totalPages` at ten.
- `total` can greatly exceed the accessible 300 records, but there is no explicit truncation/accessibility status. A downstream consumer can misread total as retrievable volume.
- API `hasNextPage` is calculated from `length == 15`. It is a hint, not an upstream-confirmed next-page link or total.
- Explanation search does not return the underlying hadith page's totals or next/previous state. Zero explanations on a page is not proof that later hadith pages contain none.
- Category browsing uses 20 records per tab and can traverse page 11 and beyond. Applying the ordinary-search constants to it would create new data loss.

**Planning implication:** model page size, displayed total, accessible range, next-page evidence, and truncation distinctly. Do not describe the existing ten-page cap itself as a bug in ordinary search.

<a id="section-7"></a>

## 7. Reliable formatting and speaker attribution

This section addresses the additional request: format explanation and related text so that a reader can distinguish narration, commentary, companion speech, Prophet speech, and scholar speech where reliable evidence exists.

### 7.1 What the site actually encodes

Across **24 inspected explanation pages**, the examined explanation-content containers had no `q`, `blockquote`, `cite`, or `data-speaker` tags that identified speech roles. The search also checked `data-role` in the primary semantic sample.

The dominant pattern was plain text nodes with `<br>` elements. Some pages prepended a structured source wrapper; some included explicit tafsir anchors. Color-related classes in the source wrapper represented bibliography fields and separators, not speech roles.

The seven additional pages were `229912`, `4630`, `148939`, `42779`, `6578`, `28565`, and `91827`. They were reached from explanation searches involving a scholar name or speech cue, so this check was not limited to short generic explanations.

Important counterexamples:

- Explanation [2065](https://dorar.net/hadith/sharh/2065) contains a question-and-answer narration followed by commentary. A narrator asks a question, an answer follows, and narration resumes, without per-speaker markup.
- Explanation [2981](https://dorar.net/hadith/sharh/2981) includes the response of companions within the sourced narration, alongside other speech and narrative description. Quoting its entire source block as one speaker would be wrong.
- Explanation [148939](https://dorar.net/hadith/sharh/148939) explicitly mentions a statement by al-Nawawi in ordinary text. No tag marks the start/end of that scholar's quoted speech.
- Explanation [220601](https://dorar.net/hadith/sharh/220601) includes an explicit Prophet attribution cue in explanatory prose with no double-quote boundaries. Quotation marks are therefore not required for a quoted statement.
- Explanation [28565](https://dorar.net/hadith/sharh/28565) had 53 double/curly/guillemet quote characters under the audit's quote-character count. A simple globally balanced pair assumption is not valid for every page.

The absence of these tags in the sample does not prove that no record anywhere has better markup. It does establish that a library feature cannot depend on them universally.

### 7.2 Reliability matrix

| Desired distinction                            | Reliable evidence found                      | Practical reliability                           | Appropriate behavior                                |
| ---------------------------------------------- | -------------------------------------------- | ----------------------------------------------- | --------------------------------------------------- |
| Record header versus explanation body          | Scoped DOM layout                            | High, when recognized                           | Separate objects/sections                           |
| Embedded cited narration versus commentary     | Source wrapper, metadata rows, `<hr>`        | High for the recognized variant                 | Extract separate optional source block              |
| Narrator, grader, source, number/page, verdict | Explicit labels                              | High                                            | Parse labeled citation fields                       |
| Direct versus similar explanation              | Explicit link text                           | High                                            | Preserve relationship enum                          |
| Direct versus similar أسباب ورود               | Link label / page heading                    | High                                            | Preserve relation on contextual narration           |
| Glossary term and definition                   | Visible anchor and `data-content`            | High                                            | Source-anchored inline annotation                   |
| Qur'an citation link                           | Explicit tafsir anchor and label             | High                                            | Preserve link and raw citation label                |
| Chain versus narration text in usul            | Separately marked source/chain spans         | High for tested layout                          | Distinct chain and narration blocks                 |
| Paragraph/line break                           | DOM block and break elements                 | High                                            | Preserve structural breaks                          |
| Text surrounded by quotation punctuation       | Literal punctuation                          | Useful typography, incomplete semantics         | Mark as quoted text with unknown speaker            |
| Exact match to another sourced text            | Text alignment                               | Evidence of overlap only                        | Mark overlap without assigning a speech role        |
| A named speaker cue in prose                   | Text phrase such as an attribution verb/name | Heuristic; boundaries may be ambiguous          | Optional candidate annotation with evidence         |
| Pronoun-only or repeated `قال` dialogue        | Contextual interpretation                    | Insufficient for guaranteed automatic labeling  | Keep speaker unknown unless curated                 |
| “Scholar” derived from `mohdith`               | Grader metadata                              | Not evidence of commentary authorship           | Never attribute all commentary to this name         |
| “Companion speech” derived from `rawi`         | Transmission metadata                        | Not evidence that all narrated words are theirs | Never apply a role to the entire matn by this field |
| Speech role derived from color                 | Presentational markup                        | No reliable speaker convention observed         | Do not use as attribution evidence                  |

### 7.3 A conservative programmable representation

A useful content model can separate **document structure** from **speaker attribution**. The following are conceptual candidates, not implemented Dart APIs:

```text
SourcedDocument
  rawHtml
  blocks
  annotations
  sourceUri
  fetchedAt
  parseStatus

DocumentBlock
  kind: narration | citation | commentary | chain | paragraph | separator
  originalText
  inlineNodes
  sourceLocation

InlineNode
  kind: text | link | glossaryTerm | quotation | citation
  text
  uri?
  definition?

AttributionAnnotation
  span
  role: prophet | companion | scholar | divine | narrator | unknown
  namedSpeaker?
  evidenceText?
  evidenceKind: explicitMarkup | curated | textHeuristic
  reviewStatus
```

The block kind describes the container's purpose. It does not imply that every word in a narration block belongs to the Prophet or that every word in a commentary block belongs to a single commentator. Nesting or overlapping annotations may be required for dialogue and quotations.

The citation fields must remain independent: narrator, scholar/assessor, source-book author, commentary author, and speaker are different roles. A missing commentary author should stay unknown.

In the Qur'an examples, the passage used literal braces in prose and a following tafsir citation anchor. That combination provides source-marked citation evidence; braces or quotation punctuation alone should not become a universal scripture detector. Likewise, identifying a narrator as a companion does not establish which spans of a mixed dialogue are that companion's speech.

### 7.4 What can be formatted safely without speaker inference

The following would make a substantial improvement using only source structure:

1. Render the requested record and its verdict as one cited header.
2. If an embedded source narration exists, render it as a second cited source block with its own metadata.
3. Render the remaining commentary as paragraphs with preserved breaks.
4. Retain glossary annotations, tafsir links, and citation labels.
5. Indicate when the explanation or contextual narration concerns a similar record.
6. Give usul source references and chains separate presentation sections.
7. Preserve quotation punctuation and allow neutral quote styling while the speaker remains unknown.

This avoids the current flat string that blends source material and explanatory prose. It does not require changing religious text, generating a paraphrase, or claiming new attribution metadata.

### 7.5 What cannot currently be promised

A regular expression for `قال` or a rule that assigns every quotation to the Prophet is not reliable across the examined pages. A named cue does not necessarily establish where the quote ends. Dialogue can omit names, change speakers, include narrator comments, or quote an additional scholar.

Text normalization can help locate a cue or align repeated text, but those offsets must be mapped back to the original characters. Removing diacritics or folding letters must never become a rewrite of the source body.

Exact matching against an embedded narration can locate some reproduced phrases. It does not classify every phrase's speaker: the original narration itself can contain questions, answers, companion statements, and editorial additions.

If automatic attribution is later explored, keep it as an opt-in derived annotation layer, preserve its evidence and uncertainty, and allow correction. A numerical confidence score alone is not proof. Any language-model-generated attribution would require a separate evaluation and review process; this audit does not establish its reliability.

### 7.6 Verification needed for a later formatting implementation

- Include pages with and without embedded source wrappers.
- Assert that no words, diacritics, punctuation, or citation labels disappear in the source-preserving representation.
- Verify paragraph breaks from DOM structure rather than incidental HTML indentation.
- Include direct/similar explanation relationships and independently cited source narration.
- Test repeated glossary terms and source spans after entity decoding.
- Keep tafsir URI parsing separate from citation-label parsing.
- Use mixed-speaker dialogue, explicit scholar statements, unquoted Prophet attribution cues, and uneven quote punctuation as counterexamples.
- Evaluate any attribution system against a manually reviewed corpus with separate false-attribution and unknown/abstention measurements.
- Require lossless reconstruction or an explicit documented source/display distinction for transformations.

<a id="section-8"></a>

## 8. Reference data drift and narrator identity

### F25 — Book and scholar assets exactly match stale Node lists

**Confidence:** Full-list comparison against the live site's selects. **Priority:** high discovery coverage.

| Reference list | Bundled entries | Live entries | Live IDs missing locally | Local IDs absent from live select | Changed labels |
| -------------- | --------------: | -----------: | -----------------------: | --------------------------------: | -------------: |
| Books          |             685 |          774 |                       89 |                                 0 |              7 |
| Scholars       |             197 |          208 |                       14 |                                 3 |              3 |

Counts include the all-choice entry. The package's two JSON assets were semantically identical to the corresponding files in the examined Node revision.

This is not only a discovery-list discrepancy: the primary hadith sample already contained missing book IDs `17629` and `17632`, and missing scholar IDs `814` and `1031`. A current detailed result can therefore refer to an item that offline lookup cannot resolve.

The 89 missing book IDs are the consecutive range **17578–17666**. The full current labels are listed in Appendix A.

Missing scholars:

| ID   | Current label         |
| ---- | --------------------- |
| 137  | ابن الجارود           |
| 324  | أبو بكر النيسابوري    |
| 343  | الصبغي                |
| 497  | ابن الطلاع            |
| 548  | الحازمي               |
| 734  | ابن سيد الناس         |
| 769  | جمال الدين المرداوي   |
| 783  | يوسف المقدسي          |
| 814  | ابن النحاس            |
| 926  | زكريا الأنصاري        |
| 1031 | زين الدين المناوي     |
| 1307 | صديق خان              |
| 1439 | محمد ابن يوسف الصالحي |
| 1440 | أبو إسحاق الحويني     |

Scholar IDs present locally but absent from the current select: 227, 233, and 291. Absence from that select is not proof that historical records or detail endpoints for those IDs were deleted.

Changed scholar labels: 1438, 803, and 378. Changed book labels: 88, 689, 9016, 9017, 9018, 13520, and 14529. Upstream spelling changes should be reported and sourced rather than silently treated as editorial corrections by this library.

**Planning implication:** define asset provenance and refresh strategy; preserve compatibility for historical IDs; distinguish a missing local reference from an invalid upstream ID. Live synchronization and offline availability are separate design decisions.

### F26 — Narrator autocomplete has IDs and aliases missing from the bundled database

**Confidence:** Live queries plus read-only SQLite comparison. **Priority:** filtering coverage.

The database contains **11,436 rows**. Its ID set matches the Node `rawi.json` ID set; one leading-space difference exists in the stored name for ID 1. Some README/source comments refer to roughly 14,000 or 14,451 narrators, which does not match the bundled row count.

Live autocomplete queries for Abu Hurayrah, Aishah, Abdullah ibn Umar, and Anas ibn Malik each returned 30 choices, including newer IDs in the 100,000 range that are absent locally.

Examples:

- Abu Hurayrah: canonical-looking choice 1416, and additional choices 103281, 102787, 100587, 100591, 100071, 103617.
- Aishah: choices include 101614, 103474, 101626, 101621, and 100179.
- Abdullah ibn Umar: choices include 7687, 100035, 103293, and 104056; the same autocomplete also returns similarly spelled but different names.
- Anas ibn Malik: choices include 2177, 102699, 100783, 102552, and 104379.

Sources: [Abu Hurayrah autocomplete](https://dorar.net/hadith/rawi?rawi=أبو%20هريرة), [Aishah autocomplete](https://dorar.net/hadith/rawi?rawi=عائشة), [Anas autocomplete](https://dorar.net/hadith/rawi?rawi=أنس%20بن%20مالك).

These are **upstream narrator-filter strings**, not a clean unique-person ontology. They include punctuation/diacritic variants, joint narrators, brackets, and uncertain attribution. The live corpus's total narrator-choice count was not established; 30 is the returned autocomplete slice, not its total.

**Planning implication:** preserve choice ID and raw label. Do not merge IDs solely because normalized names match, and do not assume that one named companion constant captures every upstream spelling of that narrator.

### F27 — Narrator search does not normalize Arabic symmetrically

**Confidence:** Read-only database reproduction and source inspection. **Priority:** local search correctness.

Book and scholar reference search use `fuzzyMatch`; narrator search sends the query directly into SQLite `LIKE`. Removing diacritics from stored names does not normalize user input automatically.

The exact SQL behavior used by the repository produced:

| Query            | Matching bundled rows |
| ---------------- | --------------------: |
| أبو هريرة        |                   524 |
| ابو هريره        |                     0 |
| أبو هُرَيْرَة    |                     0 |
| عائشة            |                   292 |
| عائِشَة          |                     0 |
| عبدالله بن عمر   |                   454 |
| عبدالله بن عُمَر |                     0 |

Owner: [rawi_database.dart](../lib/src/database/rawi_database.dart), [arabic_search.dart](../lib/src/utils/arabic_search.dart).

**Planning implication:** separate raw display labels from search-normalized keys, apply aligned normalization to queries and candidates, and verify count/search consistency. This is independent of live reference-data refresh.

<a id="section-9"></a>

## 9. Useful types for a later design discussion

These are candidates for addressing the demonstrated gaps, not a request to add every possible class. Prefer a small coherent model and maintain decoding compatibility deliberately.

| Candidate                                                                            | What it protects                                                         | Source or derivation                                     |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ | -------------------------------------------------------- |
| `HadithRecordId`, `SharhId`, `BookId`, `ScholarId`, `NarratorChoiceId`, `CategoryId` | Prevent accidental substitution of different ID domains                  | Opaque upstream identifiers                              |
| `HadithRecord` / record assessment                                                   | Keeps one scholar/source assessment distinct from a conceptual narration | Existing detailed records                                |
| `ExplanationReference`                                                               | ID, URI, availability, direct/similar/unknown relation                   | Explicit link metadata                                   |
| `RelatedHadithResult`                                                                | Source record and a collection of related records                        | Alternate/similar/asbab pages                            |
| `AsbabResult`                                                                        | Context narration, independent citation, relationship                    | Missing upstream feature                                 |
| `SourcedDocument`                                                                    | Source HTML, structured text, links, glossary terms                      | DOM-preserving extraction                                |
| `Verdict`                                                                            | Original judgment text, optional derived scope, evidence                 | Raw label authoritative; derived classification optional |
| `Citation`                                                                           | Raw source reference plus known source ID and optional locator           | Partial source data plus cautious derivation             |
| `EditionDate`                                                                        | Raw date, calendar, optional components, parse status                    | Book card date string                                    |
| `UsulNarration`                                                                      | Source reference, raw chain, narration text                              | Existing separately marked spans                         |
| `NarratorChoice`                                                                     | Raw label and filter ID, including compound/alias choices                | Autocomplete / reference database                        |
| `ThematicCategory`                                                                   | Parent label, leaf ID, URI, optional hierarchy                           | Category discovery endpoints                             |
| `SearchCapabilities`                                                                 | Supported filters and result layout per endpoint                         | Verified endpoint-specific contracts                     |
| `PageMetadata`                                                                       | Page size, accessible range, total, truncation, next-page evidence       | Upstream and explicitly labeled derivations              |
| `ResultProvenance`                                                                   | Source URI, endpoint kind, fetched time, parse version, cache status     | Client metadata, not source publication time             |
| `PartialResultDiagnostics`                                                           | Skipped records / failed subrequests                                     | Parsing and retrieval observations                       |

Additional decisions worth recording when planning:

- Dart aliases of `String` alone do not provide nominal ID separation. A wrapper or equivalent validation boundary is needed if preventing mix-ups is the objective.
- `RawiItem.id` is a string while narrator lookup APIs accept integers. Books and scholars use strings throughout. A unified boundary would reduce repeated conversions.
- Offline `BookItem` / `MohdithItem` and search `BookReference` / `MohdithReference` represent closely related filter choices but require different objects. Convenience conversion may be enough; wholesale replacement is not automatically necessary.
- No reliable narrator ID was found in ordinary search record headers. Do not fill a new `rawiId` by first-match name lookup.
- A `hukm` accessor is useful, but `grade` and `explainGrade` are currently often the same copied judgment. They should not be interpreted as two independent scholarly assessments.
- A broad query degree cannot safely be reconstructed from arbitrary verdict text by substring matching. Keep unknown, mixed, and qualified cases representable.
- Plain text and HTML are renderings of sourced content, not separate sources. A typed content representation could replace the fragile output-format boolean over time, with a compatibility layer if needed.

<a id="section-10"></a>

## 10. What is already covered, and what this audit did not establish

### Existing coverage that should be preserved

- Basic hadith text, narrator name, scholar name, source name, locator, and raw verdict.
- Detailed record IDs, book/scholar IDs where linked, takhrij, categories, similar/alternate/usul availability links, and explanation IDs.
- Usul raw source/chain/narration text.
- Book bibliography fields other than the lossy date handling.
- Scholar name and biography as source text.
- The ordinary text-search ten-page cap, which improves on the Node implementation's uncapped calculated pagination.
- Valid opaque alphanumeric hadith IDs; category IDs already use strings.
- Direct Dart methods replacing Node wrapper-only URLs such as `urlToGetSharh`; those intermediary URLs are not missing upstream metadata that needs to be copied into the SDK.

### Limits and unverified leads

- No additional structured hadith IDs, category metadata, speaker annotations, or authoritative total were found in the tested lightweight JSON responses. Do not promise to obtain them from that endpoint without new evidence.
- The site's script referenced a “found scholars” preset endpoint, but the tested path returned HTML rather than the expected JSON and the corresponding control was not present on the inspected page. This remains an unverified lead.
- Shared explanation-image scripts were present, but no active `data-sharh-img-url` trigger was found in the inspected search page or explanation 2981. This is not a confirmed missing image capability.
- A complete mobile-app API inventory, translation corpus, audio service, or paid/private API contract was not established.
- Scholar biographies retain their prose. Structured birth/death dates would be a derived feature, not evidence that the current prose parser drops those dates.
- The similar-hadith collection's exact seed-inclusion contract deserves a dedicated decision. The current loop includes every matching block; this audit does not label that alone as a bug.
- Generic timeout/retry, all-platform asset loading, concurrency, and persistence behavior were not exhaustively tested. Only cache behavior directly relevant to metadata/content reliability was reproduced.
- Some relationships may vary across records and future site versions. Missing fields need parse diagnostics and unknown states, not invented fallbacks.

<a id="section-11"></a>

## 11. Test and documentation gaps

The existing tests mainly establish expected behavior against fixtures and mocks. Several current fixtures predate this audit substantially:

| Fixture            | Recorded capture time |
| ------------------ | --------------------- |
| Hadith API search  | 2025-11-02            |
| Hadith site search | 2025-11-02            |
| Single hadith      | 2025-11-02            |
| Explanation 2981   | 2026-06-06            |

The integration example for explanation parsing checks for Arabic text and a non-null explanation, but does not compare the verdict to the labeled upstream verdict. The book example checks the name, not preservation of the date/calendar. The text-cleaner tests intentionally mirror global Node cleanup.

A later verification suite should test source information and endpoint semantics, not only model shape or Node parity. Particularly useful cases are:

- Scalar versus array site type filters on at least two topics.
- Explanation-prose search layout versus ordinary hadith search.
- Labeled verdict extraction from five-class-match explanation pages.
- Multiple authentic alternatives across unrelated topics.
- The same URL requested through different services and output formats, in both orders.
- Empty successful results versus malformed/blocked responses.
- Source wrappers present and absent, plus distinct direct/similar relationships.
- Glossary/link preservation and paragraph boundaries.
- Bidi-prefixed and dual-calendar bibliography dates.
- Category pages with different page sizes and accessible pages beyond ten.
- Asset/live-ID drift and normalized narrator searches.
- Partial parse/fetch diagnostics and source-preserving round trips.

No repository test suite was changed or run for this report-only task. The temporary Dart diagnostics were investigative executions against the existing sources, not newly committed tests or a claim that the full test suite passes.

<a id="section-12"></a>

## 12. Suggested grouping for the future plan

These groupings identify dependencies without committing to an implementation sequence:

| Work area                                      | Findings                         |
| ---------------------------------------------- | -------------------------------- |
| Endpoint contracts and search layouts          | F01–F03, F06–F09, F24            |
| Complete related content                       | F04–F05, F10, F12–F13            |
| Source-preserving text and bibliography        | F11, F14–F18, F21–F22, section 7 |
| Cache correctness and partial-result contracts | F19–F20, F23                     |
| Reference freshness and narrator discovery     | F25–F27                          |
| Public type boundaries and compatibility       | Section 9                        |
| Evidence-oriented regression coverage          | Section 11                       |

Before adding rich text or new retrieval features, the later plan should account for cache identity and source preservation. Otherwise a new parser can produce the right data while callers still receive an older, incompatible, or plain-text cached representation.

<a id="section-13"></a>

## Appendix A — All missing live book choices

These labels were copied from the live site's filter choices as observed on the audit date. They are discovery data, not editorial corrections to titles. Some choices have duplicate-looking labels with different IDs; keep those identities intact.

| ID    | Live label                                  |
| ----- | ------------------------------------------- |
| 17578 | تفسير سورة النساء                           |
| 17579 | إتحاف السائل                                |
| 17580 | الروضة الندية                               |
| 17581 | حسن الأسوة                                  |
| 17582 | ذم الملاهي                                  |
| 17583 | رحلة الصديق                                 |
| 17584 | روضة الطالبين                               |
| 17585 | يقظة أولي الاعتبار                          |
| 17586 | ذم قرناء السوء                              |
| 17587 | إثبات عذاب القبر                            |
| 17588 | الأربعون الأبدال                            |
| 17589 | الأربعون البلدانية                          |
| 17590 | الأربعون الصغرى                             |
| 17591 | الأربعون في الجهاد                          |
| 17592 | البعث والنشور                               |
| 17593 | تبيين الامتنان                              |
| 17594 | التحقيق في أحاديث الخلاف                    |
| 17595 | التماس السعد                                |
| 17596 | تنبيه الغافلين                              |
| 17597 | الجامع في الخاتم                            |
| 17598 | حديث الجويباري                              |
| 17599 | حديث شعبة                                   |
| 17600 | ذم المكس                                    |
| 17601 | ذم من لا يعمل بعلمه                         |
| 17602 | رسالة البيهقي للجويني                       |
| 17603 | فضل عشر ذي الحجة                            |
| 17604 | فضيلة ذكر الله                              |
| 17605 | القراءة خلف الإمام                          |
| 17606 | القضاء والقدر                               |
| 17607 | كتاب الخراج                                 |
| 17608 | مدح التواضع وذم الكبر                       |
| 17609 | المعجم الصغير                               |
| 17610 | معرفة السنن والآثار                         |
| 17611 | مكارم الأخلاق                               |
| 17612 | من اسمه عطاء                                |
| 17613 | ناسخ الحديث ومنسوخه                         |
| 17614 | نفي التشبيه                                 |
| 17615 | أصول الفقه لابن مفلح                        |
| 17616 | النكت على المحرر                            |
| 17617 | فتح البيان                                  |
| 17618 | الحطة                                       |
| 17619 | نشوة السكران                                |
| 17620 | لقطة العجلان                                |
| 17621 | قطف الثمر                                   |
| 17622 | نيل المرام                                  |
| 17623 | فتاوى صديق خان                              |
| 17624 | الإذاعة لما بين يدي الساعة                  |
| 17625 | الأربعون من المساواة                        |
| 17626 | تبيين كذب المفتري                           |
| 17627 | تعزية المسلم                                |
| 17628 | الابتهاج                                    |
| 17629 | مشارع الأشواق                               |
| 17630 | النفح الشذي                                 |
| 17631 | الفوئد المجموعة                             |
| 17632 | فيض القدير                                  |
| 17633 | سبل الهدى والرشاد                           |
| 17634 | تخريج شرح الطحاوية                          |
| 17635 | أقضية رسول الله صلى الله عليه وسلم.         |
| 17636 | الأسامي والكنى                              |
| 17637 | بزوغ الهلال                                 |
| 17638 | تمهيد الفرش                                 |
| 17639 | الفروع لابن مفلح                            |
| 17640 | الاعتبار في الناسخ والمنسوخ                 |
| 17641 | مجموع الشروح الفقهية.                       |
| 17642 | لقاء الباب المفتوح                          |
| 17643 | مسند أبي بكر الصديق                         |
| 17644 | لقاء الباب المفتوح                          |
| 17645 | مسند أبي بكر الصديق                         |
| 17646 | تلخيص المستدرك                              |
| 17647 | الأربعون الصغرى للبيهقي                     |
| 17648 | البعث والنشور الحياة بعد الموت              |
| 17649 | الزهد                                       |
| 17650 | الصمت وآداب اللسان                          |
| 17651 | تهذيب خصائص الإمام علي                      |
| 17652 | مسند سعد بن أبي وقاص                        |
| 17653 | من الفوائد المنتقاة الحسان العوال للسمرقندي |
| 17654 | الأمراض أو الطب النبوي                      |
| 17655 | تخريج مجلسان من أمالي الصاحب                |
| 17656 | جزء فيه مجلسان من إملاء النسائي             |
| 17657 | النافلة في الأحاديث الضعيفة والباطلة        |
| 17658 | جزء فيه مجلسان من أمالي الصاحب              |
| 17659 | بذل الإحسان بتقريب سنن النسائي              |
| 17660 | الرسالة                                     |
| 17661 | المعرفة والتاريخ                            |
| 17662 | تاريخ ابن معين (رواية الدوري)               |
| 17663 | تاريخ أبي زرعة الدمشقي                      |
| 17664 | الإبانة للسجزي                              |
| 17665 | شرح كتاب الذكر والدعاء من صحيح مسلم         |
| 17666 | مجموع تفسير الشيخ عبد العزيز بن باز         |

<a id="section-14"></a>

## Appendix B — Reproduction summary

Temporary diagnostics were run using:

```text
fvm dart --packages=/home/moath/Projects/tawaq-app/.dart_tool/package_config.json /tmp/dorar-audit-20261006/reproduce.dart
fvm dart --packages=/home/moath/Projects/tawaq-app/.dart_tool/package_config.json /tmp/dorar-audit-20261006/live.dart
```

They are temporary audit artifacts and are not required by the package. The following observations are recorded here so the report remains useful if those files are removed:

| Diagnostic                                             | Observed outcome                                                                |
| ------------------------------------------------------ | ------------------------------------------------------------------------------- |
| Native site Qudsi prayer search                        | 30 records, total 11,173; working upstream array filter total was 96            |
| Native site Qudsi fasting search                       | 30 records, total 1,112; working upstream array filter total was 25             |
| Native site explanation mode, prayer                   | Package 502 parse-structure exception; upstream successful explanation articles |
| Native explanation search in explanation mode, fasting | Same 502 parse-structure exception                                              |
| Native explanation 137940 / 2981                       | Empty grade, nonempty explanation                                               |
| Native book 17632 / 17629                              | Empty edition year                                                              |
| Native usul 61NF8fB7                                   | Zero sources, `hasUsulHadith: true`                                             |
| Native exact empty API queries                         | Package 502 exceptions for successful zero-result responses                     |
| Shared site URL across hadith and explanation search   | Runtime model-cast error                                                        |
| Plain explanation followed by HTML request             | Cached result remained plain text                                               |
| Detail cleaner applied to HTML                         | Hyphens removed from class and attribute names                                  |
| Structure-preserving text helper on two paragraphs     | Paragraph boundary collapsed to a space                                         |
| Read-only narrator SQL with diacritized inputs         | Zero matches where undiacritized inputs had hundreds                            |

The final remediation plan should turn these observations into stable, minimal regression cases and preserve dated upstream evidence without treating the Node wrapper as the ground truth.
