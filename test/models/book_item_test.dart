import 'package:dorar_hadith/src/models/book_item.dart';
import 'package:test/test.dart';

void main() {
  group('BookItem', () {
    test('constructs with id and name', () {
      final book = BookItem(id: '6216', name: 'صحيح البخاري');

      expect(book.id, '6216');
      expect(book.name, 'صحيح البخاري');
    });

    test('fromJson reads key/value', () {
      final book = BookItem.fromJson({
        'key': '2582',
        'value': 'صحيح مسلم',
      });

      expect(book.id, '2582');
      expect(book.name, 'صحيح مسلم');
    });

    test('toJson emits expected structure', () {
      final book = BookItem(id: '11155', name: 'رياض الصالحين');

      final json = book.toJson();

      expect(json['key'], '11155');
      expect(json['value'], 'رياض الصالحين');
    });

    test('round-trip serialization preserves data', () {
      final original = BookItem(id: '13509', name: 'سنن الترمذي');

      final restored = BookItem.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
    });

    group('equality', () {
      test('books with same id and name are equal', () {
        final a = BookItem(id: '100', name: 'صحيح البخاري');
        final b = BookItem(id: '100', name: 'صحيح البخاري');

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('books with different ids are not equal', () {
        final a = BookItem(id: '100', name: 'صحيح البخاري');
        final b = BookItem(id: '200', name: 'صحيح البخاري');

        expect(a, isNot(equals(b)));
      });

      test('books with same id but different names are not equal', () {
        final a = BookItem(id: '100', name: 'صحيح البخاري');
        final b = BookItem(id: '100', name: 'Different title');

        expect(a, isNot(equals(b)));
      });
    });
  });
}
