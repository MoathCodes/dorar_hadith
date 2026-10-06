// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rawi_database.dart';

// ignore_for_file: type=lint
class $RawiTable extends Rawi with TableInfo<$RawiTable, RawiItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<int> key = GeneratedColumn<int>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedValueMeta = const VerificationMeta(
    'normalizedValue',
  );
  @override
  late final GeneratedColumn<String> normalizedValue = GeneratedColumn<String>(
    'normalized_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, normalizedValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rawi';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawiItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('normalized_value')) {
      context.handle(
        _normalizedValueMeta,
        normalizedValue.isAcceptableOrUnknown(
          data['normalized_value']!,
          _normalizedValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  RawiItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawiItem.fromDatabase(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      normalizedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_value'],
      )!,
    );
  }

  @override
  $RawiTable createAlias(String alias) {
    return $RawiTable(attachedDatabase, alias);
  }
}

class RawiCompanion extends UpdateCompanion<RawiItem> {
  final Value<int> key;
  final Value<String> value;
  final Value<String> normalizedValue;
  const RawiCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.normalizedValue = const Value.absent(),
  });
  RawiCompanion.insert({
    this.key = const Value.absent(),
    required String value,
    required String normalizedValue,
  }) : value = Value(value),
       normalizedValue = Value(normalizedValue);
  static Insertable<RawiItem> custom({
    Expression<int>? key,
    Expression<String>? value,
    Expression<String>? normalizedValue,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (normalizedValue != null) 'normalized_value': normalizedValue,
    });
  }

  RawiCompanion copyWith({
    Value<int>? key,
    Value<String>? value,
    Value<String>? normalizedValue,
  }) {
    return RawiCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      normalizedValue: normalizedValue ?? this.normalizedValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<int>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (normalizedValue.present) {
      map['normalized_value'] = Variable<String>(normalizedValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawiCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('normalizedValue: $normalizedValue')
          ..write(')'))
        .toString();
  }
}

abstract class _$RawiDatabase extends GeneratedDatabase {
  _$RawiDatabase(QueryExecutor e) : super(e);
  $RawiDatabaseManager get managers => $RawiDatabaseManager(this);
  late final $RawiTable rawi = $RawiTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [rawi];
}

typedef $$RawiTableCreateCompanionBuilder = RawiCompanion Function({
  Value<int> key,
  required String value,
  required String normalizedValue,
});
typedef $$RawiTableUpdateCompanionBuilder = RawiCompanion Function({
  Value<int> key,
  Value<String> value,
  Value<String> normalizedValue,
});

class $$RawiTableFilterComposer extends Composer<_$RawiDatabase, $RawiTable> {
  $$RawiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RawiTableOrderingComposer extends Composer<_$RawiDatabase, $RawiTable> {
  $$RawiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawiTableAnnotationComposer
    extends Composer<_$RawiDatabase, $RawiTable> {
  $$RawiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => column,
  );
}

class $$RawiTableTableManager
    extends
        RootTableManager<
          _$RawiDatabase,
          $RawiTable,
          RawiItem,
          $$RawiTableFilterComposer,
          $$RawiTableOrderingComposer,
          $$RawiTableAnnotationComposer,
          $$RawiTableCreateCompanionBuilder,
          $$RawiTableUpdateCompanionBuilder,
          (RawiItem, BaseReferences<_$RawiDatabase, $RawiTable, RawiItem>),
          RawiItem,
          PrefetchHooks Function()
        > {
  $$RawiTableTableManager(_$RawiDatabase db, $RawiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> normalizedValue = const Value.absent(),
              }) => RawiCompanion(
                key: key,
                value: value,
                normalizedValue: normalizedValue,
              ),
          createCompanionCallback:
              ({
                Value<int> key = const Value.absent(),
                required String value,
                required String normalizedValue,
              }) => RawiCompanion.insert(
                key: key,
                value: value,
                normalizedValue: normalizedValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RawiTable, RawiItem>(table),
                  BaseReferences<_$RawiDatabase, $RawiTable, RawiItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RawiTableProcessedTableManager =
    ProcessedTableManager<
      _$RawiDatabase,
      $RawiTable,
      RawiItem,
      $$RawiTableFilterComposer,
      $$RawiTableOrderingComposer,
      $$RawiTableAnnotationComposer,
      $$RawiTableCreateCompanionBuilder,
      $$RawiTableUpdateCompanionBuilder,
      (RawiItem, BaseReferences<_$RawiDatabase, $RawiTable, RawiItem>),
      RawiItem,
      PrefetchHooks Function()
    >;

class $RawiDatabaseManager {
  final _$RawiDatabase _db;
  $RawiDatabaseManager(this._db);
  $$RawiTableTableManager get rawi => $$RawiTableTableManager(_db, _db.rawi);
}
