import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:dorar_hadith_flutter/dorar_hadith_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

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

  test('ensureInitialized loads bundled reference data and configures cache', () async {
    await DorarHadithFlutter.ensureInitialized(databaseDirectory: tempDir);

    expect(DorarHadithFlutter.isInitialized, isTrue);

    final service = BookReferenceService();
    await service.initialize();

    final count = await service.countBooks();
    expect(count, greaterThan(0));

    final rawi = RawiReferenceService();
    addTearDown(rawi.dispose);
    final rawiCount = await rawi.countRawi();
    expect(rawiCount, greaterThan(0));

    final rawiFile = File(p.join(tempDir.path, 'rawi.db'));
    expect(await rawiFile.exists(), isTrue);

    final cacheDb = CacheDatabase();
    addTearDown(cacheDb.close);
    await cacheDb.insertOrUpdateCacheEntry(
      CacheTableCompanion.insert(
        key: 'test-key',
        body: 'body',
        header: 'header',
        expiredAt: DateTime.now().add(const Duration(days: 1)),
      ),
    );

    final cacheFile = File(p.join(tempDir.path, 'cache.db'));
    expect(await cacheFile.exists(), isTrue);
    expect(p.dirname(cacheFile.path), p.dirname(rawiFile.path));
    expect(p.basename(cacheFile.path), 'cache.db');
  });
}
