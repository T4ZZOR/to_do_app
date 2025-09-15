import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_title_w.dart';

class TaskListW extends StatelessWidget{
  final String categoryId;
  const TaskListW({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().getTask(categoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategoria",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 117, 117, 117),
                    onPressed: (){
                      // TODO add edit category NAME, COLOR
                      }
                    ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 255, 131, 122),
                    onPressed: (){
                      // TODO add remove category function
                    } 
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, index) {
              return Card(
                color: Colors.greenAccent.withAlpha(80),
                 child: ListTile(
                 title:  TaskTitleW(task: tasks[index], categoryId: categoryId)
                 ),
              );
            }
          )
        )
      ],
    );
  }
}