import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository;
  List<Task> _tasks = [];
  bool _isLoading = false;
  int? _currentUserId;

  TaskProvider(this._taskRepository);

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  int? get currentUserId => _currentUserId;

  int get doneTasksCount => _tasks.where((t) => t.status == TaskStatus.done).length;
  int get ongoingTasksCount => _tasks.where((t) => t.status == TaskStatus.ongoing).length;

  void setUserId(int userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (_currentUserId == null) return;
    
    _isLoading = true;
    Future.microtask(() => notifyListeners());
    
    _tasks = await _taskRepository.getTasks(_currentUserId!);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);
    await _loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final newStatus = task.status == TaskStatus.done 
        ? TaskStatus.ongoing 
        : TaskStatus.done;
    
    task.status = newStatus;
    await _taskRepository.updateTask(task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) return;
    await _taskRepository.deleteTask(task.id!);
    await _loadTasks();
  }
}
