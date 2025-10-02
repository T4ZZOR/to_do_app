import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/widgets/add_task_w.dart';
import 'package:to_do_app/widgets/cateory_head_w.dart';
import 'package:to_do_app/widgets/task_list_w.dart';

class TaskListPage extends StatelessWidget{
  final String categoryId;

  const TaskListPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context){
    final tasks = context.watch<TaskProvider>().getTask(categoryId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CateoryHeadW(categoryId: categoryId),
        Expanded(child: TaskListW(categoryId: categoryId))
      ],
    );
  }
}