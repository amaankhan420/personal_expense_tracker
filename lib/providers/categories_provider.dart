import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../data/shared_pref/categories.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await Categories.getCategories();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error loading categories',
      );
    }
  }

  Future<void> addCategory(String newCategory) async {
    try {
      _categories.add(newCategory);
      await Categories.saveCategories(_categories);
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error adding category',
      );
    }
  }

  Future<void> removeCategory(String category) async {
    try {
      _categories.remove(category);
      await Categories.saveCategories(_categories);
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error removing category',
      );
    }
  }

  Future<void> resetToDefault() async {
    try {
      _categories = await Categories.resetToDefault();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error resetting to default',
      );
    }
  }
}
