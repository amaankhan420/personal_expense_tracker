import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/databases/expense_db_helper.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    try {
      _expenses = await ExpenseDB().getAllExpenses();
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in fetchExpenses: $e\n$stack');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final id = await ExpenseDB().insertExpense(expense);
      _expenses.add(expense.copyWith(id: id));
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in addExpense: $e\n$stack');
    }
  }

  Future<void> updateExpense(String id, Expense updatedExpense) async {
    try {
      int updated = await ExpenseDB().updateExpense(updatedExpense);
      debugPrint("$updated affected");
      final index = _expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        _expenses = [..._expenses]..[index] = updatedExpense;
        notifyListeners();
      }
    } catch (e, stack) {
      debugPrint('Error in updateExpense: $e\n$stack');
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await ExpenseDB().deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in deleteExpense: $e\n$stack');
    }
  }

  double getTotalByCategory(String category) {
    try {
      return _expenses
          .where((e) => e.category == category)
          .fold(0.0, (sum, e) => sum + e.amount);
    } catch (e, stack) {
      debugPrint('Error in getTotalByCategory: $e\n$stack');
      return 0.0;
    }
  }

  double get totalSpent {
    try {
      return _expenses.fold(0.0, (sum, e) => sum + e.amount);
    } catch (e, stack) {
      debugPrint('Error in totalSpent: $e\n$stack');
      return 0.0;
    }
  }

  List<String> get usedCategories {
    try {
      return _expenses.map((e) => e.category).toSet().toList();
    } catch (e, stack) {
      debugPrint('Error in usedCategories: $e\n$stack');
      return [];
    }
  }

  Map<String, double> get categoryTotals {
    try {
      final Map<String, double> totals = {};
      for (var e in _expenses) {
        totals[e.category] = (totals[e.category] ?? 0) + e.amount;
      }
      return totals;
    } catch (e, stack) {
      debugPrint('Error in categoryTotals: $e\n$stack');
      return {};
    }
  }

  Map<DateTime, double> get dailyTotals {
    try {
      final Map<DateTime, double> totals = {};
      for (var e in _expenses) {
        final day = DateTime(e.date.year, e.date.month, e.date.day);
        totals[day] = (totals[day] ?? 0) + e.amount;
      }
      return Map.fromEntries(
        totals.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    } catch (e, stack) {
      debugPrint('Error in dailyTotals: $e\n$stack');
      return {};
    }
  }

  double get monthlySpent {
    try {
      final now = DateTime.now();
      final currentMonthExpenses =
          _expenses.where((e) {
            debugPrint(
              'Checking: ${e.date} => month: ${e.date.month}, year: ${e.date.year}',
            );
            return e.date.month == now.month && e.date.year == now.year;
          }).toList();

      final total = currentMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);

      debugPrint(
        'Monthly Spent: $total from ${currentMonthExpenses.length} expenses',
      );
      return total;
    } catch (e, stack) {
      debugPrint('Error in monthlySpent: $e\n$stack');
      return 0.0;
    }
  }

  Map<String, double> getMonthlyCategoryTotals() {
    try {
      final Map<String, double> monthlyTotals = {};
      final now = DateTime.now();

      for (var e in _expenses) {
        if (e.date.month == now.month && e.date.year == now.year) {
          monthlyTotals[e.category] =
              (monthlyTotals[e.category] ?? 0) + e.amount;
        }
      }

      return monthlyTotals;
    } catch (e, stack) {
      debugPrint('Error in getMonthlyCategoryTotals: $e\n$stack');
      return {};
    }
  }
}
