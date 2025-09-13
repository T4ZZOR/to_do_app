import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_title_w.dart';
import 'package:to_do_app/models/task.dart';

class TaskTitleW extends StatelessWidget{
    final Task task;
    final String categoryId;

    const TaskTitleW({
        super.key,
        required this.task,
        required this.categoryId
    });

    @override Widget build(BuildContext context) {
        return ListTile(
            leading: Checkbox(
                value: task.isDone, onChanged: (_){
                    context.read<TaskProvider>().toggleTaskCheck(categoryId, task.id);
                },
            ),
            title: Text(
                task.taskName,
                style: TextStyle(
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                ),
            ),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                    context.read<TaskProvider>().removeTask(categoryId, task.id);
                }
            ),
        );
    }
}