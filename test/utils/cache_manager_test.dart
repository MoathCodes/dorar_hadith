import 'package:dorar_hadith/dorar_hadith.dart';
import 'package:test/test.dart';

void main() {
  group('CacheManager', () {
    late CacheManager cache;

    setUp(() {
      cache = CacheManager(defaultTtl: const Duration(milliseconds: 100));
    });

    tearDown(() {
      cache.clear();
    });

    group('Basic Operations', () {
      test('should store and retrieve values', () {
        cache.set('key1', 'value1');
        expect(cache.get<String>('key1'), equals('value1'));
      });

      test('should return null for non-existent keys', () {
        expect(cache.get<String>('nonexistent'), isNull);
      });

      test('should support different types', () {
        cache.set('string', 'text');
        cache.set('int', 42);
        cache.set('bool', true);
        cache.set('list', [1, 2, 3]);
        cache.set('map', {'key': 'value'});

        expect(cache.get<String>('string'), equals('text'));
        expect(cache.get<int>('int'), equals(42));
        expect(cache.get<bool>('bool'), isTrue);
        expect(cache.get<List>('list'), equals([1, 2, 3]));
        expect(cache.get<Map>('map'), equals({'key': 'value'}));
      });

      test('should check if key exists', () {
        cache.set('existing', 'value');
        expect(cache.has('existing'), isTrue);
        expect(cache.has('nonexistent'), isFalse);
      });

      test('should remove specific entries', () {
        cache.set('key1', 'value1');
        cache.set('key2', 'value2');

        cache.remove('key1');

        expect(cache.has('key1'), isFalse);
        expect(cache.has('key2'), isTrue);
      });

      test('should clear all entries', () {
        cache.set('key1', 'value1');
        cache.set('key2', 'value2');
        cache.set('key3', 'value3');

        cache.clear();

        expect(cache.has('key1'), isFalse);
        expect(cache.has('key2'), isFalse);
        expect(cache.has('key3'), isFalse);
      });
    });

    group('Expiry Mechanism', () {
      test('should expire entries after TTL', () async {
        cache.set('key', 'value');
        expect(cache.has('key'), isTrue);

        // Wait for expiry
        await Future.delayed(const Duration(milliseconds: 150));

        expect(cache.has('key'), isFalse);
        expect(cache.get<String>('key'), isNull);
      });

      test('should support custom TTL per entry', () async {
        cache.set('short', 'value1', ttl: const Duration(milliseconds: 50));
        cache.set('long', 'value2', ttl: const Duration(milliseconds: 200));

        await Future.delayed(const Duration(milliseconds: 75));

        expect(cache.has('short'), isFalse);
        expect(cache.has('long'), isTrue);

        await Future.delayed(const Duration(milliseconds: 150));

        expect(cache.has('long'), isFalse);
      });

      test('should remove expired entries manually', () async {
        cache.set('key1', 'value1');
        cache.set('key2', 'value2');

        await Future.delayed(const Duration(milliseconds: 150));

        cache.removeExpired();

        final stats = cache.getStats();
        expect(stats.totalEntries, equals(0));
      });

      test('should not return expired entries', () async {
        cache.set('key', 'value');

        await Future.delayed(const Duration(milliseconds: 150));

        expect(cache.get<String>('key'), isNull);
      });
    });

    group('Factory Patterns', () {
      test('getOrSet should return cached value if exists', () async {
        var factoryCalls = 0;

        final value1 = await cache.getOrSet<String>('key', () async {
          factoryCalls++;
          return 'computed';
        });

        final value2 = await cache.getOrSet<String>('key', () async {
          factoryCalls++;
          return 'computed again';
        });

        expect(value1, equals('computed'));
        expect(value2, equals('computed'));
        expect(factoryCalls, equals(1)); // Factory called only once
      });

      test('getOrSet should call factory if key does not exist', () async {
        final value = await cache.getOrSet<int>('key', () async {
          await Future.delayed(const Duration(milliseconds: 10));
          return 42;
        });

        expect(value, equals(42));
        expect(cache.get<int>('key'), equals(42));
      });

      test('getOrSet should call factory if entry expired', () async {
        var factoryCalls = 0;

        await cache.getOrSet<String>('key', () async {
          factoryCalls++;
          return 'first';
        }, ttl: const Duration(milliseconds: 50));

        await Future.delayed(const Duration(milliseconds: 75));

        final value = await cache.getOrSet<String>('key', () async {
          factoryCalls++;
          return 'second';
        });

        expect(value, equals('second'));
        expect(factoryCalls, equals(2));
      });

      test('getOrSetSync should work with sync factories', () {
        var factoryCalls = 0;

        final value1 = cache.getOrSetSync<String>('key', () {
          factoryCalls++;
          return 'computed';
        });

        final value2 = cache.getOrSetSync<String>('key', () {
          factoryCalls++;
          return 'computed again';
        });

        expect(value1, equals('computed'));
        expect(value2, equals('computed'));
        expect(factoryCalls, equals(1));
      });
    });

    group('Statistics', () {
      test('should track total entries', () {
        cache.set('key1', 'value1');
        cache.set('key2', 'value2');
        cache.set('key3', 'value3');

        final stats = cache.getStats();
        expect(stats.totalEntries, equals(3));
      });

      test('should track valid entries', () async {
        cache.set('key1', 'value1', ttl: const Duration(milliseconds: 50));
        cache.set('key2', 'value2', ttl: const Duration(milliseconds: 200));

        await Future.delayed(const Duration(milliseconds: 75));

        final stats = cache.getStats();
        expect(stats.validEntries, equals(1));
        expect(stats.expiredEntries, equals(1));
      });

      test('should update stats after operations', () {
        cache.set('key1', 'value1');
        cache.set('key2', 'value2');

        var stats = cache.getStats();
        expect(stats.totalEntries, equals(2));

        cache.remove('key1');

        stats = cache.getStats();
        expect(stats.totalEntries, equals(1));

        cache.clear();

        stats = cache.getStats();
        expect(stats.totalEntries, equals(0));
      });
    });

    group('Edge Cases', () {
      test('should handle null values', () {
        cache.set('key', null);
        expect(cache.has('key'), isTrue);
        expect(cache.get('key'), isNull);
      });

      test('should handle overwriting existing keys', () {
        cache.set('key', 'value1');
        cache.set('key', 'value2');

        expect(cache.get<String>('key'), equals('value2'));

        final stats = cache.getStats();
        expect(stats.totalEntries, equals(1));
      });

      test('should handle removing non-existent keys', () {
        expect(() => cache.remove('nonexistent'), returnsNormally);
      });

      test('should handle zero TTL', () {
        final instantCache = CacheManager(defaultTtl: Duration.zero);
        instantCache.set('key', 'value');

        expect(instantCache.has('key'), isFalse);
      });
    });
  });
}
