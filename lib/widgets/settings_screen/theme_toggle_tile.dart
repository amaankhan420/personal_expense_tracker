import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return ListTile(
      title: const Text("Theme"),
      subtitle: Text(isDark ? "Dark" : "Light"),
      trailing: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      onTap: () => themeProvider.toggleTheme(),
    );
  }
}
