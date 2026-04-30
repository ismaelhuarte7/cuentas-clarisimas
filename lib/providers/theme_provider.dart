import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum AppThemeMode { old, promiedos }

class ThemeProvider extends ChangeNotifier {
  static const String _boxKey = 'theme_mode';
  static Box? _box;
  
  AppThemeMode _themeMode = AppThemeMode.old;

  AppThemeMode get themeMode => _themeMode;

  Future<void> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox('settings');
    }
  }

  Future<void> loadTheme() async {
    await _getBox();
    final saved = _box!.get(_boxKey, defaultValue: 0);
    _themeMode = AppThemeMode.values[saved];
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await _getBox();
    _themeMode = mode;
    await _box!.put(_boxKey, mode.index);
    notifyListeners();
  }

  Future<void> cycleTheme() async {
    final nextIndex = (_themeMode.index + 1) % AppThemeMode.values.length;
    await setTheme(AppThemeMode.values[nextIndex]);
  }

  String get themeLabel {
    switch (_themeMode) {
      case AppThemeMode.old:
        return 'modo old';
      case AppThemeMode.promiedos:
        return 'modo promiedos';
    }
  }
}