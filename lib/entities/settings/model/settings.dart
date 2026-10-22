import 'package:flutter/material.dart';

@immutable
class Settings {
  const Settings({
    required this.locale,
    required this.currencyCode,
    required this.themeMode,
  });

  final Locale locale;
  final String currencyCode;
  final ThemeMode themeMode;

  Settings copyWith({
    Locale? locale,
    String? currencyCode,
    ThemeMode? themeMode,
  }) => Settings(
    locale: locale ?? this.locale,
    currencyCode: currencyCode ?? this.currencyCode,
    themeMode: themeMode ?? this.themeMode,
  );
}
