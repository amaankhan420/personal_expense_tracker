import 'package:flutter/material.dart';

import '../data/shared_pref/user_settings.dart';

class UserSettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  UserSettingsProvider() {
    _loadThemePreference();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await UserSettings.saveThemePreference(_isDarkMode);
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    _isDarkMode = await UserSettings.getThemePreference();
    notifyListeners();
  }
}
