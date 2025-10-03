import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/task_provider.dart';

import '../providers/category_provider.dart';

class AddTaskW extends StatefulWidget{
  final String categoryId;
  const AddTaskW({super.key, required this.categoryId});

  @override
  State<AddTaskW> createState() => _AddTaskWState();
}

class _AddTaskWState extends State<AddTaskW>{
  final TextEditingController _controller = TextEditingController();
  bool _isAdding = false;

  void _addTask(){
    final text = _controller.text.trim();
    if (text.isNotEmpty){
      context.read<TaskProvider>().addTask(widget.categoryId, text);

      setState(() {
        _isAdding = false;
        _controller.clear();
      });
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final category = context.watch<CategoryProvider>().categories.firstWhere((cat) => cat.id == widget.categoryId);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation){
        return SizeTransition(sizeFactor: animation, child: child);
      },
      child: _isAdding ? 
      Padding(
        key: const ValueKey("input"),
        padding: const EdgeInsets.only(left: 32.0, top: 8.0, right: 16.0, bottom: 0.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: "Enter new task"),
                onSubmitted: (_) => _addTask(),
              )
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _addTask, 
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                setState(() {
                  _isAdding = false;
                  _controller.clear();
                });
              }, 
            )
          ],
        ),
      )
      : 
      Align(
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.add_circle, size: 40, color: category.color),
          onPressed: (){
            setState(() {
              _isAdding = true;
            });
          }, 
        )
      )
    );
  }
}