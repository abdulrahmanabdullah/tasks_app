import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor.dart';

part 'task_database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tagName =>
      text().nullable().customConstraint("NULL REFERENCES tags(name)")();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
}

class Tags extends Table {
  TextColumn get name => text().withLength(min: 1, max: 10)();

  IntColumn get color => integer()();

  // Make name as a primary key, because each tag has a uniq name

  @override
  Set<Column> get primaryKey => {name};
}

class TaskWithTag {
  final Task task;

  final Tag tag;

  TaskWithTag({@required this.task, @required this.tag});
}

// Database
@UseMoor(tables: [Tasks, Tags], daos: [TaskDao, TagDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqllite", logStatements: true));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (migrator, from, to) async {
        if (from == 1) {
          await migrator.addColumn(tasks, tasks.tagName);
          await migrator.createTable(tags);
        }
      }, beforeOpen: (db, details) async {
        await db.customStatement('PRAGMA foreign_keys = ON');
      });
}

// Task Dao
@UseDao(tables: [
  Tasks,
  Tags
], queries: {
  'completedTaskGeneratedQueryStatement':
      'SELECT * FROM tasks WHERE is_completed = 1 ORDER BY due_date DESC, name;',
  'deleteAllRows': 'DELETE FROM tasks ;'
})
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;

  TaskDao(this.db) : super(db);

  // Get all tasks with tags
  Stream<List<TaskWithTag>> watchAllTaskWithTag() {
    return ((select(tasks)
          ..orderBy(
            ([
              (p) =>
                  OrderingTerm(expression: p.dueDate, mode: OrderingMode.desc),
            ]),
          ))
        .join([
          leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
        ])
        .watch()
        .map((rows) => rows.map(
              (row) {
                return TaskWithTag(
                    task: row.readTable(tasks), tag: row.readTable(tags));
              },
            ).toList()));
  }

  // Dao
  Future<List<Task>> getAllTask() => select(tasks).get();

  Stream<List<Task>> watchAllTask() {
    return ((select(tasks)
          ..orderBy(([
            // Primary sorting by due date ..
            (p) => OrderingTerm(expression: p.dueDate, mode: OrderingMode.desc),
            // alphabetical sorting .
            (p) => OrderingTerm(expression: p.name)
          ])))
        .watch());
  }

  // Get completed task with tag ...
  Stream<List<TaskWithTag>> watchAllCompletedTaskWithTag() {
    return ((select(tasks)
          ..orderBy([
            (p) => OrderingTerm(expression: p.dueDate, mode: OrderingMode.desc)
          ])
          ..where((t) => t.isCompleted.equals(true)))
        .join([leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName))])
        .watch()
        .map((rows) => rows.map((row) {
              return TaskWithTag(
                  task: row.readTable(tasks), tag: row.readTable(tags));
            }).toList()));
  }

  //Custom select queries
  // so far this not working ... 😥
  Stream<List<Task>> watchCompletedTaskCustom() {
    return customSelectStream(
        'SELECT * FROM tasks WHERE is_Completed = 1 ORDER BY due_date DESC, name;',
        readsFrom: {tasks}).map((rows) {
      return rows.map((row) => Task.fromData(row.data, db));
    });
  }

  //Get all tasks as a int
  Future<int> getTasks(List<Tasks> tak) {
    return Future.value(tak.length);
  }

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);

  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);

  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}

//Tags Dao
@UseDao(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  final AppDatabase db;

  TagDao(this.db) : super(db);

  Stream<List<Tag>> watchTags() => select(tags).watch();

  Future insertTag(Insertable<Tag> tag) => into(tags).insert(tag);
}
