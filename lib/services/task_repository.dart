import '../models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks(int userId);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}
