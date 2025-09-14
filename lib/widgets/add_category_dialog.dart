import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';

class AddCategoryDialog extends StatefulWidget{
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
  }

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text("add category"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "category name"),
      ),
      actions: [
        TextButton(
          onPressed: (){
            final name = _controller.text.trim();
            if (name.isNotEmpty){
              context.read<CategoryProvider>().addCategory(
                Category(
                  id: DateTime.now().toIso8601String(), 
                  name: name
                  )
                );
              Navigator.of(context).pop();
            }
          },
          child: const Text("add"),
        )
      ],
    );
  }
}