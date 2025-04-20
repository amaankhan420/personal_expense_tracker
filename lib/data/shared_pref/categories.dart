import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/default_categories.dart';

class Categories {
  static const _key = 'expenseCategories';

  static final List<String> _defaultCategories = defaultCategories;

  static Future<void> saveCategories(List<String> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(categories));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving categories: $e');
      }
    }
  }

  static Future<List<String>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_key);

      if (data != null) {
        return List<String>.from(jsonDecode(data));
      } else {
        await saveCategories(_defaultCategories);
        return _defaultCategories;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting categories: $e');
      }
      return _defaultCategories;
    }
  }

  static Future<void> addCategory(String newCategory) async {
    try {
      final formatted = _capitalize(newCategory.trim());
      final categories = await getCategories();
      if (!categories.contains(formatted)) {
        categories.add(formatted);
        await saveCategories(categories);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error adding category: $e');
      }
    }
  }

  static Future<void> removeCategory(String category) async {
    try {
      final categories = await getCategories();
      categories.remove(category);
      await saveCategories(categories);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error removing category: $e');
      }
    }
  }

  static String _capitalize(String input) {
    try {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error capitalizing category: $e');
      }
      return input;
    }
  }

  static Future<List<String>> resetToDefault() async {
    try {
      final categories = List<String>.from(_defaultCategories);
      await saveCategories(categories);
      return categories;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error resetting to default: $e');
      }
      return _defaultCategories;
    }
  }
}
