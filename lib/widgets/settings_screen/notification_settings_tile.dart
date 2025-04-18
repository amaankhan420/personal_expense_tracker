import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/budget_notification.dart';
import '../../providers/budget_provider.dart';

class NotificationSettingTile extends StatelessWidget {
  const NotificationSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: true);

    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Budget Alert'),
      trailing: DropdownButton<BudgetNotificationSetting>(
        value: budgetProvider.notificationSetting,
        underline: Container(),
        items:
            BudgetNotificationSetting.values.map((setting) {
              return DropdownMenuItem<BudgetNotificationSetting>(
                value: setting,
                child: Text(
                  setting.displayText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
        onChanged: (newSetting) {
          if (newSetting != null) {
            budgetProvider.setNotificationSetting(newSetting);
          }
        },
      ),
    );
  }
}
