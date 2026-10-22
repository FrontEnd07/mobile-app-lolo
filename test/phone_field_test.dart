import 'package:ecommerce_new/shared/i18n/phone_localizations.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/i18n/tajik_localizations_delegates.dart';
import 'package:ecommerce_new/shared/ui/inputs/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    PhoneController controller,
    GlobalKey<FormState> key, {
    String language = 'ru',
    ValueChanged<String>? submitted,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(language),
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
        home: Scaffold(
          body: Form(
            key: key,
            child: PhoneField(controller: controller, onSubmitted: submitted),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Empty and incomplete mobile numbers fail validation', (
    tester,
  ) async {
    final controller = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
    );
    addTearDown(controller.dispose);
    final key = GlobalKey<FormState>();
    await mount(tester, controller, key);
    expect(key.currentState!.validate(), isFalse);
    await tester.enterText(find.byType(EditableText), '12');
    expect(key.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('National TJ number submits full international phone', (
    tester,
  ) async {
    final controller = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
    );
    addTearDown(controller.dispose);
    String? submitted;
    final key = GlobalKey<FormState>();
    await mount(
      tester,
      controller,
      key,
      submitted: (value) => submitted = value,
    );
    await tester.enterText(find.byType(EditableText), '917123456');
    expect(key.currentState!.validate(), isTrue);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, '+992917123456');
  });

  testWidgets(
    'Pasted international number changes country without duplicated prefix',
    (tester) async {
      final controller = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
      );
      addTearDown(controller.dispose);
      final key = GlobalKey<FormState>();
      await mount(tester, controller, key);
      await tester.enterText(find.byType(EditableText), '+7 912 345 67 89');
      await tester.pumpAndSettle();
      expect(controller.value.isoCode, IsoCode.RU);
      expect(controller.value.international, '+79123456789');
      expect(key.currentState!.validate(), isTrue);
    },
  );

  testWidgets('Phone field works with Tajik app locale', (tester) async {
    final controller = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
    );
    addTearDown(controller.dispose);
    await mount(tester, controller, GlobalKey<FormState>(), language: 'tg');
    expect(find.byType(PhoneFormField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Country picker opens in Tajik locale and selects Russia', (
    tester,
  ) async {
    final controller = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
    );
    addTearDown(controller.dispose);
    await mount(tester, controller, GlobalKey<FormState>(), language: 'tg');
    await tester.tap(find.byType(CountryButton));
    await tester.pumpAndSettle();
    expect(find.text('Россия'), findsWidgets);
    await tester.tap(find.text('Россия').first);
    await tester.pumpAndSettle();
    expect(controller.value.isoCode, IsoCode.RU);
    expect(tester.takeException(), isNull);
  });
}
