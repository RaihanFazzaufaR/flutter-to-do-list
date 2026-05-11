import '../models/task_model.dart';
import 'task_repository.dart';
import 'db_helper.dart';
import '../utils/app_constants.dart';

class SqliteTaskRepository implements TaskRepository {
  final DBHelper _dbHelper;

  SqliteTaskRepository(this._dbHelper);

  @override
  Future<List<Task>> getTasks(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableTasks,
      where: '${AppConstants.colTaskUserId} = ?',
      whereArgs: [userId],
      orderBy: '${AppConstants.colTaskDueDate} ASC',
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final db = await _dbHelper.database;
    await db.insert(AppConstants.tableTasks, task.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update(
      AppConstants.tableTasks,
      task.toMap(),
      where: '${AppConstants.colTaskId} = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      AppConstants.tableTasks,
      where: '${AppConstants.colTaskId} = ?',
      whereArgs: [id],
    );
  }
}
