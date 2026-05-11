import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/auth_gate.dart';
import 'providers/task_provider.dart';
import 'providers/auth_provider.dart';
import 'services/sqlite_task_repository.dart';
import 'services/sqlite_user_repository.dart';
import 'services/user_repository.dart';
import 'services/task_repository.dart';
import 'services/db_helper.dart';

void main() {
  // Initialize dependencies
  final dbHelper = DBHelper();
  final userRepository = SqliteUserRepository(dbHelper);
  final taskRepository = SqliteTaskRepository(dbHelper);

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
        Provider<TaskRepository>.value(value: taskRepository),
        ChangeNotifierProvider(create: (_) => AuthProvider(userRepository)),
        ChangeNotifierProvider(create: (_) => TaskProvider(taskRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DueDash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
