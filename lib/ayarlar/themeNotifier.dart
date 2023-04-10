import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkMode;

  ThemeNotifier(this._currentTheme, this._isDarkMode);

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    if (_isDarkMode) {
      _currentTheme = ThemeData.light();
      _isDarkMode = false;
    } else {
      _currentTheme = ThemeData.dark();
      _isDarkMode = true;
    }
    notifyListeners();
  }
}
