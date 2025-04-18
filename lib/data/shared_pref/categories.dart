import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/default_categories.dart';

class Categories {
  static const _key = 'expenseCategories';

  static final List<String> _defaultCategories = defaultCategories;

  static Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(categories));
  }

  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data != null) {
      return List<String>.from(jsonDecode(data));
    } else {
      await saveCategories(_defaultCategories);
      return _defaultCategories;
    }
  }

  static Future<void> addCategory(String newCategory) async {
    final formatted = _capitalize(newCategory.trim());
    final categories = await getCategories();
    if (!categories.contains(formatted)) {
      categories.add(formatted);
      await saveCategories(categories);
    }
  }

  static Future<void> removeCategory(String category) async {
    final categories = await getCategories();
    categories.remove(category);
    await saveCategories(categories);
  }

  static String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static Future<List<String>> resetToDefault() async {
    final categories = List<String>.from(_defaultCategories);
    await saveCategories(categories);
    return categories;
  }
}
