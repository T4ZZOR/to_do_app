import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryTabBarW extends StatelessWidget implements PreferredSizeWidget{
  final List<Category> categories;
  final TabController controller;

  const CategoryTabBarW({
    super.key,
    required this.categories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 4,
          color: categories[controller.index].color,
        ),
      ),
      tabs: List.generate(categories.length, (index) {
        final isSelected = controller.index == index;
        final category = categories[index];

        return Tab(
          child: Text(
            category.name,
            style: TextStyle(
              color: isSelected ? category.color : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}