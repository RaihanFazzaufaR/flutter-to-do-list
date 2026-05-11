import '../models/user_model.dart';
import 'user_repository.dart';
import 'db_helper.dart';

class SqliteUserRepository implements UserRepository {
  final DBHelper _dbHelper;

  SqliteUserRepository(this._dbHelper);

  @override
  Future<User?> checkLogin(String username, String password) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<void> saveUser(String username, String password) async {
    final db = await _dbHelper.database;
    await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  @override
  Future<bool> updatePassword(int userId, String oldPassword, String newPassword) async {
    final db = await _dbHelper.database;
    
    // Check if old password matches
    List<Map> result = await db.query(
      'users',
      where: "id = ? AND password = ?",
      whereArgs: [userId, oldPassword],
    );

    if (result.isEmpty) {
      return false; // Old password incorrect
    }

    // Update password
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    
    return true;
  }
}
