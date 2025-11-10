import 'package:dorar_hadith/src/models/mohdith_item.dart';
import 'package:test/test.dart';

void main() {
  group('MohdithItem - Construction', () {
    test('should create MohdithItem with id and name', () {
      final mohdith = MohdithItem(id: '1', name: 'البخاري');

      expect(mohdith.id, equals('1'));
      expect(mohdith.name, equals('البخاري'));
    });

    test('should create MohdithItem with Arabic names', () {
      final scholars = [
        MohdithItem(id: '1', name: 'البخاري'),
        MohdithItem(id: '2', name: 'مسلم'),
        MohdithItem(id: '3', name: 'أبو داود'),
        MohdithItem(id: '4', name: 'الترمذي'),
        MohdithItem(id: '5', name: 'النسائي'),
        MohdithItem(id: '6', name: 'ابن ماجه'),
        MohdithItem(id: '7', name: 'أحمد بن حنبل'),
        MohdithItem(id: '8', name: 'مالك بن أنس'),
      ];

      expect(scholars.length, equals(8));
      expect(scholars.every((s) => s.id.isNotEmpty), isTrue);
      expect(scholars.every((s) => s.name.isNotEmpty), isTrue);
    });
  });

  group('MohdithItem - JSON Serialization', () {
    test('should create from JSON (key/value format)', () {
      final json = {'key': '123', 'value': 'البخاري'};
      final mohdith = MohdithItem.fromJson(json);

      expect(mohdith.id, equals('123'));
      expect(mohdith.name, equals('البخاري'));
      expect(mohdith.deathYear, isNull);
      expect(mohdith.era, isNull);
    });

    test('should create from JSON with optional fields', () {
      final json = {
        'key': '256',
        'value': 'البخاري',
        'deathYear': 256,
        'era': 'Classical',
      };
      final mohdith = MohdithItem.fromJson(json);

      expect(mohdith.id, equals('256'));
      expect(mohdith.name, equals('البخاري'));
      expect(mohdith.deathYear, equals(256));
      expect(mohdith.era, equals('Classical'));
    });

    test('should convert to JSON', () {
      final mohdith = MohdithItem(id: '456', name: 'مسلم', deathYear: 261);
      final json = mohdith.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['key'], equals('456'));
      expect(json['value'], equals('مسلم'));
      expect(json['deathYear'], equals(261));
    });

    test('should round-trip through JSON', () {
      final original = MohdithItem(
        id: '789',
        name: 'أحمد بن حنبل',
        deathYear: 241,
        era: 'Classical',
      );
      final json = original.toJson();
      final restored = MohdithItem.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.deathYear, equals(original.deathYear));
      expect(restored.era, equals(original.era));
    });

    test('should handle long Arabic names', () {
      final json = {
        'key': '100',
        'value': 'الإمام أبو عبد الله محمد بن إسماعيل البخاري',
      };
      final mohdith = MohdithItem.fromJson(json);

      expect(mohdith.id, equals('100'));
      expect(mohdith.name, contains('البخاري'));
      expect(mohdith.name.length, greaterThan(10));
    });

    test('should handle names with special characters', () {
      final json = {'key': '200', 'value': 'الإمام مالك بن أنس الأصبحي'};
      final mohdith = MohdithItem.fromJson(json);

      expect(mohdith.id, equals('200'));
      expect(mohdith.name, equals('الإمام مالك بن أنس الأصبحي'));
    });
  });

  group('MohdithItem - Equality', () {
    test('should be equal when id matches (name can differ)', () {
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(id: '1', name: 'البخاري');

      expect(mohdith1, equals(mohdith2));
      expect(mohdith1.hashCode, equals(mohdith2.hashCode));
    });

    test('should not be equal when id differs', () {
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(id: '2', name: 'البخاري');

      expect(mohdith1, isNot(equals(mohdith2)));
    });

    test('equality is based on id only, not name', () {
      // ReferenceItem equality is based on runtimeType + id only
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(
        id: '1',
        name: 'مسلم',
      ); // different name, same id

      expect(mohdith1, equals(mohdith2)); // Should be equal (same id)
    });

    test('should work correctly in Sets', () {
      final set = <MohdithItem>{};

      set.add(MohdithItem(id: '1', name: 'البخاري'));
      set.add(MohdithItem(id: '1', name: 'البخاري')); // Duplicate
      set.add(MohdithItem(id: '2', name: 'مسلم'));

      expect(set.length, equals(2)); // Duplicate should not be added
    });

    test('should work correctly in Maps', () {
      final map = <MohdithItem, String>{};

      final key1 = MohdithItem(id: '1', name: 'البخاري');
      final key2 = MohdithItem(id: '1', name: 'البخاري'); // Same as key1

      map[key1] = 'First';
      map[key2] = 'Second'; // Should overwrite

      expect(map.length, equals(1));
      expect(map[key1], equals('Second'));
    });
  });

  group('MohdithItem - Edge Cases', () {
    test('should handle empty id', () {
      final mohdith = MohdithItem(id: '', name: 'البخاري');

      expect(mohdith.id, isEmpty);
      expect(mohdith.name, equals('البخاري'));
    });

    test('should handle empty name', () {
      final mohdith = MohdithItem(id: '123', name: '');

      expect(mohdith.id, equals('123'));
      expect(mohdith.name, isEmpty);
    });

    test('should handle numeric IDs as strings', () {
      final json = {'key': '12345', 'value': 'الترمذي'};
      final mohdith = MohdithItem.fromJson(json);

      expect(mohdith.id, equals('12345'));
      expect(mohdith.name, equals('الترمذي'));
    });

    test('should handle whitespace in names', () {
      final json = {'key': '1', 'value': '  البخاري  '};
      final mohdith = MohdithItem.fromJson(json);

      // Note: We're not trimming whitespace, so it should be preserved
      expect(mohdith.name, equals('  البخاري  '));
    });
  });

  group('MohdithItem - toString', () {
    test('should return useful string representation', () {
      final mohdith = MohdithItem(id: '123', name: 'البخاري');
      final str = mohdith.toString();

      expect(str, contains('MohdithItem'));
      expect(str, contains('123'));
      expect(str, contains('البخاري'));
    });

    test('should be useful for debugging', () {
      final mohdith = MohdithItem(
        id: '999',
        name: 'الإمام أبو عبد الله محمد بن إسماعيل البخاري',
      );
      final str = mohdith.toString();

      expect(str, contains('id'));
      expect(str, contains('name'));
      expect(str, contains('999'));
    });
  });
}
