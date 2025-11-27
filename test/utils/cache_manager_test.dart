import 'package:dorar_hadith/src/models/cache_entry.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryCacheManager', () {
    late InMemoryCacheManager cache;

    setUp(() {
      cache = InMemoryCacheManager(
        defaultTtl: const Duration(milliseconds: 100),
        maxSize: 5,
      );
    });

    tearDown(() {
      cache.clear();
    });

    group('Basic Operations', () {
      test('should store and retrieve values', () {
        final entry = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        cache.set(entry);

        final retrieved = cache.get('key1');
        expect(retrieved, isNotNull);
        expect(retrieved?.body, equals('value1'));
      });

      test('should return null for non-existent keys', () {
        expect(cache.get('nonexistent'), isNull);
      });

      test('should check existence with has()', () {
        final entry = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        cache.set(entry);
        expect(cache.has('key1'), isTrue);
        expect(cache.has('nonexistent'), isFalse);
      });

      test('should remove values', () {
        final entry = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        cache.set(entry);
        cache.remove('key1');
        expect(cache.get('key1'), isNull);
      });

      test('should clear all values', () {
        final entry1 = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        final entry2 = CacheEntry(
          key: 'key2',
          body: 'value2',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        cache.set(entry1);
        cache.set(entry2);

        cache.clear();

        expect(cache.get('key1'), isNull);
        expect(cache.get('key2'), isNull);
      });
    });

    group('TTL and Expiry', () {
      test('should respect expiry time', () async {
        final entry = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(milliseconds: 50)),
        );
        cache.set(entry);

        expect(cache.has('key1'), isTrue);

        await Future.delayed(const Duration(milliseconds: 60));

        expect(cache.has('key1'), isFalse);
        expect(cache.get('key1'), isNull);
      });
    });

    group('Max Size', () {
      test('should enforce max size', () {
        final smallCache = InMemoryCacheManager(maxSize: 2);

        final entry1 = CacheEntry(
          key: 'key1',
          body: 'value1',
          header: 'header',
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        final entry2 = CacheEntry(
          key: 'key2',
          body: 'value2',
          header: 'header',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );
        final entry3 = CacheEntry(
          key: 'key3',
          body: 'value3',
          header: 'header',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );

        smallCache.set(entry1);
        smallCache.set(entry2);
        smallCache.set(entry3); // Should evict entry1 (oldest)

        expect(smallCache.has('key1'), isFalse);
        expect(smallCache.has('key2'), isTrue);
        expect(smallCache.has('key3'), isTrue);
      });
    });
  });
}
