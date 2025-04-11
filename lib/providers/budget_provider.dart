import 'package:flutter/foundation.dart';

import '../data/shared_pref/budget_shared_pref.dart';

class BudgetProvider with ChangeNotifier {
  double? _monthlyBudget;

  double? get monthlyBudget => _monthlyBudget;

  Future<void> fetchBudget() async {
    try {
      final budget = await BudgetSharedPref().getBudget();
      _monthlyBudget = budget;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in fetchBudget: $e\n$stack');
    }
  }

  Future<void> setBudget(double limit) async {
    try {
      await BudgetSharedPref().setBudget(limit);
      _monthlyBudget = limit;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in setBudget: $e\n$stack');
    }
  }

  Future<void> deleteBudget() async {
    try {
      await BudgetSharedPref().deleteBudget();
      _monthlyBudget = null;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in deleteBudget: $e\n$stack');
    }
  }

  double get limit {
    try {
      return _monthlyBudget ?? 0.0;
    } catch (e, stack) {
      debugPrint('Error in limit getter: $e\n$stack');
      return 0.0;
    }
  }

  double remaining(double totalExpense) {
    try {
      return limit - totalExpense;
    } catch (e, stack) {
      debugPrint('Error in remaining: $e\n$stack');
      return 0.0;
    }
  }

  bool isOverBudget(double totalExpense) {
    try {
      return totalExpense > limit;
    } catch (e, stack) {
      debugPrint('Error in isOverBudget: $e\n$stack');
      return false;
    }
  }
}
