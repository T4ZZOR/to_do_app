import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../data/dummy_data.dart';

class TaskProvider extends ChangeNotifier{
  //final Map<String, List<Task>> _taskPerCategory = {};
  final Map<String, List<Task>> _taskPerCategory = dummyTasks;

  List<Task> getTask(String categoryId) => _taskPerCategory[categoryId] ?? [];

  // add task to category
  void addTask(String categoryId, String taskName){ // DateTime date // TODO add dateTime
    final taskId = DateTime.now().toIso8601String();
    //final taskDate = date;

    Task task = Task(id: taskId, taskName: taskName);

    _taskPerCategory.putIfAbsent(categoryId, () => []);
    _taskPerCategory[categoryId]!.add(task);
    notifyListeners();
  }

  // remove task and all subtasks
  void removeTask(String categoryId, String taskId){
    _taskPerCategory[categoryId]?.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void removeTaskFromCategory(String categoryId){
    _taskPerCategory.remove(categoryId);
    notifyListeners();
  }

  // add subTask to existing parentTask
  void addSubTask(String categoryId, String parentTaskId, String subTaskName){
    final Task? parentTask = _taskPerCategory[categoryId]
      ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

      final taskId = DateTime.now().toIso8601String();
      Task subTask = Task(id: taskId, taskName: subTaskName);
      if (parentTask != null){
        parentTask.subTask.add(subTask);
        notifyListeners();
      }
  }

  // void addSubTask(String categoryId, String parentTaskId, Task subTask){
  //   final Task? parentTask = _taskPerCategory[categoryId]
  //     ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

  //     if (parentTask != null){
  //       parentTask.subTask.add(subTask);
  //       notifyListeners();
  //     }
  // }
  
  // remove subTask
  void removeSubTask(String categoryId, String parentTaskId, Task subTask){
    final Task? parentTask = _taskPerCategory[categoryId]
      ?.firstWhere((parentTask) => parentTask.id == parentTaskId, orElse: () => Task(id: "", taskName: ""));

    if (parentTask != null){
      parentTask.subTask.remove(subTask);
      notifyListeners();
    }
  }
  // FIXME when sub task is on, toggle isDone and !isDone on main parentTask cause revert the subtasks
  // toggle task 
  void toggleTaskCheck(String categoryId, String taskId, {bool? done}){
    final task = _taskPerCategory[categoryId]
      ?.firstWhere((t) => t.id == taskId, orElse: () => Task(id: "", taskName: ""));

    if (task != null){
      task.isDone = done ?? !task.isDone;

      if (task.subTask.isNotEmpty){
        task.toggleAllSub(task.isDone);
      }
      notifyListeners();
    }
  }
  // FIXME all subtask do not check main task
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