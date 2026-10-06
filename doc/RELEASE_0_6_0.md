# Publish stable 0.6.0

Both package manifests use `0.6.0`. The Flutter adapter depends on hosted `dorar_hadith: ^0.6.0`. The owner selected a direct stable release after local checks; the earlier RC proposal was not published. Local path wiring belongs in ignored development overrides.

## Contents

- [Verify package behavior](#verify-package-behavior)
- [Prepare isolated archives](#prepare-isolated-archives)
- [Publish in dependency order](#publish-in-dependency-order)

## Verify package behavior

Run core resolution, analysis, offline tests and generation. Check the adapter separately. Run the independent Flutter example, verify transitive assets and native reference/cache lookup, and build Linux and web. The checked dependency locks under `.github/locks` record current-toolchain dependencies. Check core separately on Dart 3.13.0 with `pub downgrade`. The verified Flutter minimum is 3.47.5.

The GitHub workflow checks Linux, Windows and macOS, minimum Dart, and browser compilation. Record actual remote results; adding a workflow does not prove those checks passed. Android/iOS device runtime remains unverified. The direct stable release decision accepts that additional platform coverage remains follow-up work. Local browser reference/cache and snapshot A/B checks passed. Direct online browser responses were blocked by CORS and require an application-owned server transport.

Normal tests use captured responses and do not contact Dorar. Explicit development commands are:

```sh
fvm dart run tool/capture_upstream_contracts.dart
fvm dart run tool/refresh_references.dart /tmp/dorar-reference-candidate
```

Reference refresh produces candidates, validates hashes and snapshot integrity, and reports source ID/name differences. `--fetch` explicitly recaptures five reference sources. Review candidates before replacing committed assets. Narrator coverage remains partial; the historical baseline is not a complete current site list.

## Prepare isolated archives

```sh
fvm dart run tool/prepare_release.dart /tmp/dorar-release-stable
```

The output contains two independent package layouts with sources, generated files, assets, documentation and examples. It excludes builds, caches, captures, development overrides and lockfiles. Core excludes the nested adapter. The tool refuses an existing output or symbolic links.

Run `dart pub publish --dry-run` in each staged package. Inspect its actual file list, archive size and required assets. Verify asset hashes against the manifest. Test a disposable Dart consumer from an unrelated working directory and a separate Flutter consumer. Temporary local overrides support prepublication checks; remove them for hosted validation.

Publish the adapter from its isolated directory. Core ignore rules intentionally exclude it and also hide it during an in-place nested publish. Use `pub get --no-example` during prepublication staging; check hosted example resolution after both packages exist. Old build files tracked in the repository are excluded from deliverables.

## Publish in dependency order

1. Check documentation, API/reference changes, generated files and archive boundaries. Commit reviewed sources and push `main` using a normal fast-forward.
2. Publish core `0.6.0` through pub authentication. Verify its registry metadata and archive SHA-256.
3. Remove adapter development overrides and resolve hosted core `^0.6.0`. Analyze, test and dry-run the adapter, then publish adapter `0.6.0`.
4. Use clean caches to check independent hosted-only Dart and Flutter consumers, including unrelated-directory assets, transitive Flutter assets, reference lookup and persistent cache.
5. Record package URLs, archive hashes, tested SDKs, checks and remaining platform coverage in the implementation record. Mark publication complete only after registry verification.

The staging tool performs no commit, push or upload. Published versions cannot be replaced; fix a released issue with a new version. Keep saved religious text and application data intact during migration. Tawaq adoption remains a separate request.
