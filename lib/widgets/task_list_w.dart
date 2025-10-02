import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_title_w.dart';

class TaskListW extends StatelessWidget{
  final String categoryId;
  const TaskListW({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().getTask(categoryId);
    final category = context.watch<CategoryProvider>().categories.firstWhere((cat) => cat.id == categoryId);
    
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        return Card(
          color: category.color.withAlpha(150),
          child: ListTile(
            title:  TaskTitleW(task: tasks[index], categoryId: categoryId)
          ),
        );
      }
    );
  }
}