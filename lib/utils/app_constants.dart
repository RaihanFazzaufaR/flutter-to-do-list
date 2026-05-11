class AppConstants {
  // Database Tables
  static const String tableUsers = 'users';
  static const String tableTasks = 'tasks';

  // User Columns
  static const String colUserId = 'id';
  static const String colUsername = 'username';
  static const String colPassword = 'password';

  // Task Columns
  static const String colTaskId = 'id';
  static const String colTaskUserId = 'user_id';
  static const String colTaskTitle = 'title';
  static const String colTaskDescription = 'description';
  static const String colTaskDueDate = 'due_date';
  static const String colTaskCategory = 'category';
  static const String colTaskStatus = 'status';

  // SharedPreferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
}
