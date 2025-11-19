# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

## Unreleased
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

## 0.1.1 - 2025-11-11
- Small improvements

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
