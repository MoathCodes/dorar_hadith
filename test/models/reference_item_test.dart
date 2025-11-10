import 'package:dorar_hadith/src/models/book_item.dart';
import 'package:dorar_hadith/src/models/mohdith_item.dart';
import 'package:dorar_hadith/src/models/reference_item.dart';
import 'package:test/test.dart';

void main() {
  group('ReferenceItem - Abstract Class Contract', () {
    test('MohdithItem implements ReferenceItem', () {
      final mohdith = MohdithItem(id: '1', name: 'البخاري');
      expect(mohdith, isA<ReferenceItem>());
    });

    test('BookItem implements ReferenceItem', () {
      final book = BookItem(id: '100', name: 'صحيح البخاري');
      expect(book, isA<ReferenceItem>());
    });

    test('ReferenceItem requires id and name', () {
      final mohdith = MohdithItem(id: '123', name: 'مالك');
      expect(mohdith.id, equals('123'));
      expect(mohdith.name, equals('مالك'));
    });
  });

  group('ReferenceItem - Equality', () {
    test('MohdithItem with same id are equal (equality based on id only)', () {
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(id: '1', name: 'البخاري');

      expect(mohdith1, equals(mohdith2));
      expect(mohdith1.hashCode, equals(mohdith2.hashCode));
    });

    test('MohdithItem with different id are not equal', () {
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(id: '2', name: 'البخاري');

      expect(mohdith1, isNot(equals(mohdith2)));
    });

    test('MohdithItem equality ignores name (only id matters)', () {
      final mohdith1 = MohdithItem(id: '1', name: 'البخاري');
      final mohdith2 = MohdithItem(id: '1', name: 'مسلم'); // different name

      // Equality is based on runtimeType + id only, not name
      expect(mohdith1, equals(mohdith2));
    });

    test('BookItem with same id and name are equal', () {
      final book1 = BookItem(id: '100', name: 'صحيح البخاري');
      final book2 = BookItem(id: '100', name: 'صحيح البخاري');

      expect(book1, equals(book2));
      expect(book1.hashCode, equals(book2.hashCode));
    });

    test('BookItem with different id are not equal', () {
      final book1 = BookItem(id: '100', name: 'صحيح البخاري');
      final book2 = BookItem(id: '200', name: 'صحيح البخاري');

      expect(book1, isNot(equals(book2)));
    });
  });

  group('ReferenceItem - Type Safety', () {
    test('cannot compare MohdithItem with BookItem', () {
      final mohdith = MohdithItem(id: '1', name: 'البخاري');
      final book = BookItem(id: '1', name: 'البخاري');

      // Even with same id and name, different types are not equal
      expect(mohdith, isNot(equals(book)));
    });

    test('ReferenceItem list can hold different implementations', () {
      final List<ReferenceItem> items = [
        MohdithItem(id: '1', name: 'البخاري'),
        BookItem(id: '100', name: 'صحيح البخاري'),
        MohdithItem(id: '2', name: 'مسلم'),
      ];

      expect(items.length, equals(3));
      expect(items[0], isA<MohdithItem>());
      expect(items[1], isA<BookItem>());
      expect(items[2], isA<MohdithItem>());
    });
  });

  group('ReferenceItem - toString', () {
    test('MohdithItem toString returns useful representation', () {
      final mohdith = MohdithItem(id: '1', name: 'البخاري');
      final str = mohdith.toString();

      expect(str, contains('MohdithItem'));
      expect(str, contains('1'));
      expect(str, contains('البخاري'));
    });

    test('BookItem toString returns useful representation', () {
      final book = BookItem(id: '100', name: 'صحيح البخاري');
      final str = book.toString();

      expect(str, contains('BookItem'));
      expect(str, contains('100'));
      expect(str, contains('صحيح البخاري'));
    });
  });
}
