import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('FileAssetLoader', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('asset_loader_test');
      final sampleFile = File('${tempDir.path}/sample.json');
      await sampleFile.writeAsString('{"key":"value"}');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('loadString returns file contents', () async {
      final loader = FileAssetLoader(basePath: tempDir.path);
      final content = await loader.loadString('sample.json');

      expect(content, '{"key":"value"}');
    });

    test('throws AssetLoaderException when file missing', () async {
      final loader = FileAssetLoader(basePath: tempDir.path);

      expect(
        () => loader.loadString('missing.json'),
        throwsA(isA<AssetLoaderException>()),
      );
    });
  });

  group('AssetLoader factory', () {
    test('returns FileAssetLoader and can read bundled asset', () async {
      final loader = createAssetLoader();

      expect(loader, isA<FileAssetLoader>());
      final content = await loader.loadString('assets/data/mohdith.json');
      expect(content, contains('الجميع'));
    });
  });
}
