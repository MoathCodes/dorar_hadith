import 'package:dorar_hadith/src/models/mohdith_item.dart';
import 'package:test/test.dart';

void main() {
  group('MohdithItem', () {
    test('constructs with minimal fields', () {
      final mohdith = MohdithItem(id: '256', name: 'الإمام البخاري');

      expect(mohdith.id, '256');
      expect(mohdith.name, 'الإمام البخاري');
      expect(mohdith.deathYear, isNull);
      expect(mohdith.era, isNull);
    });

    test('fromJson hydrates optional fields', () {
      final mohdith = MohdithItem.fromJson({
        'key': '400',
        'value': 'الإمام مسلم',
        'deathYear': 261,
        'era': 'Classical',
      });

      expect(mohdith.id, '400');
      expect(mohdith.name, 'الإمام مسلم');
      expect(mohdith.deathYear, 261);
      expect(mohdith.era, 'Classical');
    });

    test('toJson outputs expected structure', () {
      final json = MohdithItem(
        id: '512',
        name: 'الإمام النسائي',
        deathYear: 303,
        era: 'Late Classical',
      ).toJson();

      expect(json['key'], '512');
      expect(json['value'], 'الإمام النسائي');
      expect(json['deathYear'], 303);
      expect(json['era'], 'Late Classical');
    });

    test('round-trip serialization preserves values', () {
      final original = MohdithItem(
        id: '100',
        name: 'السيوطي',
        deathYear: 911,
        era: 'Post-Classical',
      );

      final restored = MohdithItem.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.deathYear, original.deathYear);
      expect(restored.era, original.era);
    });

    group('equality', () {
      test('items with same id are equal', () {
        final a = MohdithItem(id: '1', name: 'البخاري');
        final b = MohdithItem(id: '1', name: 'اسم مختلف');

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('items with different ids are not equal', () {
        final a = MohdithItem(id: '1', name: 'البخاري');
        final b = MohdithItem(id: '2', name: 'البخاري');

        expect(a, isNot(equals(b)));
      });
    });
  });
}
