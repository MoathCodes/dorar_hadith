import 'package:dorar_hadith/src/database/cache_database.dart';
import 'package:dorar_hadith/src/models/cache_entry.dart';
import 'package:dorar_hadith/src/services/cache_service.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

CacheEntry _entry(
  String key, {
  DateTime? createdAt,
  DateTime? expiresAt,
}) {
  final now = DateTime.now();
  return CacheEntry(
    key: key,
    body: 'body-$key',
    header: 'header-$key',
    createdAt: createdAt ?? now,
    expiresAt: expiresAt ?? now.add(const Duration(days: 1)),
  );
}

void main() {
  group('CacheService SQLite persistence', () {
    late CacheDatabase database;
    late CacheService cache;

    setUp(() {
      database = CacheDatabase(NativeDatabase.memory());
      cache = CacheService(database: database, maxSqliteRows: 5);
    });

    tearDown(() async {
      await cache.dispose();
    });

    test('enforces maxSqliteRows by evicting oldest entries', () async {
      for (var i = 0; i < 7; i++) {
        await cache.set(
          _entry(
            'key$i',
            createdAt: DateTime(2025, 1, 1).add(Duration(minutes: i)),
          ),
        );
      }

      expect(await database.countCacheEntries(), equals(5));
      expect(await database.getCacheEntry('key0'), isNull);
      expect(await database.getCacheEntry('key1'), isNull);
      expect(await database.getCacheEntry('key6'), isNotNull);
    });

    test('clearExpiredCache removes expired rows on maintenance interval', () async {
      final maintenanceDatabase = CacheDatabase(NativeDatabase.memory());
      final maintenanceCache = CacheService(
        database: maintenanceDatabase,
        maxSqliteRows: 100,
      );
      addTearDown(maintenanceCache.dispose);

      final expired = _entry(
        'expired',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      await maintenanceCache.set(expired);

      for (var i = 0; i < 50; i++) {
        await maintenanceCache.set(_entry('fresh-$i'));
      }

      expect(await maintenanceDatabase.getCacheEntry('expired'), isNull);
    });
  });
}
