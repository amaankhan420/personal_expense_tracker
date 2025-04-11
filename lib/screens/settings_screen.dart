import 'package:flutter/material.dart';

import '../widgets/settings_screen/budget_tile.dart';
import '../widgets/settings_screen/theme_toggle_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(children: [BudgetTile(), Divider(), ThemeToggleTile()]),
    );
  }
}
