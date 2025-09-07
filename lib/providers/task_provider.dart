import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

class TaskProvider with ChangeNotifier{
  Map<String, List<Task>> _taskPerCategory = {};

  // add task
  void addTask(String category, Task task){
    _taskPerCategory.putIfAbsent(category, () => []); // if task not exist, creates new category
    _taskPerCategory[category]!.add(task); // put task into category
    notifyListeners(); // send to frontend to update UI
  }

  // change task to "done"
  void toggleTask(String category, String taskId, {bool? done}){
    // find task from category
    final task = _taskPerCategory[category]!.firstWhere((t) => t.id == taskId);

    if (task != null){
      task.isDone = done ?? !task.isDone; // change state task as toggle true/false, null/false/true

      // if task has subtasks. change all subtasks to "done"
      if (task.subTask.isNotEmpty){
        task.toggleAllSubTasks(task.isDone);
      }
      notifyListeners();
    }
  }

  void toggleSubTask(String subCategory, String suTaskId, {bool? done}){

  }

  // void removeTask(String category, Task task){

  // }
}