enum BudgetNotificationSetting {
  always,
  never,
  onlyOnce;

  String get displayText {
    switch (this) {
      case BudgetNotificationSetting.always:
        return 'Always notify';
      case BudgetNotificationSetting.onlyOnce:
        return 'Notify once';
      case BudgetNotificationSetting.never:
        return 'Never notify';
    }
  }
}
