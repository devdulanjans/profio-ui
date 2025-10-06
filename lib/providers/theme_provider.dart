import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_theme.dart';


class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppTheme.lightTheme;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == AppTheme.darkTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> toggleTheme() async {
    if (_themeData == AppTheme.lightTheme) {
      _themeData = AppTheme.darkTheme;
    } else {
      _themeData = AppTheme.lightTheme;
    }
    notifyListeners();
    await _saveThemeToPrefs();
  }

  // Save theme mode in local storage
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", isDarkMode);
  }

  // Load theme mode from local storage
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDarkMode") ?? false;
    _themeData = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }
}
