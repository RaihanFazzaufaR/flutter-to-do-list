import '../models/user_model.dart';
import 'user_repository.dart';
import 'db_helper.dart';
import '../utils/app_constants.dart';
import 'package:bcrypt/bcrypt.dart';

class SqliteUserRepository implements UserRepository {
  final DBHelper _dbHelper;

  SqliteUserRepository(this._dbHelper);

  @override
  Future<User?> checkLogin(String username, String password) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      AppConstants.tableUsers,
      where: "${AppConstants.colUsername} = ?",
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      final userMap = result.first;
      final hashedPassword = userMap[AppConstants.colPassword] as String;
      
      if (BCrypt.checkpw(password, hashedPassword)) {
        return User.fromMap(userMap);
      }
    }
    return null;
  }

  @override
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      AppConstants.tableUsers,
      where: "${AppConstants.colUserId} = ?",
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
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    
    await db.insert(AppConstants.tableUsers, {
      AppConstants.colUsername: username,
      AppConstants.colPassword: hashedPassword,
    });
  }

  @override
  Future<bool> updatePassword(int userId, String oldPassword, String newPassword) async {
    final db = await _dbHelper.database;
    
    // 1. Fetch current user
    List<Map<String, dynamic>> result = await db.query(
      AppConstants.tableUsers,
      where: "${AppConstants.colUserId} = ?",
      whereArgs: [userId],
    );

    if (result.isEmpty) return false;

    // 2. Verify old password
    final currentHash = result.first[AppConstants.colPassword] as String;
    if (!BCrypt.checkpw(oldPassword, currentHash)) {
      return false;
    }

    // 3. Hash and update new password
    final newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    await db.update(
      AppConstants.tableUsers,
      {AppConstants.colPassword: newHashedPassword},
      where: "${AppConstants.colUserId} = ?",
      whereArgs: [userId],
    );
    
    return true;
  }
}
