import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'create_task_base.dart';

class CreateNormalTaskPage extends CreateTaskBasePage {
  const CreateNormalTaskPage({super.key, required super.userId});

  @override
  String get pageTitle => 'Create Normal Task';

  @override
  TaskUrgency get defaultUrgency => TaskUrgency.normal;

  @override
  Color get primaryColor => Colors.blue;
}
