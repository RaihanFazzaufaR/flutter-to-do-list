enum TaskUrgency { normal, urgent }
enum TaskStatus { ongoing, done }

class Task {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final DateTime date;
  final TaskUrgency urgency;
  TaskStatus status;

  Task({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.urgency,
    this.status = TaskStatus.ongoing,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': date.toIso8601String(),
      'category': urgency.name,
      'status': status == TaskStatus.done ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['due_date']),
      urgency: TaskUrgency.values.byName(map['category']),
      status: map['status'] == 1 ? TaskStatus.done : TaskStatus.ongoing,
    );
  }
}
