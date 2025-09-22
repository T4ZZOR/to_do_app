import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../data/dummy_data.dart';
import '../providers/task_provider.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier{
  //final List<Category> _categories = [];
  final List<Category> _categories = dummyCategories;

  List<Category> get categories => _categories;

  void addCategory(Category category){
    _categories.add(category);
    notifyListeners();
  }

  void rmCategory(Category category){
    _categories.remove(category);
    notifyListeners();
  }

  void changeColor(Category category, Color color){
    category.color = color;
    notifyListeners();
  }

  void editCategory(Category category, String newCatName){
    final categoryIndex = _categories.indexWhere((cat) => cat.id == category.id);
    if (categoryIndex != -1){
      _categories[categoryIndex] = Category(
        id: category.id, 
        name: newCatName
      );
    }
    notifyListeners();
  }
}