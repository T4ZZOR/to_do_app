import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/task_list_w.dart';

class TaskListPage extends StatelessWidget{
  final String categoryId;

  const TaskListPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context){
    return TaskListW(categoryId: categoryId);
  }
}