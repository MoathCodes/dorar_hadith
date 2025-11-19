import 'package:dorar_hadith/src/models/rawi_item.dart';
import 'package:test/test.dart';

void main() {
  group('RawiItem hydration', () {
    test('fromJson reads key/value pairs', () {
      final rawi = RawiItem.fromJson({
        'key': '123',
        'value': 'عبد الله بن عمر',
      });

      expect(rawi.id, '123');
      expect(rawi.name, 'عبد الله بن عمر');
    });

    test('fromDatabase converts integer key to string id', () {
      final rawi = RawiItem.fromDatabase(key: 987, value: 'أبو هريرة');

      expect(rawi.id, '987');
      expect(rawi.name, 'أبو هريرة');
    });

    test('fromJson and fromDatabase stay consistent', () {
      const key = 555;
      const value = 'جابر بن عبد الله';

      final fromJson = RawiItem.fromJson({
        'key': key.toString(),
        'value': value,
      });
      final fromDb = RawiItem.fromDatabase(key: key, value: value);

      expect(fromJson, equals(fromDb));
      expect(fromJson.id, equals(fromDb.id));
      expect(fromJson.name, equals(fromDb.name));
    });
  });

  group('RawiItem equality', () {
    test('items with the same id are equal', () {
      final a = RawiItem(id: '42', name: 'أنس بن مالك');
      final b = RawiItem(id: '42', name: 'اسم مختلف');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('items with different ids are not equal', () {
      final a = RawiItem(id: '1', name: 'عبد الله بن عمر');
      final b = RawiItem(id: '2', name: 'عبد الله بن عمر');

      expect(a, isNot(equals(b)));
    });
  });
}
