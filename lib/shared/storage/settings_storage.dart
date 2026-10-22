import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_new/shared/config/constants.dart';

/// Хранилище пользовательских настроек (язык, валюта, тема).
class SettingsStorage {
  SettingsStorage(this._prefs);

  final SharedPreferences _prefs;

  String get language =>
      _prefs.getString(AppConstants.keyLanguage) ??
      AppConstants.defaultLanguage;

  Future<void> setLanguage(String value) =>
      _prefs.setString(AppConstants.keyLanguage, value);

  String get currency {
    final saved = _prefs.getString(AppConstants.keyCurrency);
    return AppConstants.supportedCurrencies.contains(saved)
        ? saved!
        : AppConstants.defaultCurrency;
  }

  Future<void> setCurrency(String value) =>
      _prefs.setString(AppConstants.keyCurrency, value);

  ThemeMode get themeMode {
    final raw = _prefs.getString(AppConstants.keyTheme) ?? 'system';
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(AppConstants.keyTheme, mode.name);
}
