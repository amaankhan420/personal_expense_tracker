import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetSharedPref {
  static const _budgetKey = 'monthly_budget';

  Future<void> setBudget(double limit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_budgetKey, limit);
    } catch (e, stack) {
      debugPrint('Error setting budget: $e\n$stack');
    }
  }

  Future<double?> getBudget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_budgetKey);
    } catch (e, stack) {
      debugPrint('Error getting budget: $e\n$stack');
      return null;
    }
  }

  Future<void> deleteBudget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_budgetKey);
    } catch (e, stack) {
      debugPrint('Error deleting budget: $e\n$stack');
    }
  }
}
