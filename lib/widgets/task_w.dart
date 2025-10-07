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
    // Stan rozszerzenia subtasków
    bool _isExpanded = false;
    // Stan widoczności pola tekstowego dla nowego subtaska
    bool _isAddingSubTask = false;
    // Kontroler pola tekstowego
    final TextEditingController _subTaskController = TextEditingController();

    // Stałe do obliczania wysokości subtasków (przybliżone wartości dla ListTile)
    static const double _subTaskHeight = 48.0; 
    static const double _addSubTaskHeight = 48.0; 
    
    @override
    void initState() {
        super.initState();
        // Zapewnienie, że jest rozwinięte, jeśli task ma już subtaski
        _isExpanded = widget.task.subTask.isNotEmpty;
    }

    // Korekta stanu: synchronizuje _isExpanded z danymi zewnętrznymi (np. Providerem)
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

    // Funkcja dodająca subtask
    void _addSubTask() {
        final subTaskName = _subTaskController.text.trim();
        if (subTaskName.isNotEmpty) {
            context.read<TaskProvider>().addSubTask(
                widget.categoryId,
                widget.task.id,
                subTaskName,
            );
            _subTaskController.clear();
            setState(() {
                _isAddingSubTask = false;
                _isExpanded = true; // Zawsze rozwiń po dodaniu
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
        // Obliczanie wysokości kontenera na podstawie stanu rozszerzenia
        final double containerHeight = _calculateHeight();

        return Column(
            children: [
                // GESTURE DETECTOR dla przełączania rozszerzenia
                GestureDetector(
                    onTap: _toggleExpansion,
                    child: ListTile(
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                        // Ukryto ikonę rozwijania - zostawiono tylko przycisk usuwania
                        trailing: IconButton(
                            icon: const Icon(Icons.close),
                            color: const Color.fromARGB(255, 126, 126, 126),
                            onPressed: () {
                                context.read<TaskProvider>().removeTask(widget.categoryId, widget.task.id);
                            }
                        ),
                    ),
                ),
                
                // ANIMOWANY KONTENER DLA EFEKTU ROZWIJANIA Z BOUNCE
                AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut, // Krzywa 'bounce'
                    height: containerHeight,
                    width: double.infinity, // Rozciągnij na całą szerokość
                    child: SingleChildScrollView( // Użyj SingleChildScrollView, aby zapobiec przepełnieniu
                        physics: const NeverScrollableScrollPhysics(), // Wyłącz przewijanie wewnątrz, ponieważ to jest kontrolowane przez animację
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 0, right: 0, bottom: 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // Lista istniejących subtasków
                                    ...widget.task.subTask.map((sub) {
                                        return ListTile(
                                            key: ValueKey(sub.id), // Dodajemy unikalny klucz dla lepszej wydajności listy
                                            minVerticalPadding: 0,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                            dense: true, // Zmniejsza wysokość, aby lepiej pasowała do _subTaskHeight = 48
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
                                    }).toList(),

                                    // Sekcja do dodawania nowego subtaska
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
                                                                        hintText: "Nazwa Subtaska",
                                                                        border: InputBorder.none,
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                                                                    ),
                                                                    onSubmitted: (_) => _addSubTask(),
                                                                ),
                                                            ),
                                                            IconButton(
                                                                icon: const Icon(Icons.check, color: Colors.green),
                                                                onPressed: _addSubTask,
                                                            ),
                                                            IconButton(
                                                                icon: const Icon(Icons.cancel, color: Colors.grey),
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
                                                        label: const Text("Dodaj Subtask"),
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
