import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('DorarClient.use', () {
    test('runs the provided callback and disposes client', () async {
      final count = await DorarClient.use((c) async {
        // Use a purely offline reference operation to avoid network.
        return c.bookRef.countBooks();
      });

      expect(count, isA<int>());
      expect(count, greaterThan(0));
    });

    test('disposes client when callback throws', () async {
      DorarClient? captured;

      await expectLater(
        DorarClient.use((c) async {
          captured = c;
          throw StateError('boom');
        }),
        throwsA(isA<StateError>()),
      );

      await expectLater(captured!.clearCache(), throwsA(anything));
    });
  });
}
