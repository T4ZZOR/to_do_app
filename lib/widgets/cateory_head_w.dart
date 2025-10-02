import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/category_provider.dart';
import '../providers/task_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:to_do_app/constans/colors.dart';

class CateoryHeadW extends StatefulWidget{
  final String categoryId;
  const CateoryHeadW({super.key, required this.categoryId});

  @override
  State<CateoryHeadW> createState() => _CategoryHeadWState();
}

class _CategoryHeadWState extends State<CateoryHeadW> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

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
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();
    final taskProvider = context.read<TaskProvider>();
    final category = categoryProvider.categories.firstWhere((c) => c.id == widget.categoryId);
    final String catName = category.name;

    return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                catName,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.palette),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 117, 117, 117),
                    onPressed: (){
                      Color pickerColor = category.color;
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Pick categoy color'),
                          content: SingleChildScrollView(
                            child: BlockPicker( 
                              pickerColor: pickerColor,
                              availableColors: categoryColors, // colors are definied in constans/colors.dart
                              onColorChanged: (color) { pickerColor = color; }
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<CategoryProvider>().changeColor(category, pickerColor);
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("Select"),
                            ),
                          ],
                        )
                      );                     
                    }
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 117, 117, 117),
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: (ctx) {
                          // clear dialog
                          _controller.clear();
                          _errorText = null;

                          // dynamically show allert
                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              _controller.addListener(() {
                                if (_errorText != null && _controller.text.trim().isNotEmpty) {
                                  setStateDialog(() {
                                    _errorText = null;
                                  });
                                }
                              });
                              // show dialog
                              return AlertDialog(
                                title: const Text("Put new category name"),
                                content: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "new category name",
                                    errorText: _errorText,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final newCatName = _controller.text.trim();
                                      if (newCatName.isNotEmpty) {
                                        categoryProvider.editCategory(category, newCatName);
                                        Navigator.of(context).pop();
                                      } else {
                                        setStateDialog(() {
                                          _errorText = "this field is required";
                                        });
                                      }
                                    },
                                    child: const Text("change"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      );
                    }
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 255, 131, 122),
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: (ctx) => AlertDialog(
                          title: Text("remove category: $catName"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("cancel")),
                            TextButton(onPressed: (){
                              taskProvider.removeTaskFromCategory(widget.categoryId);
                              categoryProvider.rmCategory(category);
                              Navigator.pop(ctx);
                            },
                            style: TextButton.styleFrom(foregroundColor: Color.fromARGB(255, 255, 131, 122)),
                            child: const Text("remove"))
                          ],
                        )
                      );
                    } 
                  ),
                ],
              )
            ],
          ),
    );
  }
}

                        // builder: (ctx) => AlertDialog(
                        //   title: const Text("Put new category name"),
                        //   content: TextField(
                        //     controller: _controller,
                        //     decoration: InputDecoration(
                        //       hintText: "new category name",
                        //       errorText: _errorText,
                        //     ),
                        //   ),
                        //   actions: [
                        //     TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("cancel")),
                        //     TextButton(
                        //      onPressed: (){
                        //        final newCatName = _controller.text.trim();
                        //        if (newCatName.isNotEmpty){
                        //          categoryProvider.editCategory(category, newCatName);
                        //          Navigator.of(context).pop();
                        //        }
                        //        else { 
                        //          setState(() {
                        //            _errorText = "this field is required"; //FIXME czasem dziala czasem nie (o.o)
                        //          });
                        //        }
                        //      },
                        //      child: const Text("change"),
                        //     )
                        //   ],
                        // )

// class CateoryHeadW extends StatelessWidget{
//   final String categoryId;
//   const CateoryHeadW({super.key, required this.categoryId});
  
  

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = context.read<CategoryProvider>();
//     final taskProvider = context.read<TaskProvider>();
//     final category = categoryProvider.categories.firstWhere((c) => c.id == categoryId);
//     final String catName = category.name;
//     final TextEditingController controller = TextEditingController();
//     String? _errorText;
//     return Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 catName,
//                 style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     iconSize: 20,
//                     color: const Color.fromARGB(255, 117, 117, 117),
//                     onPressed: (){
//                       showDialog(
//                         context: context, 
//                         builder: (ctx) => AlertDialog(
//                           title: const Text("Put new category name"),
//                           content: TextField(
//                             controller: controller,
//                           ),
//                           actions: [

//                           ],
//                         )
//                         );
//                       }
//                     ),
//                   IconButton(
//                     icon: Icon(Icons.delete),
//                     iconSize: 20,
//                     color: const Color.fromARGB(255, 255, 131, 122),
//                     onPressed: (){
//                       showDialog(
//                         context: context, 
//                         builder: (ctx) => AlertDialog(
//                           title: Text("remove category: $catName"),
//                           actions: [
//                             TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("cancel")),
//                             TextButton(onPressed: (){
//                               taskProvider.removeTaskFromCategory(categoryId);
//                               categoryProvider.rmCategory(category);
//                               Navigator.pop(ctx);
//                             },
//                             style: TextButton.styleFrom(foregroundColor: Color.fromARGB(255, 255, 131, 122)),
//                             child: const Text("remove"))
//                           ],
//                         )
//                       );
//                     } 
//                   ),
//                 ],
//               )
//             ],
//           ),
//     );
//   }
// }