import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/i18n/phone_localizations.dart';
import 'package:ecommerce_new/shared/i18n/tajik_localizations_delegates.dart';

class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required Widget this.home,
    this.locale = const Locale('ru'),
  }) : router = null;
  const TestApp.router(
    this.router, {
    super.key,
    this.locale = const Locale('ru'),
  }) : home = null;
  final Widget? home;
  final GoRouter? router;
  final Locale locale;
  @override
  Widget build(BuildContext context) {
    final delegates = <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      ...phoneLocalizationsDelegates,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      TajikMaterialLocalizationsDelegate(),
      TajikCupertinoLocalizationsDelegate(),
    ];
    return router == null
        ? MaterialApp(
            home: home,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: delegates,
          )
        : MaterialApp.router(
            routerConfig: router,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: delegates,
          );
  }
}
