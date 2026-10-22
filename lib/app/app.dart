import 'package:ecommerce_new/shared/i18n/phone_localizations.dart';
import 'package:ecommerce_new/app/router/app_router.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/shared/config/theme.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/i18n/tajik_localizations_delegates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(
      appRouterProvider,
    ); // ← теперь роутер из провайдера

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        ...phoneLocalizationsDelegates,
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        TajikMaterialLocalizationsDelegate(),
        TajikCupertinoLocalizationsDelegate(),
      ],
      routerConfig: router,
    );
  }
}
