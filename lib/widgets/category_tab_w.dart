import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryTabW extends StatelessWidget{
  final Category category;
  const CategoryTabW({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(category.icon),
      text: category.name,
    );
  }
}