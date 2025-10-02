import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../data/dummy_data.dart';

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

}