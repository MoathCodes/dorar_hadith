import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('ApiResponse serialization', () {
    test('fromJson parses payload and metadata fields', () {
      final json = {
        'data': [
          {'id': 1},
          {'id': 2},
        ],
        'metadata': {
          'length': 2,
          'page': 3,
          'removeHTML': true,
          'specialist': true,
          'numberOfSpecialist': 1,
          'numberOfNonSpecialist': 5,
          'usulSourcesCount': 7,
          'isCached': false,
        },
      };

      final response = ApiResponse<List<Map<String, dynamic>>>.fromJson(
        json,
        (payload) => (payload as List)
            .map((value) => value as Map<String, dynamic>)
            .toList(),
      );

      expect(response.data, [
        {'id': 1},
        {'id': 2},
      ]);
      expect(response.metadata.length, 2);
      expect(response.metadata.page, 3);
      expect(response.metadata.removeHtml, isTrue);
      expect(response.metadata.specialist, isTrue);
      expect(response.metadata.numberOfSpecialist, 1);
      expect(response.metadata.numberOfNonSpecialist, 5);
      expect(response.metadata.usulSourcesCount, 7);
      expect(response.metadata.isCached, isFalse);
    });

    test('toJson preserves metadata configuration', () {
      const metadata = SearchMetadata(
        length: 1,
        page: 10,
        removeHtml: false,
        specialist: false,
        numberOfSpecialist: 0,
        numberOfNonSpecialist: 0,
        usulSourcesCount: 0,
        isCached: true,
      );

      final response = ApiResponse<String>(data: 'sample', metadata: metadata);

      final json = response.toJson((value) => value);

      expect(json['data'], 'sample');
      expect(json['metadata'], isA<Map<String, dynamic>>());
      expect(json['metadata']['length'], 1);
      expect(json['metadata']['page'], 10);
      expect(json['metadata']['removeHTML'], false);
      expect(json['metadata']['isCached'], true);
    });

    test('round-trip maintains data shape and metadata flags', () {
      const metadata = SearchMetadata(
        length: 3,
        page: 2,
        removeHtml: true,
        specialist: true,
        numberOfSpecialist: 2,
        numberOfNonSpecialist: 1,
        usulSourcesCount: 4,
        isCached: false,
      );

      final original = ApiResponse<Map<String, dynamic>>(
        data: {'key': 'value', 'count': 42},
        metadata: metadata,
      );

      final json = original.toJson((value) => value);
      final restored = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (payload) => payload as Map<String, dynamic>,
      );

      expect(restored.data, {'key': 'value', 'count': 42});
      expect(restored.metadata.length, metadata.length);
      expect(restored.metadata.page, metadata.page);
      expect(restored.metadata.removeHtml, metadata.removeHtml);
      expect(restored.metadata.specialist, metadata.specialist);
      expect(restored.metadata.numberOfSpecialist, metadata.numberOfSpecialist);
      expect(
        restored.metadata.numberOfNonSpecialist,
        metadata.numberOfNonSpecialist,
      );
      expect(restored.metadata.usulSourcesCount, metadata.usulSourcesCount);
      expect(restored.metadata.isCached, metadata.isCached);
    });
  });
}
