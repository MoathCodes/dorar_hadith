# Dorar Hadith Flutter

[العربية](README_AR.md)

Flutter setup for `dorar_hadith`, with verified bundled references, native snapshot upgrades, persistent API cache and browser asset initialization.

## Contents

- [Setup](#setup)
- [Native storage and initialization](#storage)
- [Browser setup](#browser)
- [Custom storage](#custom)
- [Asset keys](#assets)
- [Upgrading from 0.5.x](#migration)

<a id="setup"></a>

## Setup

Install the adapter. Version 0.6.0 requires Dart 3.13.0 and Flutter 3.47.5 or later.

```sh
flutter pub add dorar_hadith_flutter
```

Initialize it before creating a Dorar client:

```dart
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DorarHadithFlutter.ensureInitialized();
  runApp(const MyApp());
}
```

The core dependency supplies JSON, database and manifest assets automatically. You do not need to declare them in your app. Initialization validates the bundled manifest and hashes offline before making the asset and database factories available.

<a id="storage"></a>

## Native storage and initialization

Native Flutter installs references atomically under a verified, snapshot-specific filename in application support storage and opens them read-only. The mutable API cache uses a separate `cache.db`. Upgrades preserve old `rawi.db`, old snapshots, cache, custom files and unrelated storage. Application favorites and history remain untouched.

```dart
await DorarHadithFlutter.ensureInitialized(databaseDirectory: myDirectory);
```

Concurrent calls with the same configuration share one future. Failed initialization can be retried and leaves `isInitialized` false. Changing the directory configuration raises `DorarFlutterAdapterException`. Its failure kinds distinguish missing assets, schema mismatch, integrity failure, installation failure and configuration conflict; `cause` retains the underlying error.

<a id="browser"></a>

## Browser setup

The browser entry point configures bundled JSON and the core WebAssembly databases. Omit `databaseDirectory` on web. Serve compatible `sqlite3.wasm` and `drift_worker.dart.js` at the application base URL. Reference storage identity includes snapshot version, schema and hash; API cache identity is separate.

The [example guide](example/README.md) explains worker and Wasm setup. Direct Dorar site and quick-API requests were blocked by CORS from the tested browser origin. For online access, inject an application-owned server transport through `DorarHttpClient(client: yourHttpClient)`. Offline asset initialization does not contact Dorar.

<a id="custom"></a>

## Custom storage

`createFlutterConnectionFactory` preserves ownership of custom filenames. Supply `manifest` for managed, verified installation under a versioned filename. Without a manifest, the caller manages the reference lifecycle. Existing custom files are never overwritten and must use schema 2. Use the core `migrateReferenceDatabase` helper to create and verify a separate schema-2 copy of a schema-1 input.

`createFlutterCacheConnectionFactory` opens a separate writable cache. `configureFlutterAssetLoader` supports custom JSON loading. `installManagedReferenceSnapshot` supports explicit managed native installation. Native file installation helpers are unavailable in browsers.

<a id="assets"></a>

## Asset keys

The core package supplies these bundle keys:

- `packages/dorar_hadith/assets/data/book.json`
- `packages/dorar_hadith/assets/data/mohdith.json`
- `packages/dorar_hadith/assets/data/reference_manifest.json`
- `packages/dorar_hadith/assets/database/rawi.db`

ByteData conversions preserve the returned view's offset and length. Bytes outside that view are excluded from database content.

<a id="migration"></a>

## Upgrading from 0.5.x

Read the [core migration guide](https://github.com/MoathCodes/dorar_hadith/blob/main/doc/MIGRATION_0_6_0.md) for structured explanation rendering, reviewed speaker attribution, filters, pagination, cache format 3 and saved JSON compatibility. The [release guide](https://github.com/MoathCodes/dorar_hadith/blob/main/doc/RELEASE_0_6_0.md) records publication checks. Tawaq application adoption is a separate task.
