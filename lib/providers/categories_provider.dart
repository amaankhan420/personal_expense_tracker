import 'package:flutter/material.dart';

import '../data/shared_pref/categories.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _categories = await Categories.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(String newCategory) async {
    _categories.add(newCategory);
    await Categories.saveCategories(_categories);
    notifyListeners();
  }

  Future<void> removeCategory(String category) async {
    _categories.remove(category);
    await Categories.saveCategories(_categories);
    notifyListeners();
  }

  Future<void> resetToDefault() async {
    _categories = await Categories.resetToDefault();
    notifyListeners();
  }
}
