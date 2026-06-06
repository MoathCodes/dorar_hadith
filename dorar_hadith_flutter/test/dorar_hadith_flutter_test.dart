import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('dorar_hadith_flutter_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('ensureInitialized loads bundled reference data', () async {
    await DorarHadithFlutter.ensureInitialized(databaseDirectory: tempDir);

    expect(DorarHadithFlutter.isInitialized, isTrue);

    final service = BookReferenceService();
    await service.initialize();

    final count = await service.countBooks();
    expect(count, greaterThan(0));
  });
}
