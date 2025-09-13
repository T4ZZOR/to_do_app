import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier{
  final Map<String, List<Task>> _taskPerCategory = {};

  List<Task> getTask(String categoryId) => _taskPerCategory[categoryId] ?? [];

  // add task to category
  void addTask(String categoryId, Task task){
    _taskPerCategory.putIfAbsent(categoryId, () => []);
    _taskPerCategory[categoryId]!.add(task);
    notifyListeners();
  }

  // remove task and all subtasks
  void removeTask(String categoryId, String taskId){
    _taskPerCategory[categoryId]?.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // add subTask to existing parentTask
  void addSubTask(String categoryId, String parentTaskId, Task subTask){
    final Task? parentTask = _taskPerCategory[categoryId]
      ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

      if (parentTask != null){
        parentTask.subTask.add(subTask);
        notifyListeners();
      }
  }
  
  // remove subTask
  void removeSubTask(String categoryId, String parentTaskId, Task subTask){
    final Task? parentTask = _taskPerCategory[categoryId]
      ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

    if (parentTask != null){
      parentTask.subTask.remove(subTask);
      notifyListeners();
    }
  }

  // toggle task 
  void toggleTaskCheck(String categoryId, String taskId, {bool? done}){
    final task = _taskPerCategory[categoryId]
      ?.firstWhere((t) => t.id == taskId, orElse: () => Task(id: "", taskName: ""));

    if (task != null){
      task.isDone = done ?? task.isDone;

      if (task.subTask.isNotEmpty){
        task.toggleAllSub(task.isDone);
      }
      notifyListeners();
    }
  }

  // toggle subTask 
  void toggleSubTaskCheck(String categoryId, String parentTaskId, String subTaskId, {bool? done}){
    final Task? parentTask = _taskPerCategory[categoryId]
      ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

    if (parentTask != null){
      final subTask = parentTask.subTask
        .firstWhere((st) => st.id == subTaskId, orElse: () => Task(id: "", taskName: ""));

      if (parentTask.subTask.isNotEmpty){
        subTask.isDone = done ?? !subTask.isDone;

        if (parentTask.areAllSubtaskIsDone){
          parentTask.isDone = true;
        }
        notifyListeners();
      }  
    }
  }
}