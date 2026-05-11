import '../models/task_model.dart';
import 'task_repository.dart';
import 'db_helper.dart';

class SqliteTaskRepository implements TaskRepository {
  final DBHelper _dbHelper;

  SqliteTaskRepository(this._dbHelper);

  @override
  Future<List<Task>> getTasks(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'due_date ASC',
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final db = await _dbHelper.database;
    await db.insert('tasks', task.toMap());
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
