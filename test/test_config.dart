import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dorar_hadith/src/database/cache_database.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Ensure drift warnings about multiple database instantiations stay muted in tests.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  CacheDatabase.configureConnection(
    () => DatabaseConnection(NativeDatabase.memory()),
  );
  await testMain();
}
