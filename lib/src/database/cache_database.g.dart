// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// ignore_for_file: type=lint
class $CacheTableTable extends CacheTable
    with TableInfo<$CacheTableTable, CacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiredAtMeta = const VerificationMeta(
    'expiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiredAt = GeneratedColumn<DateTime>(
    'expired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headerMeta = const VerificationMeta('header');
  @override
  late final GeneratedColumn<String> header = GeneratedColumn<String>(
    'header',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    body,
    createdAt,
    expiredAt,
    header,
    key,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expired_at')) {
      context.handle(
        _expiredAtMeta,
        expiredAt.isAcceptableOrUnknown(data['expired_at']!, _expiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiredAtMeta);
    }
    if (data.containsKey('header')) {
      context.handle(
        _headerMeta,
        header.isAcceptableOrUnknown(data['header']!, _headerMeta),
      );
    } else if (isInserting) {
      context.missing(_headerMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheTableData(
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expired_at'],
      )!,
      header: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}header'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
    );
  }

  @override
  $CacheTableTable createAlias(String alias) {
    return $CacheTableTable(attachedDatabase, alias);
  }
}

class CacheTableData extends DataClass implements Insertable<CacheTableData> {
  final String body;
  final DateTime createdAt;
  final DateTime expiredAt;
  final String header;
  final String key;
  const CacheTableData({
    required this.body,
    required this.createdAt,
    required this.expiredAt,
    required this.header,
    required this.key,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expired_at'] = Variable<DateTime>(expiredAt);
    map['header'] = Variable<String>(header);
    map['key'] = Variable<String>(key);
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      body: Value(body),
      createdAt: Value(createdAt),
      expiredAt: Value(expiredAt),
      header: Value(header),
      key: Value(key),
    );
  }

  factory CacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheTableData(
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiredAt: serializer.fromJson<DateTime>(json['expiredAt']),
      header: serializer.fromJson<String>(json['header']),
      key: serializer.fromJson<String>(json['key']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiredAt': serializer.toJson<DateTime>(expiredAt),
      'header': serializer.toJson<String>(header),
      'key': serializer.toJson<String>(key),
    };
  }

  CacheTableData copyWith({
    String? body,
    DateTime? createdAt,
    DateTime? expiredAt,
    String? header,
    String? key,
  }) => CacheTableData(
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    expiredAt: expiredAt ?? this.expiredAt,
    header: header ?? this.header,
    key: key ?? this.key,
  );
  CacheTableData copyWithCompanion(CacheTableCompanion data) {
    return CacheTableData(
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiredAt: data.expiredAt.present ? data.expiredAt.value : this.expiredAt,
      header: data.header.present ? data.header.value : this.header,
      key: data.key.present ? data.key.value : this.key,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableData(')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('header: $header, ')
          ..write('key: $key')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(body, createdAt, expiredAt, header, key);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheTableData &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.expiredAt == this.expiredAt &&
          other.header == this.header &&
          other.key == this.key);
}

class CacheTableCompanion extends UpdateCompanion<CacheTableData> {
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiredAt;
  final Value<String> header;
  final Value<String> key;
  final Value<int> rowid;
  const CacheTableCompanion({
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.header = const Value.absent(),
    this.key = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheTableCompanion.insert({
    required String body,
    this.createdAt = const Value.absent(),
    required DateTime expiredAt,
    required String header,
    required String key,
    this.rowid = const Value.absent(),
  }) : body = Value(body),
       expiredAt = Value(expiredAt),
       header = Value(header),
       key = Value(key);
  static Insertable<CacheTableData> custom({
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiredAt,
    Expression<String>? header,
    Expression<String>? key,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (header != null) 'header': header,
      if (key != null) 'key': key,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheTableCompanion copyWith({
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiredAt,
    Value<String>? header,
    Value<String>? key,
    Value<int>? rowid,
  }) {
    return CacheTableCompanion(
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      expiredAt: expiredAt ?? this.expiredAt,
      header: header ?? this.header,
      key: key ?? this.key,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiredAt.present) {
      map['expired_at'] = Variable<DateTime>(expiredAt.value);
    }
    if (header.present) {
      map['header'] = Variable<String>(header.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableCompanion(')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('header: $header, ')
          ..write('key: $key, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(e);
  $CacheDatabaseManager get managers => $CacheDatabaseManager(this);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheTable];
}

typedef $$CacheTableTableCreateCompanionBuilder =
    CacheTableCompanion Function({
      required String body,
      Value<DateTime> createdAt,
      required DateTime expiredAt,
      required String header,
      required String key,
      Value<int> rowid,
    });
typedef $$CacheTableTableUpdateCompanionBuilder =
    CacheTableCompanion Function({
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime> expiredAt,
      Value<String> header,
      Value<String> key,
      Value<int> rowid,
    });

class $$CacheTableTableFilterComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get header => $composableBuilder(
    column: $table.header,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheTableTableOrderingComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get header => $composableBuilder(
    column: $table.header,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheTableTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiredAt =>
      $composableBuilder(column: $table.expiredAt, builder: (column) => column);

  GeneratedColumn<String> get header =>
      $composableBuilder(column: $table.header, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);
}

class $$CacheTableTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CacheTableTable,
          CacheTableData,
          $$CacheTableTableFilterComposer,
          $$CacheTableTableOrderingComposer,
          $$CacheTableTableAnnotationComposer,
          $$CacheTableTableCreateCompanionBuilder,
          $$CacheTableTableUpdateCompanionBuilder,
          (
            CacheTableData,
            BaseReferences<_$CacheDatabase, $CacheTableTable, CacheTableData>,
          ),
          CacheTableData,
          PrefetchHooks Function()
        > {
  $$CacheTableTableTableManager(_$CacheDatabase db, $CacheTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiredAt = const Value.absent(),
                Value<String> header = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheTableCompanion(
                body: body,
                createdAt: createdAt,
                expiredAt: expiredAt,
                header: header,
                key: key,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String body,
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime expiredAt,
                required String header,
                required String key,
                Value<int> rowid = const Value.absent(),
              }) => CacheTableCompanion.insert(
                body: body,
                createdAt: createdAt,
                expiredAt: expiredAt,
                header: header,
                key: key,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CacheTableTable,
      CacheTableData,
      $$CacheTableTableFilterComposer,
      $$CacheTableTableOrderingComposer,
      $$CacheTableTableAnnotationComposer,
      $$CacheTableTableCreateCompanionBuilder,
      $$CacheTableTableUpdateCompanionBuilder,
      (
        CacheTableData,
        BaseReferences<_$CacheDatabase, $CacheTableTable, CacheTableData>,
      ),
      CacheTableData,
      PrefetchHooks Function()
    >;

class $CacheDatabaseManager {
  final _$CacheDatabase _db;
  $CacheDatabaseManager(this._db);
  $$CacheTableTableTableManager get cacheTable =>
      $$CacheTableTableTableManager(_db, _db.cacheTable);
}
