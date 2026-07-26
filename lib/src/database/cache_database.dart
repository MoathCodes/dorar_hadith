import 'package:drift/drift.dart';

import 'connection/connection_native.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart'
    as impl;

part 'cache_database.g.dart';

typedef CacheConnectionFactory = DatabaseConnection Function();

@DriftDatabase(tables: [CacheTable])
class CacheDatabase extends _$CacheDatabase {
  static CacheConnectionFactory _connectionFactory = impl.openCacheConnection;

  CacheDatabase([QueryExecutor? e]) : super(e ?? _connectionFactory());

  @override
  int get schemaVersion => 1;

  Future<void> clear() => managers.cacheTable.delete();

  Future<void> clearExpiredCache([DateTime? now]) {
    final date = now ?? DateTime.now();
    return managers.cacheTable
        .filter((f) => f.expiredAt.isBefore(date))
        .delete();
  }

  Future<void> deleteCacheEntry(String key) =>
      managers.cacheTable.filter((f) => f.key.equals(key)).delete();

  Future<CacheTableData?> getCacheEntry(String key) =>
      managers.cacheTable.filter((f) => f.key.equals(key)).getSingleOrNull();

  Future<void> insertOrUpdateCacheEntry(CacheTableCompanion entry) =>
      managers.cacheTable.create((o) => entry, mode: .insertOrReplace);

  Future<int> countCacheEntries() async {
    final countExpr = cacheTable.key.count();
    final query = selectOnly(cacheTable)..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  /// Deletes the oldest cache rows by [createdAt], skipping [excludeKey]
  /// and any keys in [excludeKeys].
  Future<void> evictOldestEntries(
    int count, {
    String? excludeKey,
    Set<String>? excludeKeys,
  }) async {
    if (count <= 0) return;

    final protected = <String>{
      if (excludeKey != null) excludeKey,
      ...?excludeKeys,
    };

    final oldest = await (select(cacheTable)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    var removed = 0;
    for (final entry in oldest) {
      if (removed >= count) break;
      if (protected.contains(entry.key)) continue;
      await deleteCacheEntry(entry.key);
      removed++;
    }
  }

  /// Override the connection factory used when instantiating new databases.
  static void configureConnection(CacheConnectionFactory factory) {
    _connectionFactory = factory;
  }

  /// Reset the connection factory back to the platform default.
  static void resetConnection() {
    _connectionFactory = impl.openCacheConnection;
  }
}

class CacheTable extends Table {
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiredAt => dateTime()();
  TextColumn get header => text()();
  TextColumn get key => text().unique()();
}
