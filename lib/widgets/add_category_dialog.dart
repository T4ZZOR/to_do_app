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
  String? _errorText;

  // check _controller if is not empty - remove error message
  @override
  void initState(){
    super.initState();

    _controller.addListener((){
      if (_errorText != null && _controller.text.trim().isNotEmpty){
      setState(() {
        _errorText = null;
      });
    }
    });
  }
  
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text("add category"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "category name",
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("cancel")),
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
            else { 
              setState(() {
                _errorText = "this field is required";
              });
            }
          },
          child: const Text("add"),
        )
      ],
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
}