import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryTabW extends StatelessWidget{
  final Category category;
  const CategoryTabW({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // TODO add colors to Tabs
    return Tab(
      //icon: Icon(category.icon),
      text: category.name,
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: category.color, // kolor zakładki
//           borderRadius: BorderRadius.circular(16), // zaokrąglone krawędzie
//         ),
//         child: Text(
//           category.name,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }