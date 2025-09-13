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
        return Column(
            children: [
                ListTile(
                  minVerticalPadding: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                        icon: const Icon(Icons.close),
                        color: const Color.fromARGB(255, 126, 126, 126),
                        onPressed: () {
                            context.read<TaskProvider>().removeTask(categoryId, task.id);
                        }
                    ),
                ),
                if (task.subTask.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 0),
                        child: Column(
                            children: task.subTask.map((sub) {
                                return ListTile(
                                    leading: Checkbox(
                                        value: sub.isDone, 
                                        onChanged: (_){
                                            context.read<TaskProvider>().toggleSubTaskCheck(categoryId, task.id, sub.id);
                                        },
                                    ),
                                    title: Text(
                                        sub.taskName,
                                        style: TextStyle(
                                            decoration: sub.isDone ? TextDecoration.lineThrough : null,
                                        ),
                                    ),
                                    trailing: IconButton(
                                        icon: const Icon(Icons.close),
                                        color: const Color.fromARGB(255, 126, 126, 126),
                                        onPressed: () {
                                            context.read<TaskProvider>().removeSubTask(categoryId, task.id, sub);
                                        }
                                    ),
                                );
                            }).toList(),
                        ),
                    ),
            ],
        );
    }
}