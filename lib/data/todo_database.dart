import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor.dart';

part 'todo_database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqllite", logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [
  Tasks
], queries: {
  'completedTaskGeneratedQueryStatement':
      'SELECT * FROM tasks WHERE is_Completed = 1 ORDER BY due_date DESC, name;',
  'deleteAllRows': 'DELETE FROM tasks ;'
})
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;

  TaskDao(this.db) : super(db);

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
  Future<int> getTasks(List<Tasks> tak){
    return Future.value(tak.length);
  }
  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);

  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);

  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}
