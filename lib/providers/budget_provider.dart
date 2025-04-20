import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../constant/budget_notification.dart';
import '../data/shared_pref/budget.dart';

class BudgetProvider with ChangeNotifier {
  double? _monthlyBudget;
  BudgetNotificationSetting _notificationSetting =
      BudgetNotificationSetting.always;

  double? get monthlyBudget => _monthlyBudget;

  BudgetNotificationSetting get notificationSetting => _notificationSetting;

  Future<void> fetchAllSettings() async {
    await _fetchBudget();
    await _fetchNotificationSetting();
  }

  Future<void> _fetchBudget() async {
    try {
      final budget = await BudgetSharedPref().getBudget();
      _monthlyBudget = budget;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Failed to fetch budget",
      );
    }
  }

  Future<void> _fetchNotificationSetting() async {
    try {
      _notificationSetting =
          await BudgetSharedPref().getOverBudgetNotification();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Failed to set fetch notification setting",
      );
    }
  }

  Future<void> setBudget(double limit) async {
    try {
      if (monthlyBudget == limit) return;
      await BudgetSharedPref().setBudget(limit);
      _monthlyBudget = limit;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Failed to set budget",
      );
    }
  }

  Future<void> setNotificationSetting(BudgetNotificationSetting setting) async {
    try {
      await BudgetSharedPref().setOverBudgetNotification(setting);
      _notificationSetting = setting;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Failed to set notification setting",
      );
    }
  }

  Future<void> deleteBudget() async {
    try {
      await BudgetSharedPref().deleteBudget();
      _monthlyBudget = null;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Failed to delete budget",
      );
    }
  }

  double get limit {
    try {
      return _monthlyBudget ?? 0.0;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Unable to get limit",
      );
      return 0.0;
    }
  }

  double remaining(double totalExpense) {
    try {
      return limit - totalExpense;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Unable to find remaining budget",
      );
      return 0.0;
    }
  }

  bool isOverBudget(double totalExpense) {
    try {
      return totalExpense > limit;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Unable to find if user is over budget",
      );
      return false;
    }
  }

  Future<bool> shouldNotify({
    DateTime? expenseDate,
    required double monthlySpent,
  }) async {
    try {
      final sharedPref = BudgetSharedPref();
      final setting = await sharedPref.getOverBudgetNotification();

      if (_monthlyBudget == null || _monthlyBudget! <= 0) {
        return false;
      }

      if (expenseDate != null) {
        final now = DateTime.now();
        final isCurrentMonth =
            expenseDate.year == now.year && expenseDate.month == now.month;
        if (!isCurrentMonth) {
          return false;
        }
      }

      if (!isOverBudget(monthlySpent)) {
        return false;
      }

      switch (setting) {
        case BudgetNotificationSetting.never:
          return false;
        case BudgetNotificationSetting.always:
          return true;
        case BudgetNotificationSetting.onlyOnce:
          final wasNotified = await sharedPref.wasNotified();
          if (!wasNotified) {
            await sharedPref.markAsNotified();
            return true;
          }
          return false;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Unable to determine if notification should be sent",
      );
      return false;
    }
  }

  Future<void> resetNotificationStatus() async {
    try {
      await BudgetSharedPref().resetNotificationStatus();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Unable to reset notification status",
      );
    }
  }
}
