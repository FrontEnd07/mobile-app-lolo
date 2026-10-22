import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:ecommerce_new/entities/settings/model/settings.dart';

/// Переопределяется в main() через overrideWithValue.
final settingsStorageProvider = Provider<SettingsStorage>(
  (ref) => throw UnimplementedError('settingsStorageProvider не настроен'),
);

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(ref.watch(settingsStorageProvider)),
);

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._storage) : super(_fromStorage(_storage));

  final SettingsStorage _storage;

  static Settings _fromStorage(SettingsStorage s) => Settings(
    locale: Locale(s.language),
    currencyCode: s.currency,
    themeMode: s.themeMode,
  );

  Future<void> setLanguage(String code) async {
    await _storage.setLanguage(code);
    state = state.copyWith(locale: Locale(code));
  }

  Future<void> setCurrency(String code) async {
    await _storage.setCurrency(code);
    state = state.copyWith(currencyCode: code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }
}
