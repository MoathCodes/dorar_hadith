# Dorar Hadith Flutter

Flutter adapter for [`dorar_hadith`](https://pub.dev/packages/dorar_hadith). It wires `rootBundle` asset loading and copies the offline `rawi.db` narrator database into a persistent application directory.

Pure Dart/CLI consumers should continue using `dorar_hadith` directly. Flutter Web apps should also use the core package (WebAssembly database + HTTP asset loading); this package targets **native Flutter** (Android, iOS, Linux, macOS, Windows).

## Installation

```bash
flutter pub add dorar_hadith_flutter
```

This pulls in `dorar_hadith` transitively, including bundled JSON and database assets. You do **not** need to re-declare `rawi.db` or the reference JSON files in your app `pubspec.yaml` — Flutter bundles transitive assets from `dorar_hadith` automatically.

## Setup

Call `ensureInitialized()` once in `main()` before `runApp()` and before any offline reference or narrator APIs:

```dart
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DorarHadithFlutter.ensureInitialized();
  runApp(const MyApp());
}
```

### What `ensureInitialized()` does

1. **`configureFlutterAssetLoader`** — registers `FlutterAssetLoader` with `rootBundle.loadString` so `BookReferenceService` and `MohdithReferenceService` read bundled JSON.
2. **`RawiDatabase.configureConnection`** — installs a factory that copies `rawi.db` from the asset bundle into a writable directory, then opens it with Drift `NativeDatabase`.

The method is **idempotent**: after the first successful call, `DorarHadithFlutter.isInitialized` is `true` and further calls return immediately without reconfiguring. A different `databaseDirectory` on a later call is **ignored** (the first directory wins).

### Default database directory

When `databaseDirectory` is omitted, `ensureInitialized()` uses `getApplicationSupportDirectory()` from `path_provider`. The copied `rawi.db` persists across app restarts.

Pass a custom writable directory when you need a different location:

```dart
await DorarHadithFlutter.ensureInitialized(
  databaseDirectory: myWritableDirectory,
);
```

### Asset keys

`FlutterAssetLoader` resolves service paths to Flutter asset bundle keys:

| Service default path | Bundle key used |
|---|---|
| `assets/data/book.json` | `packages/dorar_hadith/assets/data/book.json` |
| `assets/data/mohdith.json` | `packages/dorar_hadith/assets/data/mohdith.json` |
| (database copy source) | `packages/dorar_hadith/assets/database/rawi.db` |

Paths that already start with `packages/` are passed through unchanged. Provide a custom `keyResolver` to `configureFlutterAssetLoader` when your asset layout differs.

## Failure modes

| Situation | What happens |
|---|---|
| Offline APIs used **before** `ensureInitialized()` | `BookReferenceService` / `MohdithReferenceService`: `AssetLoaderException` (`Asset file not found…`) because the core package's `FileAssetLoader` cannot read Flutter bundles. `RawiReferenceService`: `Exception` (`Database file not found…`) from the default CLI connection factory. |
| Missing bundled asset at runtime | `FlutterError` from `rootBundle` (typically `Unable to load asset: packages/dorar_hadith/…`). Not wrapped as `AssetLoaderException`. |
| `ensureInitialized()` called twice | No error; second call is a no-op. |
| `databaseDirectory` not writable | Platform `File` I/O error when copying `rawi.db` (not a library-specific exception). |
| Invalid JSON in bundled files | `FormatException` from `json.decode` after a successful asset load. |

Network/API errors (`DorarException` hierarchy) are unchanged and documented in the [core README](../README.md).

## Advanced customization

For manual control without `ensureInitialized()`, the package re-exports:

- **`configureFlutterAssetLoader`** — set `bundleLoader` (typically `rootBundle.loadString`) and optional `keyResolver`.
- **`createFlutterConnectionFactory`** — copy-on-first-open database wiring with `loadDatabaseBytes`, optional `targetDirectory`, and `databaseFileName`.

If `targetDirectory` is omitted in `createFlutterConnectionFactory`, the database is copied into a **system temp** directory (not persistent across restarts). `ensureInitialized()` always prefers the application support directory unless you override `databaseDirectory`.

Example (manual setup equivalent to `ensureInitialized()`):

```dart
import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final supportDir = await getApplicationSupportDirectory();

configureFlutterAssetLoader(bundleLoader: rootBundle.loadString);

RawiDatabase.configureConnection(
  createFlutterConnectionFactory(
    targetDirectory: supportDir,
    loadDatabaseBytes: () async {
      final data = await rootBundle.load(
        'packages/dorar_hadith/assets/database/rawi.db',
      );
      return data.buffer.asUint8List();
    },
  ),
);
```

## API usage

After initialization, use `dorar_hadith` APIs as documented in the [core README](../README.md):

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

final client = DorarClient();
final books = await client.searchBooks('صحيح');
await client.dispose();
```
