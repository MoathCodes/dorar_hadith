import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('ApiResponse', () {
    test('should create ApiResponse with data and metadata', () {
      const metadata = SearchMetadata(length: 3, page: 1, isCached: false);

      final response = ApiResponse<List<String>>(
        data: ['item1', 'item2', 'item3'],
        metadata: metadata,
      );

      expect(response.data, hasLength(3));
      expect(response.data, contains('item1'));
      expect(response.metadata.page, equals(1));
      expect(response.metadata.length, equals(3));
    });

    test('should deserialize from JSON with simple data', () {
      final json = {
        'data': 'test value',
        'metadata': {
          'length': 1,
          'page': 2,
          'removeHTML': true,
          'isCached': false,
        },
      };

      final response = ApiResponse<String>.fromJson(
        json,
        (data) => data as String,
      );

      expect(response.data, equals('test value'));
      expect(response.metadata.page, equals(2));
      expect(response.metadata.length, equals(1));
      expect(response.metadata.removeHtml, isTrue);
    });

    test('should deserialize from JSON with list data', () {
      final json = {
        'data': ['a', 'b', 'c'],
        'metadata': {'length': 3, 'page': 1, 'isCached': false},
      };

      final response = ApiResponse<List<String>>.fromJson(
        json,
        (data) => (data as List).map((e) => e as String).toList(),
      );

      expect(response.data, hasLength(3));
      expect(response.data, equals(['a', 'b', 'c']));
      expect(response.metadata.isCached, isFalse);
    });

    test('should deserialize from JSON with complex object data', () {
      final json = {
        'data': [
          {
            'hadith': 'Test hadith',
            'rawi': 'Test rawi',
            'mohdith': 'Test mohdith',
            'book': 'Test book',
            'numberOrPage': '1',
            'grade': 'صحيح',
          },
        ],
        'metadata': {
          'length': 1,
          'page': 1,
          'specialist': false,
          'numberOfNonSpecialist': 1,
          'numberOfSpecialist': 0,
          'isCached': false,
        },
      };

      final response = ApiResponse<List<Hadith>>.fromJson(
        json,
        (data) => (data as List).map((e) => Hadith.fromJson(e)).toList(),
      );

      expect(response.data, hasLength(1));
      expect(response.data[0].hadith, equals('Test hadith'));
      expect(response.metadata.length, equals(1));
      expect(response.metadata.numberOfNonSpecialist, equals(1));
    });

    test('should serialize to JSON correctly', () {
      const metadata = SearchMetadata(
        length: 1,
        page: 3,
        specialist: true,
        isCached: false,
      );

      final response = ApiResponse<String>(
        data: 'test data',
        metadata: metadata,
      );

      final json = response.toJson((data) => data);

      expect(json['data'], equals('test data'));
      expect(json['metadata'], isA<Map<String, dynamic>>());
      expect(json['metadata']['length'], equals(1));
      expect(json['metadata']['page'], equals(3));
    });

    test('should serialize list data to JSON correctly', () {
      const metadata = SearchMetadata(length: 5, page: 1, isCached: false);

      final response = ApiResponse<List<int>>(
        data: [1, 2, 3, 4, 5],
        metadata: metadata,
      );

      final json = response.toJson((data) => data);

      expect(json['data'], equals([1, 2, 3, 4, 5]));
      expect(json['metadata']['length'], equals(5));
    });

    test('should round-trip through JSON', () {
      const metadata = SearchMetadata(
        length: 1,
        page: 2,
        removeHtml: true,
        specialist: false,
        isCached: false,
      );

      final original = ApiResponse<Map<String, dynamic>>(
        data: {'key': 'value', 'number': 42},
        metadata: metadata,
      );

      final json = original.toJson((data) => data);
      final restored = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(restored.data['key'], equals('value'));
      expect(restored.data['number'], equals(42));
      expect(restored.metadata.page, equals(2));
      expect(restored.metadata.length, equals(1));
    });

    test('should have correct toString representation', () {
      const metadata = SearchMetadata(length: 1, page: 1, isCached: false);

      final response = ApiResponse<String>(data: 'test', metadata: metadata);

      final str = response.toString();
      expect(str, contains('ApiResponse'));
      expect(str, contains('test'));
    });

    test('should handle empty list data', () {
      const metadata = SearchMetadata(length: 0, page: 1, isCached: false);

      final response = ApiResponse<List<String>>(data: [], metadata: metadata);

      expect(response.data, isEmpty);
      expect(response.metadata.length, equals(0));
    });

    test('should handle null values in complex data', () {
      final json = {
        'data': {'optional': null, 'required': 'value'},
        'metadata': {'length': 1, 'page': 1, 'isCached': false},
      };

      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(response.data['optional'], isNull);
      expect(response.data['required'], equals('value'));
    });

    test('should work with different generic types', () {
      const metadata = SearchMetadata(length: 1, page: 1, isCached: false);

      // String type
      final stringResponse = ApiResponse<String>(
        data: 'test',
        metadata: metadata,
      );
      expect(stringResponse.data, isA<String>());

      // int type
      final intResponse = ApiResponse<int>(data: 42, metadata: metadata);
      expect(intResponse.data, isA<int>());

      // List type
      final listResponse = ApiResponse<List<String>>(
        data: ['a', 'b'],
        metadata: metadata,
      );
      expect(listResponse.data, isA<List<String>>());

      // Map type
      final mapResponse = ApiResponse<Map<String, dynamic>>(
        data: {'key': 'value'},
        metadata: metadata,
      );
      expect(mapResponse.data, isA<Map<String, dynamic>>());
    });

    test('should handle cached responses', () {
      const metadata = SearchMetadata(length: 5, page: 1, isCached: true);

      final response = ApiResponse<List<int>>(
        data: [1, 2, 3, 4, 5],
        metadata: metadata,
      );

      expect(response.metadata.isCached, isTrue);
    });

    test('should handle specialist hadith metadata', () {
      const metadata = SearchMetadata(
        length: 10,
        page: 1,
        specialist: true,
        numberOfNonSpecialist: 7,
        numberOfSpecialist: 3,
        isCached: false,
      );

      final response = ApiResponse<List<String>>(
        data: List.generate(10, (i) => 'hadith $i'),
        metadata: metadata,
      );

      expect(response.metadata.specialist, isTrue);
      expect(response.metadata.numberOfNonSpecialist, equals(7));
      expect(response.metadata.numberOfSpecialist, equals(3));
    });

    test('should handle usul sources count', () {
      const metadata = SearchMetadata(
        length: 1,
        page: 1,
        usulSourcesCount: 5,
        isCached: false,
      );

      final response = ApiResponse<Map<String, dynamic>>(
        data: {'usul': 'data'},
        metadata: metadata,
      );

      expect(response.metadata.usulSourcesCount, equals(5));
    });
  });
}
