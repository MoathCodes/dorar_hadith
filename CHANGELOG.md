# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

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
