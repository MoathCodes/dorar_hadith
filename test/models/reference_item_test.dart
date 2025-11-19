import 'package:dorar_hadith/src/models/book_item.dart';
import 'package:dorar_hadith/src/models/mohdith_item.dart';
import 'package:dorar_hadith/src/models/reference_item.dart';
import 'package:test/test.dart';

void main() {
  group('ReferenceItem inheritance', () {
    test('MohdithItem implements ReferenceItem', () {
      final mohdith = MohdithItem(id: '1', name: 'الإمام البخاري');

      expect(mohdith, isA<ReferenceItem>());
    });

    test('BookItem implements ReferenceItem', () {
      final book = BookItem(id: '100', name: 'صحيح البخاري');

      expect(book, isA<ReferenceItem>());
    });
  });

  group('ReferenceItem equality', () {
    test('items with same id and type are equal', () {
      final a = MohdithItem(id: '256', name: 'البخاري');
      final b = MohdithItem(id: '256', name: 'اسم مختلف');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('items with different ids are not equal', () {
      final a = BookItem(id: '6216', name: 'صحيح البخاري');
      final b = BookItem(id: '2582', name: 'صحيح مسلم');

      expect(a, isNot(equals(b)));
    });

    test('different ReferenceItem implementations are not equal', () {
      final mohdith = MohdithItem(id: '1', name: 'البخاري');
      final book = BookItem(id: '1', name: 'صحيح البخاري');

      expect(mohdith, isNot(equals(book)));
    });
  });
}
