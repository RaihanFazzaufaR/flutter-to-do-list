import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_seeder.dart';
import '../utils/app_constants.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), 'todolist_database.db');

    // Delete the database file every time the app starts to refresh dummy data
    // and apply any schema changes automatically during development.

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 4,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createDB(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute("DROP TABLE IF EXISTS ${AppConstants.tableTasks}");
          await db.execute("DROP TABLE IF EXISTS ${AppConstants.tableUsers}");
          await _createDB(db, newVersion);
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Create Table Users
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUsers} (
        ${AppConstants.colUserId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colUsername} TEXT UNIQUE NOT NULL,
        ${AppConstants.colPassword} TEXT NOT NULL
      )
    ''');

    // 2. Create Table Tasks
    await db.execute('''
      CREATE TABLE ${AppConstants.tableTasks} (
        ${AppConstants.colTaskId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colTaskUserId} INTEGER NOT NULL,
        ${AppConstants.colTaskTitle} TEXT NOT NULL,
        ${AppConstants.colTaskDescription} TEXT,
        ${AppConstants.colTaskDueDate} TEXT NOT NULL,
        ${AppConstants.colTaskCategory} TEXT NOT NULL,
        ${AppConstants.colTaskStatus} INTEGER DEFAULT 0,
        FOREIGN KEY (${AppConstants.colTaskUserId}) REFERENCES ${AppConstants.tableUsers} (${AppConstants.colUserId}) ON DELETE CASCADE
      )
    ''');
    print("Database tables created");

    // Seed dummy data
    await DatabaseSeeder.seed(db);
  }
}
