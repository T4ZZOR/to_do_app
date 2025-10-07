import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'package:to_do_app/models/task.dart';

// Zmieniamy na StatefulWidget, aby zarządzać stanem rozwijania i dodawania subtaska
class TaskTitleWAnimated extends StatefulWidget {
    final Task task;
    final String categoryId;

    const TaskTitleWAnimated({
        super.key,
        required this.task,
        required this.categoryId
    });

    @override
    State<TaskTitleWAnimated> createState() => _TaskTitleWState();
}

class _TaskTitleWState extends State<TaskTitleWAnimated> {
    bool _isExpanded = false;
    bool _isAddingSubTask = false;
    final TextEditingController _subTaskController = TextEditingController();

    static const double _subTaskHeight = 48.0; 
    static const double _addSubTaskHeight = 48.0; 
    
    @override
    void initState() {
        super.initState();
        _isExpanded = widget.task.subTask.isNotEmpty;
    }

    @override
    void didUpdateWidget(covariant TaskTitleWAnimated oldWidget) {
        super.didUpdateWidget(oldWidget);
        
        final hasSubTasks = widget.task.subTask.isNotEmpty;

        // Rozwijanie, jeśli pojawiły się subtaski i są niewidoczne
        if (hasSubTasks && !_isExpanded) {
            setState(() {
                _isExpanded = true;
            });
        } 
        // Zwijanie, jeśli wszystkie subtaski zostały usunięte
        else if (!hasSubTasks && _isExpanded) {
            setState(() {
                _isExpanded = false;
                _isAddingSubTask = false; // Ukryj pole dodawania przy zwijaniu
            });
        }
    }

    @override
    void dispose() {
        _subTaskController.dispose();
        super.dispose();
    }

    // Funkcja rozwijająca/zwijająca subtaski
    void _toggleExpansion() {
        setState(() {
            _isExpanded = !_isExpanded;
            // Ukryj pole dodawania przy zwijaniu
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

    // Oblicza wymaganą wysokość dla sekcji subtasków
    double _calculateHeight() {
        if (!_isExpanded) {
            return 0.01;
        }

        // Liczba istniejących subtasków
        final subTaskCount = widget.task.subTask.length;
        
        // Wysokość listy istniejących subtasków
        double height = subTaskCount * _subTaskHeight;
        
        // Dodaj wysokość dla pola do dodawania subtaska
        height += _addSubTaskHeight;

        // Dodatkowa mała przestrzeń na padding/marginesy
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
                              icon: const Icon(Icons.close),
                              color: const Color.fromARGB(255, 126, 126, 126),
                              onPressed: () {
                                  context.read<TaskProvider>().removeTask(widget.categoryId, widget.task.id);
                              }
                           ),
                          ],
                        )
                        // IconButton(
                        //     icon: const Icon(Icons.close),
                        //     color: const Color.fromARGB(255, 126, 126, 126),
                        //     onPressed: () {
                        //         context.read<TaskProvider>().removeTask(widget.categoryId, widget.task.id);
                        //     }
                        // ),
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
                                            key: ValueKey(sub.id), // Dodajemy unikalny klucz dla lepszej wydajności listy
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
