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

  void removeTask(String categoryId, String taskId){
    _taskPerCategory[categoryId]?.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void addSubTask(){}
  
  void removeSubTask(){}
}