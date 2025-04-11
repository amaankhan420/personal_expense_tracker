import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static const _themeKey = 'isDarkMode';

  static Future<void> saveThemePreference(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDarkMode);
    } catch (e, stack) {
      debugPrint('Error saving theme preference: $e$stack');
    }
  }

  static Future<bool> getThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themeKey) ?? false;
    } catch (e, stack) {
      debugPrint('Error getting theme preference: $e$stack');
      return false;
    }
  }
}
