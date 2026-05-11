import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'create_task_base.dart';

class CreateUrgentTaskPage extends CreateTaskBasePage {
  const CreateUrgentTaskPage({super.key, required super.userId});

  @override
  String get pageTitle => 'Create Urgent Task';

  @override
  TaskUrgency get defaultUrgency => TaskUrgency.urgent;

  @override
  Color get primaryColor => Colors.redAccent;
}
