import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_title_w.dart';
import '../widgets/cateory_head_w.dart';

class TaskListW extends StatelessWidget{
  final String categoryId;
  const TaskListW({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().getTask(categoryId);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        return Card(
          color: Colors.greenAccent.withAlpha(80),
          child: ListTile(
          title:  TaskTitleW(task: tasks[index], categoryId: categoryId)
          ),
        );
      }
    );
  }
}