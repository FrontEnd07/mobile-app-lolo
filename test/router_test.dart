import 'package:ecommerce_new/app/app.dart';
import 'package:ecommerce_new/app/router/app_router.dart';
import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/features/browse_catalog/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/model/paged_data.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_auth_storage.dart';
import 'support/test_app.dart';

class TestSession extends AuthNotifier {
  TestSession() : super(TestStorage(null));
  void signIn() => state = const AuthState(
    user: AuthUser(id: 'user1', email: 'test@example.com'),
    isInitialized: true,
  );
}

void main() {
  test(
    'Login destinations cannot navigate to external or unknown locations',
    () {
      expect(loginDestination('https://example.com'), '/');
      expect(loginDestination('//example.com'), '/');
      expect(loginDestination('/unknown'), '/');
      expect(loginDestination('/orders/ABC'), '/orders/ABC');
    },
  );
  testWidgets(
    'Login refresh preserves router identity and returns to requested order',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = SettingsStorage(await SharedPreferences.getInstance());
      final session = TestSession();
      final container = ProviderContainer(
        overrides: [
          settingsStorageProvider.overrideWithValue(storage),
          authProvider.overrideWith((ref) => session),
          collectionsProvider.overrideWith((ref) async => []),
          catalogProvider.overrideWith(
            (ref) =>
                PagedDataNotifier((_) async => {'totalItems': 0, 'items': []}),
          ),
          orderDetailProvider('ABC').overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();
      final router = container.read(appRouterProvider);
      router.go('/orders/ABC');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/login');
      session.signIn();
      await tester.pumpAndSettle();
      expect(container.read(appRouterProvider), same(router));
      expect(router.routeInformationProvider.value.uri.path, '/orders/ABC');
    },
  );

  testWidgets('Profile login opens on top of home and back pops to home', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            appBar: AppBar(actions: const [AuthAvatar()]),
            body: const Text('Home'),
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (_, _) => Scaffold(
            appBar: AppBar(leading: const AppBackButton()),
            body: const Text('Login'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authProvider.overrideWith((ref) => TestSession())],
        child: TestApp.router(router),
      ),
    );
    await tester.pumpAndSettle();

    final l = AppLocalizations.of(tester.element(find.byType(Scaffold)));
    final loginButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.person_outline),
    );
    expect(loginButton.tooltip, l.loginTitle);
    loginButton.onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(router.canPop(), isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('Unknown route uses localized page and standard back', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = SettingsStorage(await SharedPreferences.getInstance());
    final container = ProviderContainer(
      overrides: [
        settingsStorageProvider.overrideWithValue(storage),
        authProvider.overrideWith((ref) => TestSession()),
        collectionsProvider.overrideWith((ref) async => []),
        catalogProvider.overrideWith(
          (ref) =>
              PagedDataNotifier((_) async => {'totalItems': 0, 'items': []}),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();

    final router = container.read(appRouterProvider);
    router.push('/missing-page');
    await tester.pumpAndSettle();

    final l = AppLocalizations.of(tester.element(find.byType(Scaffold).last));
    expect(find.text(l.pageNotFoundTitle), findsNWidgets(2));
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(router.canPop(), isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text(l.pageNotFoundTitle), findsNothing);
    expect(router.canPop(), isFalse);
  });
}
