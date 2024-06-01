import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'themeMode'; // changed key to accommodate more than boolean

  void _saveThemeToBox(String themeMode) => _box.write(_key, themeMode);

  String _loadThemeFromBox() => _box.read(_key) ?? 'System';

  ThemeMode get theme {
    String themeMode = _loadThemeFromBox();
    switch (themeMode) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void switchTheme(String themeMode) {
    ThemeMode mode;
    switch (themeMode) {
      case 'Light':
        mode = ThemeMode.light;
        break;
      case 'Dark':
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
        break;
    }
    Get.changeThemeMode(mode);
    _saveThemeToBox(themeMode);
  }
}
