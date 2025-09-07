class Task {
  final String id;
  final String title;
  bool isDone;
  DateTime? dateTime;
  final List<Task> subTask;

  Task({
    required this.id, 
    required this.title, 
    this.isDone = false,
    this.dateTime,
    this.subTask = const [],
    });

    // check all sub task to: done
    void toggleAllSubTasks(bool done){
      for (var sub in subTask){
        sub.isDone = done;
      }
    }

    // check all sub task 
    bool get areAllSubTaskDone => subTask.isNotEmpty && subTask.every((sub) => sub.isDone);
}