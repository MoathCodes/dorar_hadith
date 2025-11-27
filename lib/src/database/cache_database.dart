import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'cache_database.g.dart';

typedef CacheConnectionFactory = DatabaseConnection Function();

@DriftDatabase(tables: [CacheTable])
class CacheDatabase extends _$CacheDatabase {
  CacheDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

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

  static QueryExecutor _openConnection() {
    return NativeDatabase.memory();
  }
}

class CacheTable extends Table {
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiredAt => dateTime()();
  TextColumn get header => text()();
  TextColumn get key => text().unique()();
}
