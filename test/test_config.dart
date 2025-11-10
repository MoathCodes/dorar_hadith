import 'dart:async';

import 'package:drift/drift.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Ensure drift warnings about multiple database instantiations stay muted in tests.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await testMain();
}
