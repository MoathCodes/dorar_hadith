import 'package:dorar_hadith/src/models/rawi_item.dart';
import 'package:test/test.dart';

void main() {
  group('RawiItem - Construction', () {
    test('should create RawiItem with id and name', () {
      final rawi = RawiItem(id: '1', name: 'عبد الله بن عمر');

      expect(rawi.id, equals('1'));
      expect(rawi.name, equals('عبد الله بن عمر'));
    });

    test('should create RawiItem with various narrator names', () {
      final narrators = [
        RawiItem(id: '1', name: 'عبد الله بن عمر'),
        RawiItem(id: '2', name: 'أبو هريرة'),
        RawiItem(id: '3', name: 'عائشة بنت أبي بكر'),
        RawiItem(id: '4', name: 'أنس بن مالك'),
        RawiItem(id: '5', name: 'جابر بن عبد الله'),
      ];

      expect(narrators.length, equals(5));
      expect(narrators.every((n) => n.id.isNotEmpty), isTrue);
      expect(narrators.every((n) => n.name.isNotEmpty), isTrue);
    });
  });

  group('RawiItem - JSON Serialization', () {
    test('should create from JSON (key/value format)', () {
      final json = {'key': '123', 'value': 'عبد الله بن عمر'};
      final rawi = RawiItem.fromJson(json);

      expect(rawi.id, equals('123'));
      expect(rawi.name, equals('عبد الله بن عمر'));
    });

    test('should handle long narrator names', () {
      final json = {
        'key': '1000',
        'value': 'أبو عبد الرحمن عبد الله بن عمر بن الخطاب القرشي العدوي',
      };
      final rawi = RawiItem.fromJson(json);

      expect(rawi.id, equals('1000'));
      expect(rawi.name.length, greaterThan(20));
      expect(rawi.name, contains('عبد الله'));
    });

    test('should handle narrator names with "بن" (ibn)', () {
      final json = {'key': '2000', 'value': 'محمد بن علي بن الحسين'};
      final rawi = RawiItem.fromJson(json);

      expect(rawi.id, equals('2000'));
      expect(rawi.name, contains('بن'));
    });

    test('should handle narrator names with "بنت" (bint)', () {
      final json = {'key': '3000', 'value': 'فاطمة بنت محمد'};
      final rawi = RawiItem.fromJson(json);

      expect(rawi.id, equals('3000'));
      expect(rawi.name, contains('بنت'));
    });
  });

  group('RawiItem - fromDatabase Constructor', () {
    test('should create from database row data (key/value)', () {
      // Drift stores: key (int) → value (String)
      final rawi = RawiItem.fromDatabase(key: 999, value: 'جابر بن عبد الله');

      expect(rawi.id, equals('999')); // int converted to String
      expect(rawi.name, equals('جابر بن عبد الله'));
    });

    test('should create from database with various field values', () {
      final narrators = [
        RawiItem.fromDatabase(key: 1, value: 'عبد الله بن عباس'),
        RawiItem.fromDatabase(key: 2, value: 'أبو سعيد الخدري'),
        RawiItem.fromDatabase(key: 3, value: 'عبد الله بن مسعود'),
      ];

      expect(narrators.length, equals(3));
      expect(narrators[0].id, equals('1'));
      expect(narrators[1].name, equals('أبو سعيد الخدري'));
    });

    test('should convert int key to String id', () {
      final rawi = RawiItem.fromDatabase(key: 12345, value: 'أنس بن مالك');

      expect(rawi.id, isA<String>());
      expect(rawi.id, equals('12345'));
    });
  });

  group('RawiItem - Equality', () {
    test('should be equal when id and name match', () {
      final rawi1 = RawiItem(id: '1', name: 'عبد الله بن عمر');
      final rawi2 = RawiItem(id: '1', name: 'عبد الله بن عمر');

      expect(rawi1, equals(rawi2));
      expect(rawi1.hashCode, equals(rawi2.hashCode));
    });

    test('should not be equal when id differs', () {
      final rawi1 = RawiItem(id: '1', name: 'عبد الله بن عمر');
      final rawi2 = RawiItem(id: '2', name: 'عبد الله بن عمر');

      expect(rawi1, isNot(equals(rawi2)));
    });

    test('equality is based on id only, not name', () {
      // ReferenceItem equality is based on runtimeType + id only
      final rawi1 = RawiItem(id: '1', name: 'عبد الله بن عمر');
      final rawi2 = RawiItem(
        id: '1',
        name: 'أبو هريرة',
      ); // different name, same id

      expect(rawi1, equals(rawi2)); // Should be equal (same id)
    });

    test('should work correctly in Sets', () {
      final set = <RawiItem>{};

      set.add(RawiItem(id: '1', name: 'عبد الله بن عمر'));
      set.add(RawiItem(id: '1', name: 'عبد الله بن عمر')); // Duplicate
      set.add(RawiItem(id: '2', name: 'أبو هريرة'));

      expect(set.length, equals(2)); // Duplicate should not be added
    });

    test('should work correctly in Maps', () {
      final map = <RawiItem, String>{};

      final key1 = RawiItem(id: '1', name: 'عبد الله بن عمر');
      final key2 = RawiItem(id: '1', name: 'عبد الله بن عمر'); // Same as key1

      map[key1] = 'First';
      map[key2] = 'Second'; // Should overwrite

      expect(map.length, equals(1));
      expect(map[key1], equals('Second'));
    });
  });

  group('RawiItem - Drift Integration', () {
    test('fromJson and fromDatabase should create equivalent objects', () {
      final json = {'key': '100', 'value': 'أنس بن مالك'};

      final fromJson = RawiItem.fromJson(json);
      final fromDb = RawiItem.fromDatabase(key: 100, value: 'أنس بن مالك');

      expect(fromJson, equals(fromDb));
      expect(fromJson.id, equals(fromDb.id));
      expect(fromJson.name, equals(fromDb.name));
    });

    test('should be usable as Drift row class', () {
      // This tests that RawiItem can serve dual purpose:
      // 1. As a model for JSON serialization
      // 2. As a Drift row class for database

      final rawi = RawiItem.fromDatabase(key: 500, value: 'سعد بن أبي وقاص');

      expect(rawi, isA<RawiItem>());
      expect(rawi.id, equals('500'));
      expect(rawi.name, equals('سعد بن أبي وقاص'));
    });
  });

  group('RawiItem - Edge Cases', () {
    test('should handle empty id', () {
      final rawi = RawiItem(id: '', name: 'عبد الله بن عمر');

      expect(rawi.id, isEmpty);
      expect(rawi.name, equals('عبد الله بن عمر'));
    });

    test('should handle empty name', () {
      final rawi = RawiItem(id: '123', name: '');

      expect(rawi.id, equals('123'));
      expect(rawi.name, isEmpty);
    });

    test('should handle numeric IDs in JSON (key as string)', () {
      final json = {'key': '12345', 'value': 'طلحة بن عبيد الله'};
      final rawi = RawiItem.fromJson(json);

      expect(rawi.id, equals('12345'));
      expect(rawi.name, equals('طلحة بن عبيد الله'));
    });

    test('should handle whitespace in names', () {
      final json = {'key': '1', 'value': '  عبد الله بن عمر  '};
      final rawi = RawiItem.fromJson(json);

      // Note: We're not trimming whitespace, so it should be preserved
      expect(rawi.name, equals('  عبد الله بن عمر  '));
    });

    test('should handle names with special Arabic characters', () {
      final json = {'key': '999', 'value': 'أبو هُرَيْرَة الدَّوْسِي'};
      final rawi = RawiItem.fromJson(json);

      expect(rawi.name, contains('هُرَيْرَة'));
      expect(rawi.name, contains('الدَّوْسِي'));
    });
  });

  group('RawiItem - toString', () {
    test('should return useful string representation', () {
      final rawi = RawiItem(id: '123', name: 'عبد الله بن عمر');
      final str = rawi.toString();

      expect(str, contains('RawiItem'));
      expect(str, contains('123'));
      expect(str, contains('عبد الله بن عمر'));
    });

    test('should be useful for debugging', () {
      final rawi = RawiItem(
        id: '999',
        name: 'أبو عبد الرحمن عبد الله بن عمر بن الخطاب',
      );
      final str = rawi.toString();

      expect(str, contains('id'));
      expect(str, contains('name'));
      expect(str, contains('999'));
    });
  });

  group('RawiItem - Comparison with Real Data', () {
    test('should match structure of actual rawi.json data', () {
      // Simulating real data from data/rawi.json (key/value format)
      final realNarrators = [
        {'key': '1', 'value': 'عبد الله بن عمر'},
        {'key': '2', 'value': 'أبو هريرة'},
        {'key': '3', 'value': 'عائشة بنت أبي بكر'},
      ];

      final narrators = realNarrators
          .map((json) => RawiItem.fromJson(json))
          .toList();

      expect(narrators.length, equals(3));
      expect(narrators[0].id, equals('1'));
      expect(narrators[1].name, equals('أبو هريرة'));
      expect(narrators[2].name, contains('عائشة'));
    });
  });
}
