import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    try {
      _isDarkMode = !_isDarkMode;
      await UserSettings.saveThemePreference(_isDarkMode);
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error toggling theme',
      );
    }
  }

  Future<void> _loadThemePreference() async {
    try {
      _isDarkMode = await UserSettings.getThemePreference();
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'Error loading theme preference',
      );
    }
  }
}
