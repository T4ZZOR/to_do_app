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
  
  void removeSubTask(String categoryId, String parentTaskId, Task subTask){
    
  }


  void toggleTask(){}
  void tobbleSubTask(){}
}