# Independent Flutter example

This application demonstrates offline Arabic narrator search, verified transitive references, and on-demand structured explanation rendering. It does not infer speaker identities or contact Dorar during initialization. Online failures remain visible.

For local development, create an ignored `pubspec_overrides.yaml`:

```yaml
dependency_overrides:
  dorar_hadith:
    path: ../..
  dorar_hadith_flutter:
    path: ..
```

Run `flutter pub get`, `flutter test`, and `flutter run -d linux`. Distributable manifests use hosted `^0.6.0` dependencies; local path wiring is excluded from publication.

## Contents

- [Web assets](#section-1)

<a id="section-1"></a>

## Web assets

Compile `tool/drift_worker.dart` from the core repository using the same resolved Drift dependency as the application:

```sh
fvm dart compile js tool/drift_worker.dart -o dorar_hadith_flutter/example/web/drift_worker.dart.js
```

Download `sqlite3.wasm` from the matching [sqlite3.dart release](https://github.com/simolus3/sqlite3.dart/releases/tag/sqlite3-3.7.0). The verified 3.7.0 release asset SHA-256 is `fbcd2e8214f9231ea961e1b7706a22dd1194cfbfe6f26f13841b5aa7a0be1a1f`. Generated worker files and downloaded Wasm are development outputs and are excluded from publication.

Run `flutter build web` or `flutter run -d chrome`. Serve the build with the worker and Wasm at the application base. Offline reference assets are bundled automatically. Dorar requests can be blocked by CORS depending on deployment; do not mistake that transport failure for a successful empty result.

The repository includes Linux/web build validation. Additional platform coverage is listed in the core [release guide](https://github.com/MoathCodes/dorar_hadith/blob/main/doc/RELEASE_0_6_0.md).

For a repeatable offline browser/cache check, compile the core's `tool/browser_smoke.dart` beside these web assets. Supply `window.dorarSmokeComplete(value)` in an HTML host to receive the JSON report. The harness writes only its own `dorar-browser-smoke-only` cache key, reports the prior value and checks narrator lookup/count. It never requests Dorar or clears browser storage. Use disposable served reference copies with a changed snapshot version/hash to verify upgrade identities; keep packaged source assets untouched.
