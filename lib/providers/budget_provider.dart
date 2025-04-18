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
      debugPrint('Error in fetchBudget: $e\n$stack');
    }
  }

  Future<void> _fetchNotificationSetting() async {
    try {
      _notificationSetting =
          await BudgetSharedPref().getOverBudgetNotification();
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error fetching notification setting: $e\n$stack');
    }
  }

  Future<void> setBudget(double limit) async {
    try {
      if (monthlyBudget == limit) return;
      await BudgetSharedPref().setBudget(limit);
      _monthlyBudget = limit;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error in setBudget: $e\n$stack');
    }
  }

  Future<void> setNotificationSetting(BudgetNotificationSetting setting) async {
    try {
      await BudgetSharedPref().setOverBudgetNotification(setting);
      _notificationSetting = setting;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error setting notification setting: $e\n$stack');
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

  Future<bool> shouldNotify() async {
    try {
      final sharedPref = BudgetSharedPref();
      final setting = await sharedPref.getOverBudgetNotification();

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
      debugPrint('Error in shouldNotify: $e\n$stack');
      return false;
    }
  }

  Future<void> resetNotificationStatus() async {
    try {
      await BudgetSharedPref().resetNotificationStatus();
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error resetting notification status: $e\n$stack');
    }
  }
}
