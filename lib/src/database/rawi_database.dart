import 'package:drift/drift.dart';

import '../models/rawi_item.dart';
import '../utils/arabic_search.dart';
import 'connection/connection_native.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart'
    as impl;
part 'rawi_database.g.dart';

typedef RawiConnectionFactory = DatabaseConnection Function();

@UseRowClass(RawiItem, constructor: 'fromDatabase')
class Rawi extends Table {
  IntColumn get key => integer()();
  TextColumn get value => text()();
  TextColumn get normalizedValue => text()();
  @override
  Set<Column> get primaryKey => {key};
}

/// Immutable reference snapshot. Custom connections must supply schema 2.
class ReferenceSchemaException implements Exception {
  const ReferenceSchemaException(this.actualVersion);
  final int actualVersion;
  @override
  String toString() =>
      'Reference schema $actualVersion is incompatible; schema 2 is required. Create a migrated copy with migrateReferenceDatabase.';
}

@DriftDatabase(tables: [Rawi])
class RawiDatabase extends _$RawiDatabase {
  static RawiConnectionFactory _connectionFactory = impl.openConnection;
  RawiDatabase() : super(_connectionFactory());
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => throw const ReferenceSchemaException(0),
    onUpgrade: (m, from, to) => throw ReferenceSchemaException(from),
    beforeOpen: (details) async {
      if (details.versionBefore != null && details.versionBefore != 2) {
        throw ReferenceSchemaException(details.versionBefore!);
      }
    },
  );
  String _pattern(String query) =>
      '%${normalizeArabicSearch(query.toLowerCase()).replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_')}%';
  void _bounds(int limit, int offset) {
    if (limit < 1 || offset < 0) {
      throw ArgumentError('limit must be positive and offset nonnegative');
    }
  }

  Future<int> countRawi({String? query}) async {
    final countExpr = rawi.key.count();
    final statement = selectOnly(rawi)..addColumns([countExpr]);
    if (query != null) {
      statement.where(
        rawi.normalizedValue.like(_pattern(query), escapeChar: '\\'),
      );
    }
    return (await statement.getSingle()).read(countExpr) ?? 0;
  }

  Future<void> dispose() => close();
  Future<List<RawiItem>> getAllRawi({int limit = 100, int offset = 0}) {
    _bounds(limit, offset);
    return (select(rawi)
          ..orderBy([(t) => OrderingTerm.asc(t.key)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<RawiItem?> getRawiById(int id) =>
      (select(rawi)..where((t) => t.key.equals(id))).getSingleOrNull();
  Future<List<RawiItem>> getRawiByKeys(List<int> keys) =>
      (select(rawi)
            ..where((t) => t.key.isIn(keys))
            ..orderBy([(t) => OrderingTerm.asc(t.key)]))
          .get();
  Future<List<RawiItem>> searchRawi(
    String query, {
    int limit = 20,
    int offset = 0,
  }) {
    _bounds(limit, offset);
    return (select(rawi)
          ..where(
            (t) => t.normalizedValue.like(_pattern(query), escapeChar: '\\'),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.key)])
          ..limit(limit, offset: offset))
        .get();
  }

  static void configureConnection(RawiConnectionFactory factory) {
    _connectionFactory = factory;
  }

  static void resetConnection() {
    _connectionFactory = impl.openConnection;
  }
}
