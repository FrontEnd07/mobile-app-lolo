import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'support/test_app.dart';

void main() {
  GoRouter createRouter(String initial) => GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('Home')),
      ),
      GoRoute(
        path: '/detail',
        builder: (_, _) => Scaffold(
          appBar: AppBar(leading: const AppBackButton()),
          body: const Text('Detail'),
        ),
      ),
    ],
  );
  testWidgets('Back is visible on directly opened route and goes to parent', (
    tester,
  ) async {
    final router = createRouter('/detail');
    addTearDown(router.dispose);
    await tester.pumpWidget(TestApp.router(router, locale: const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Back'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/');
  });
  testWidgets('Back pops existing navigation history', (tester) async {
    final router = createRouter('/');
    addTearDown(router.dispose);
    await tester.pumpWidget(TestApp.router(router));
    await tester.pumpAndSettle();
    router.push('/detail');
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/');
    expect(router.canPop(), isFalse);
  });
  test('Every application language has all ARB keys', () {
    Set<String> keys(String lang) =>
        (jsonDecode(File('l10n/app_$lang.arb').readAsStringSync())
                as Map<String, dynamic>)
            .keys
            .where((key) => !key.startsWith('@'))
            .toSet();
    expect(keys('en'), keys('ru'));
    expect(keys('tg'), keys('ru'));
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      expect(
        file.readAsStringSync(),
        isNot(contains('localizedText(')),
        reason: file.path,
      );
    }
  });
}
