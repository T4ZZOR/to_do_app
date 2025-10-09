import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:to_do_app/models/task.dart';

class TaskTitleW extends StatefulWidget {
    final Task task;
    final String categoryId;

    const TaskTitleW({
        super.key,
        required this.task,
        required this.categoryId
    });

    @override
    State<TaskTitleW> createState() => _TaskTitleWState();
}

class _TaskTitleWState extends State<TaskTitleW> {
    bool _isExpanded = false;
    bool _isAddingSubTask = false;
    final TextEditingController _subTaskController = TextEditingController();

    static const double _subTaskHeight = 48.0; 
    static const double _addSubTaskHeight = 48.0; 
    
    @override
    void initState() {
        super.initState();
        //_isExpanded = widget.task.subTask.isNotEmpty; // expand all subtask while widget is loaded
    }

    @override
    void dispose() {
        _subTaskController.dispose();
        super.dispose();
    }

    // Expand subtasks
    void _toggleExpansion() {
        setState(() {
            _isExpanded = !_isExpanded;
            // hide addTask button
            if (!_isExpanded) {
                _isAddingSubTask = false;
            }
        });
    }

    void _addSubTask() {
        final subTaskName = _subTaskController.text.trim();
        if (subTaskName.isNotEmpty) {
            context.read<TaskProvider>().addSubTask(widget.categoryId, widget.task.id, subTaskName);
            _subTaskController.clear();
            setState(() {
                _isAddingSubTask = false;
                _isExpanded = true;
            });
        }
    }

    // Calculate subtask height
    double _calculateHeight() {
        if (!_isExpanded) {
            return 0.01;
        }

        // count of existing subtasks
        final subTaskCount = widget.task.subTask.length;
        
        // height subtask 
        double height = (subTaskCount * _subTaskHeight) + _addSubTaskHeight;

        // add margin 
        return height + 8.0; 
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                // Gestue detector to toggle on/off expand
                GestureDetector(
                    onTap: _toggleExpansion,
                    child: ListTile(
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        leading: Checkbox(
                            value: widget.task.isDone, onChanged: (_){
                                context.read<TaskProvider>().toggleTaskCheck(widget.categoryId, widget.task.id);
                            },
                        ),
                        title: Text(
                            widget.task.taskName,
                            style: TextStyle(
                                decoration: widget.task.isDone ? TextDecoration.lineThrough : null,
                            ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: widget.task.subTask.isNotEmpty
                                ? Text("${widget.task.subTask.where((s) => s.isDone).length}/${widget.task.subTask.length}")
                                : SizedBox.shrink()                  
                            ),
                            IconButton(
                                icon: const Icon(Icons.calendar_month),
                                color: Colors.white,
                                iconSize: 18,
                                onPressed: () {
                                    context.read<TaskProvider>().setDate(widget.categoryId, widget.task.id);
                              }
                            ),
                            IconButton(
                                icon: const Icon(Icons.close),
                                color: const Color.fromARGB(255, 126, 126, 126),
                                onPressed: () {
                                    context.read<TaskProvider>().removeTask(widget.categoryId, widget.task.id);
                              }
                           ),
                          ],
                        )
                    ),
                ),
                
                // animated container to add tasks
                AnimatedContainer(
                    duration: _isExpanded ? const Duration(milliseconds: 1000) : const Duration(milliseconds: 500) ,
                    curve: _isExpanded ? Curves.elasticOut : Curves.easeInOut, 
                    height: _calculateHeight().clamp(0.0, 1000.0),
                    width: double.infinity,
                    transform: Matrix4.translationValues(0, _isExpanded? 0 : 5, 0), 
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 0, right: 0, bottom: 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    ...widget.task.subTask.map((sub) {
                                        return ListTile(
                                            key: ValueKey(sub.id),
                                            minVerticalPadding: 0,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            dense: true,
                                            leading: Checkbox(
                                                value: sub.isDone, 
                                                onChanged: (_){
                                                    context.read<TaskProvider>().toggleSubTaskCheck(widget.categoryId, widget.task.id, sub.id);
                                                },
                                            ),
                                            title: Text(
                                                sub.taskName,
                                                style: TextStyle(
                                                    decoration: sub.isDone ? TextDecoration.lineThrough : null,
                                                ),
                                            ),
                                            trailing: IconButton(
                                                icon: const Icon(Icons.close, size: 18),
                                                color: const Color.fromARGB(255, 126, 126, 126),
                                                onPressed: () {
                                                    context.read<TaskProvider>().removeSubTask(widget.categoryId, widget.task.id, sub);
                                                }
                                            ),
                                        );
                                    }),

                                    // adding new task
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: SizedBox(
                                            height: _addSubTaskHeight,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: _isAddingSubTask
                                                    ? Row(
                                                        children: [
                                                            Expanded(
                                                                child: TextField(
                                                                    controller: _subTaskController,
                                                                    autofocus: true,
                                                                    decoration: const InputDecoration(
                                                                        hintText: "Sub task name",
                                                                        border: InputBorder.none,
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                                                                    ),
                                                                    onSubmitted: (_) => _addSubTask(),
                                                                ),
                                                            ),
                                                            IconButton(
                                                                icon: const Icon(Icons.check, color: Colors.white),
                                                                onPressed: _addSubTask,
                                                            ),
                                                            IconButton(
                                                                icon: const Icon(Icons.cancel, color: Colors.red),
                                                                onPressed: () {
                                                                    setState(() {
                                                                        _isAddingSubTask = false;
                                                                        _subTaskController.clear();
                                                                    });
                                                                },
                                                            ),
                                                        ],
                                                    )
                                                    : TextButton.icon(
                                                        icon: const Icon(Icons.add, size: 20),
                                                        label: const Text("add subtask"),
                                                        onPressed: () {
                                                            setState(() {
                                                                _isAddingSubTask = true;
                                                            });
                                                        },
                                                    ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ],
        );
    }
}
