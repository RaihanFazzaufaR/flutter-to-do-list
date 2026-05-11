import 'package:sqflite/sqflite.dart';
import 'dart:math';
import 'package:bcrypt/bcrypt.dart';
import '../utils/app_constants.dart';

class DatabaseSeeder {
  static Future<void> seed(Database db) async {
    final hashedPassword = BCrypt.hashpw('user', BCrypt.gensalt());
    
    await db.insert(AppConstants.tableUsers, {
      AppConstants.colUsername: 'user', 
      AppConstants.colPassword: hashedPassword
    });
    print("Default user added with hashed password");

    // Generate 20 Random Tasks
    final random = Random();
    final now = DateTime.now();

    for (int i = 0; i < 20; i++) {
      // Random days offset between -7 and +7
      final daysOffset = random.nextInt(15) - 7;
      final dueDate = now.add(Duration(days: daysOffset));

      final isDone = random.nextBool();
      final isUrgent = random.nextBool();

      await db.insert(AppConstants.tableTasks, {
        AppConstants.colTaskUserId: 1,
        AppConstants.colTaskTitle: 'Dummy Task ${i + 1}',
        AppConstants.colTaskDescription:
            'This is an auto-generated dummy task for testing charts and layouts.',
        AppConstants.colTaskDueDate: dueDate.toIso8601String(),
        AppConstants.colTaskCategory: isUrgent ? 'urgent' : 'normal',
        AppConstants.colTaskStatus: isDone ? 1 : 0,
      });
    }

    print("Injected 20 random dummy tasks");
  }
}
