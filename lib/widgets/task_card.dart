import 'package:flutter/material.dart';
import '../models/task_models.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isComplete ? TextDecoration.lineThrough : null,
            color: task.isComplete ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(task.description),
        onTap: onTap,
        trailing: Icon(
          task.isComplete ? Icons.check_circle : Icons.circle_outlined,
          color: task.isComplete ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
