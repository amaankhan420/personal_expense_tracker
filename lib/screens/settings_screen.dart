import 'package:flutter/material.dart';

import '../widgets/settings_screen/budget_tile.dart';
import '../widgets/settings_screen/notification_settings_tile.dart';
import '../widgets/settings_screen/theme_toggle_tile.dart';
import 'manage_categories_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          BudgetTile(),
          Divider(),
          NotificationSettingTile(),
          Divider(),
          ThemeToggleTile(),
          Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
