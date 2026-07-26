import 'dart:convert';
import 'dart:io';

import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('BookReference constants', () {
    late Map<String, String> bookJson;

    setUpAll(() {
      final file = File('assets/data/book.json');
      final list = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      bookJson = {
        for (final item in list)
          (item as Map<String, dynamic>)['key'] as String:
              item['value'] as String,
      };
    });

    test('knownBooks IDs and names match book.json', () {
      for (final book in BookReference.knownBooks) {
        expect(
          bookJson.containsKey(book.id),
          isTrue,
          reason: '${book.name} (id=${book.id}) missing from book.json',
        );
        expect(
          bookJson[book.id],
          equals(book.name),
          reason: 'Label mismatch for id=${book.id}',
        );
      }
    });

    test('all filter constant is id 0', () {
      expect(BookReference.all.id, '0');
      expect(BookReference.all.name, 'الجميع');
    });
  });
}
