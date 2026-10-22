import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter не содержит встроенных переводов Material/Cupertino
/// для таджикского языка (tg). Эти делегаты подменяют tg на ru
/// для служебных элементов (диалоги, датапикеры, тултипы и т.п.).
/// Пользовательские строки при этом остаются таджикскими — они
/// берутся из нашего AppLocalizations (ARB-файлы).

class TajikMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const TajikMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tg';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('ru'));

  @override
  bool shouldReload(_) => false;
}

class TajikCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const TajikCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tg';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('ru'));

  @override
  bool shouldReload(_) => false;
}
