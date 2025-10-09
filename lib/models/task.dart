class Task {
  final String id;
  final String taskName;
  bool isDone;
  String? date;
  final List<Task> subTask;

  Task({ 
    required this.id, 
    required this.taskName, 
    this.isDone = false,
    this.date, 
    List<Task>? subTask
  }) : subTask = subTask ?? [];

  // check / uncheck task
  void toggleTask(){
    isDone = !isDone;
  }

  // tobble all subtasks
  void toggleAllSub(bool status){
    if (status){
      for (var sub in subTask){
        sub.isDone = true;
      }
    }
    else {
      for (var sub in subTask){
        sub.isDone = false;
      }
    }
  }

  // check all subtasks
  bool get areAllSubtaskIsDone => subTask.isNotEmpty && subTask.every((sub) => sub.isDone == true);

}