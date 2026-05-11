import 'package:sqflite/sqflite.dart';
import 'dart:math';

class DatabaseSeeder {
  static Future<void> seed(Database db) async {
    await db.insert('users', {'username': 'user', 'password': 'user'});
    print("Default user added");

    // Generate 20 Random Tasks
    final random = Random();
    final now = DateTime.now();

    for (int i = 0; i < 20; i++) {
      // Random days offset between -7 and +7
      final daysOffset = random.nextInt(15) - 7;
      final dueDate = now.add(Duration(days: daysOffset));

      final isDone = random.nextBool();
      final isUrgent = random.nextBool();

      await db.insert('tasks', {
        'user_id': 1,
        'title': 'Dummy Task ${i + 1}',
        'description':
            'This is an auto-generated dummy task for testing charts and layouts.',
        'due_date': dueDate.toIso8601String(),
        'category': isUrgent ? 'urgent' : 'normal',
        'status': isDone ? 1 : 0,
      });
    }

    print("Injected 20 random dummy tasks");
  }
}
