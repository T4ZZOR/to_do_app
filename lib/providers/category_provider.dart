import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier{
  final List<Category> _categories = [];
  
  List<Category> get categories => _categories;

  void addCategory(Category category){
    _categories.add(category);
    notifyListeners();
  }

  void rmCategory(Category category){
    _categories.remove(category);
    notifyListeners();
  }

}