// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String name;
  final DateTime dueDate;
  final bool isCompleted;
  Task(
      {@required this.id,
      @required this.name,
      this.dueDate,
      @required this.isCompleted});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Task(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      dueDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
      isCompleted: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_completed']),
    );
  }
  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Task(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Task>>(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      isCompleted: isCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(isCompleted),
    ) as T;
  }

  Task copyWith({int id, String name, DateTime dueDate, bool isCompleted}) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc($mrjc($mrjc(0, id.hashCode), name.hashCode), dueDate.hashCode),
      isCompleted.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.name == name &&
          other.dueDate == dueDate &&
          other.isCompleted == isCompleted);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> dueDate;
  final Value<bool> isCompleted;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false, hasAutoIncrement: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  GeneratedDateTimeColumn _dueDate;
  @override
  GeneratedDateTimeColumn get dueDate => _dueDate ??= _constructDueDate();
  GeneratedDateTimeColumn _constructDueDate() {
    return GeneratedDateTimeColumn(
      'due_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  GeneratedBoolColumn _isCompleted;
  @override
  GeneratedBoolColumn get isCompleted =>
      _isCompleted ??= _constructIsCompleted();
  GeneratedBoolColumn _constructIsCompleted() {
    return GeneratedBoolColumn('is_completed', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, dueDate, isCompleted];
  @override
  $TasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tasks';
  @override
  final String actualTableName = 'tasks';
  @override
  VerificationContext validateIntegrity(TasksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.dueDate.present) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableValue(d.dueDate.value, _dueDateMeta));
    } else if (dueDate.isRequired && isInserting) {
      context.missing(_dueDateMeta);
    }
    if (d.isCompleted.present) {
      context.handle(_isCompletedMeta,
          isCompleted.isAcceptableValue(d.isCompleted.value, _isCompletedMeta));
    } else if (isCompleted.isRequired && isInserting) {
      context.missing(_isCompletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Task.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(TasksCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.dueDate.present) {
      map['due_date'] = Variable<DateTime, DateTimeType>(d.dueDate.value);
    }
    if (d.isCompleted.present) {
      map['is_completed'] = Variable<bool, BoolType>(d.isCompleted.value);
    }
    return map;
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  TaskDao _taskDao;
  TaskDao get taskDao => _taskDao ??= TaskDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [tasks];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $TasksTable get tasks => db.tasks;
  Task _rowToTask(QueryRow row) {
    return Task(
      id: row.readInt('id'),
      name: row.readString('name'),
      dueDate: row.readDateTime('due_date'),
      isCompleted: row.readBool('is_completed'),
    );
  }

  Future<List<Task>> completedTaskGeneratedQueryStatement(
      {@Deprecated('No longer needed with Moor 1.6 - see the changelog for details')
          QueryEngine operateOn}) {
    return (operateOn ?? this).customSelect(
        'SELECT * FROM tasks WHERE is_Completed = 1 ORDER BY due_date DESC, name;',
        variables: []).then((rows) => rows.map(_rowToTask).toList());
  }

  Stream<List<Task>> watchCompletedTaskGeneratedQueryStatement() {
    return customSelectStream(
        'SELECT * FROM tasks WHERE is_Completed = 1 ORDER BY due_date DESC, name;',
        variables: [],
        readsFrom: {tasks}).map((rows) => rows.map(_rowToTask).toList());
  }

  Future<int> deleteAllRows(
      {@Deprecated('No longer needed with Moor 1.6 - see the changelog for details')
          QueryEngine operateOn}) {
    return (operateOn ?? this).customUpdate(
      'DELETE FROM tasks ;',
      variables: [],
      updates: {tasks},
    );
  }
}
