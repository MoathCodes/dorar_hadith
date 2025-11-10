import 'package:dorar_hadith/src/models/book_item.dart';
import 'package:test/test.dart';

void main() {
  group('BookItem - Construction', () {
    test('should create BookItem with id and name', () {
      final book = BookItem(id: '100', name: 'صحيح البخاري');

      expect(book.id, equals('100'));
      expect(book.name, equals('صحيح البخاري'));
    });

    test('should create BookItem with various Arabic book names', () {
      final books = [
        BookItem(id: '100', name: 'صحيح البخاري'),
        BookItem(id: '200', name: 'صحيح مسلم'),
        BookItem(id: '300', name: 'سنن أبي داود'),
        BookItem(id: '400', name: 'جامع الترمذي'),
        BookItem(id: '500', name: 'سنن النسائي'),
        BookItem(id: '600', name: 'سنن ابن ماجه'),
        BookItem(id: '700', name: 'مسند أحمد'),
        BookItem(id: '800', name: 'موطأ مالك'),
      ];

      expect(books.length, equals(8));
      expect(books.every((b) => b.id.isNotEmpty), isTrue);
      expect(books.every((b) => b.name.isNotEmpty), isTrue);
    });
  });

  group('BookItem - JSON Serialization', () {
    test('should create from JSON (key/value format)', () {
      final json = {'key': '6216', 'value': 'صحيح البخاري'};
      final book = BookItem.fromJson(json);

      expect(book.id, equals('6216'));
      expect(book.name, equals('صحيح البخاري'));
      expect(book.author, isNull);
      expect(book.mohdithId, isNull);
      expect(book.category, isNull);
    });

    test('should create from JSON with optional fields', () {
      final json = {
        'key': '6216',
        'value': 'صحيح البخاري',
        'author': 'البخاري',
        'mohdithId': '256',
        'category': 'Sahih',
      };
      final book = BookItem.fromJson(json);

      expect(book.id, equals('6216'));
      expect(book.name, equals('صحيح البخاري'));
      expect(book.author, equals('البخاري'));
      expect(book.mohdithId, equals('256'));
      expect(book.category, equals('Sahih'));
    });

    test('should convert to JSON', () {
      final book = BookItem(id: '2582', name: 'صحيح مسلم', author: 'مسلم');
      final json = book.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['key'], equals('2582'));
      expect(json['value'], equals('صحيح مسلم'));
      expect(json['author'], equals('مسلم'));
    });

    test('should round-trip through JSON', () {
      final original = BookItem(
        id: '8191',
        name: 'موطأ مالك',
        author: 'مالك بن أنس',
      );
      final json = original.toJson();
      final restored = BookItem.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.author, equals(original.author));
    });

    test('should handle long book titles', () {
      final json = {
        'key': '1000',
        'value':
            'الجامع المسند الصحيح المختصر من أمور رسول الله صلى الله عليه وسلم',
      };
      final book = BookItem.fromJson(json);

      expect(book.id, equals('1000'));
      expect(book.name.length, greaterThan(20));
      expect(book.name, contains('الجامع'));
    });

    test('should handle book titles with special characters', () {
      final json = {
        'key': '2000',
        'value': 'سنن الدارقطني - تحقيق شعيب الأرنؤوط',
      };
      final book = BookItem.fromJson(json);

      expect(book.id, equals('2000'));
      expect(book.name, contains('الدارقطني'));
      expect(book.name, contains('-'));
    });
  });

  group('BookItem - Equality', () {
    test('should be equal when id matches', () {
      final book1 = BookItem(id: '100', name: 'صحيح البخاري');
      final book2 = BookItem(id: '100', name: 'صحيح البخاري');

      expect(book1, equals(book2));
      expect(book1.hashCode, equals(book2.hashCode));
    });

    test('should not be equal when id differs', () {
      final book1 = BookItem(id: '100', name: 'صحيح البخاري');
      final book2 = BookItem(id: '200', name: 'صحيح البخاري');

      expect(book1, isNot(equals(book2)));
    });

    test('equality is based on id only, not name', () {
      // ReferenceItem equality is based on runtimeType + id only
      final book1 = BookItem(id: '100', name: 'صحيح البخاري');
      final book2 = BookItem(
        id: '100',
        name: 'صحيح مسلم',
      ); // different name, same id

      expect(book1, equals(book2)); // Should be equal (same id)
    });

    test('should work correctly in Sets', () {
      final set = <BookItem>{};

      set.add(BookItem(id: '100', name: 'صحيح البخاري'));
      set.add(BookItem(id: '100', name: 'صحيح البخاري')); // Duplicate
      set.add(BookItem(id: '200', name: 'صحيح مسلم'));

      expect(set.length, equals(2)); // Duplicate should not be added
    });

    test('should work correctly in Maps', () {
      final map = <BookItem, String>{};

      final key1 = BookItem(id: '100', name: 'صحيح البخاري');
      final key2 = BookItem(id: '100', name: 'صحيح البخاري'); // Same as key1

      map[key1] = 'First';
      map[key2] = 'Second'; // Should overwrite

      expect(map.length, equals(1));
      expect(map[key1], equals('Second'));
    });
  });

  group('BookItem - Edge Cases', () {
    test('should handle empty id', () {
      final book = BookItem(id: '', name: 'صحيح البخاري');

      expect(book.id, isEmpty);
      expect(book.name, equals('صحيح البخاري'));
    });

    test('should handle empty name', () {
      final book = BookItem(id: '123', name: '');

      expect(book.id, equals('123'));
      expect(book.name, isEmpty);
    });

    test('should handle numeric IDs in JSON (key as string)', () {
      final json = {'key': '12345', 'value': 'سنن الترمذي'};
      final book = BookItem.fromJson(json);

      expect(book.id, equals('12345'));
      expect(book.name, equals('سنن الترمذي'));
    });

    test('should handle whitespace in names', () {
      final json = {'key': '1', 'value': '  صحيح البخاري  '};
      final book = BookItem.fromJson(json);

      // Note: We're not trimming whitespace, so it should be preserved
      expect(book.name, equals('  صحيح البخاري  '));
    });

    test('should handle books with numbers in name', () {
      final json = {'key': '999', 'value': 'صحيح البخاري - الطبعة الثالثة'};
      final book = BookItem.fromJson(json);

      expect(book.name, contains('الثالثة'));
    });
  });

  group('BookItem - toString', () {
    test('should return useful string representation', () {
      final book = BookItem(id: '6216', name: 'صحيح البخاري');
      final str = book.toString();

      expect(str, contains('BookItem'));
      expect(str, contains('6216'));
      expect(str, contains('صحيح البخاري'));
    });

    test('should be useful for debugging', () {
      final book = BookItem(
        id: '2582',
        name: 'المسند الصحيح المختصر بنقل العدل عن العدل',
      );
      final str = book.toString();

      expect(str, contains('id'));
      expect(str, contains('name'));
      expect(str, contains('2582'));
    });
  });

  group('BookItem - Comparison with Real Data', () {
    test('should match structure of actual book.json data', () {
      // Simulating real data from data/book.json (key/value format)
      final realBooks = [
        {'key': '6216', 'value': 'صحيح البخاري'},
        {'key': '2582', 'value': 'صحيح مسلم'},
        {'key': '8191', 'value': 'موطأ مالك'},
      ];

      final books = realBooks.map((json) => BookItem.fromJson(json)).toList();

      expect(books.length, equals(3));
      expect(books[0].id, equals('6216'));
      expect(books[1].id, equals('2582'));
      expect(books[2].id, equals('8191'));
    });
  });
}
