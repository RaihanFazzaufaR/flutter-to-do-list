import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.tasks.isEmpty) {
            return const Center(child: Text("No tasks yet. Create one!"));
          }

          return ListView.builder(
            itemCount: provider.tasks.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              final isDone = task.status == TaskStatus.done;
              final isUrgent = task.urgency == TaskUrgency.urgent;
              final dateString =
                  "${task.date.year}-${task.date.month.toString().padLeft(2, '0')}-${task.date.day.toString().padLeft(2, '0')}";

              return Opacity(
                opacity: isDone ? 0.5 : 1.0,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: isUrgent ? Colors.amber.shade50 : Colors.white,
                  elevation: isUrgent ? 2 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isUrgent
                        ? BorderSide(color: Colors.amber.shade300, width: 1)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    leading: Checkbox(
                      value: isDone,
                      onChanged: (value) {
                        provider.toggleTaskStatus(task);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        fontWeight:
                            isUrgent ? FontWeight.bold : FontWeight.normal,
                        color:
                            isUrgent ? Colors.red.shade900 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.description.isNotEmpty) ...[
                            Text(task.description),
                            const SizedBox(height: 4),
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateString,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.priority_high,
                                size: 14,
                                color: isUrgent ? Colors.orange : Colors.grey,
                              ),
                              Text(
                                task.urgency.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUrgent ? Colors.orange : Colors.grey,
                                  fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        // Show confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text("Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteTask(task);
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
