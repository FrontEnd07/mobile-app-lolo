import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/pages/checkout/index.dart';
import 'package:ecommerce_new/features/checkout/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/i18n/phone_localizations.dart';
import 'package:ecommerce_new/shared/i18n/tajik_localizations_delegates.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'Invalid recipient form stays on address step without a request',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerAddressesProvider.overrideWith((ref) async => []),
            settingsStorageProvider.overrideWithValue(SettingsStorage(prefs)),
            checkoutOrderProvider.overrideWith(
              (ref) async => {
                'id': 'o1',
                'totalQuantity': 1,
                'currencyCode': 'TJS',
              },
            ),
            checkoutCountriesProvider.overrideWith(
              (ref) async => [
                {'code': 'TJ', 'name': 'Tajikistan'},
              ],
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...phoneLocalizationsDelegates,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              TajikMaterialLocalizationsDelegate(),
              TajikCupertinoLocalizationsDelegate(),
            ],
            home: const CheckoutPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('К доставке'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('К доставке'));
      await tester.pumpAndSettle();
      expect(find.text('Заполните поле'), findsWidgets);
      expect(find.text('2. Доставка'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
