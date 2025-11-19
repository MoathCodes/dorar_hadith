import 'package:dorar_hadith/src/models/book_item.dart';
import 'package:test/test.dart';

void main() {
  group('BookItem', () {
    test('constructs with minimal fields', () {
      final book = BookItem(id: '6216', name: 'صحيح البخاري');

      expect(book.id, '6216');
      expect(book.name, 'صحيح البخاري');
      expect(book.author, isNull);
      expect(book.mohdithId, isNull);
      expect(book.category, isNull);
    });

    test('fromJson reads optional fields when provided', () {
      final book = BookItem.fromJson({
        'key': '2582',
        'value': 'صحيح مسلم',
        'author': 'مسلم بن الحجاج',
        'mohdithId': '256',
        'category': 'Sahih',
      });

      expect(book.id, '2582');
      expect(book.name, 'صحيح مسلم');
      expect(book.author, 'مسلم بن الحجاج');
      expect(book.mohdithId, '256');
      expect(book.category, 'Sahih');
    });

    test('toJson emits expected structure', () {
      final book = BookItem(
        id: '8191',
        name: 'موطأ مالك',
        author: 'مالك بن أنس',
        mohdithId: '400',
        category: 'Hadith',
      );

      final json = book.toJson();

      expect(json['key'], '8191');
      expect(json['value'], 'موطأ مالك');
      expect(json['author'], 'مالك بن أنس');
      expect(json['mohdithId'], '400');
      expect(json['category'], 'Hadith');
    });

    test('round-trip serialization preserves data', () {
      final original = BookItem(
        id: '700',
        name: 'مسند أحمد',
        author: 'أحمد بن حنبل',
        mohdithId: '999',
        category: 'Musnad',
      );

      final restored = BookItem.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.author, original.author);
      expect(restored.mohdithId, original.mohdithId);
      expect(restored.category, original.category);
    });

    group('equality', () {
      test('books with same id are equal regardless of other fields', () {
        final a = BookItem(id: '100', name: 'صحيح البخاري');
        final b = BookItem(id: '100', name: 'Different title');

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('books with different ids are not equal', () {
        final a = BookItem(id: '100', name: 'صحيح البخاري');
        final b = BookItem(id: '200', name: 'صحيح البخاري');

        expect(a, isNot(equals(b)));
      });
    });
  });
}
