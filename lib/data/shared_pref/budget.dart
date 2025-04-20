import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/budget_notification.dart';

class BudgetSharedPref {
  static const _budgetKey = 'monthly_budget';
  static const _overBudgetNotificationKey = 'over_budget_notification';
  static const _notifiedKey = 'notified';

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

  Future<void> setOverBudgetNotification(
    BudgetNotificationSetting setting,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_overBudgetNotificationKey, setting.name);
      if (setting != BudgetNotificationSetting.onlyOnce) {
        await prefs.remove(_notifiedKey);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error setting notification setting: $e\n$stack');
      }
    }
  }

  Future<BudgetNotificationSetting> getOverBudgetNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_overBudgetNotificationKey);
      debugPrint('Loaded notification setting from prefs: $value');
      return BudgetNotificationSetting.values.byName(value ?? 'always');
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error getting notification setting: $e\n$stack');
      }
      return BudgetNotificationSetting.never;
    }
  }

  Future<bool> wasNotified() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notifiedKey) ?? false;
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error checking notification status: $e\n$stack');
      }
      return false;
    }
  }

  Future<void> markAsNotified() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notifiedKey, true);
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error marking as notified: $e\n$stack');
      }
    }
  }

  Future<void> resetNotificationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notifiedKey);
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error resetting notification status: $e\n$stack');
      }
    }
  }
}
