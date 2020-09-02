import 'package:flutter/material.dart';
import 'package:recipe_library/config.dart';

class Theme with ChangeNotifier {
  static bool _isDark = true;

  Theme() {
    if (prefs.containsKey("currentTheme")) {
      _isDark = prefs.get("currentTheme");
    } else {
      prefs.setBool("currentTheme", _isDark);
    }
  }

  bool isDark() {
    return _isDark;
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    prefs.setBool("currentTheme", _isDark);
    notifyListeners();
  }
}
