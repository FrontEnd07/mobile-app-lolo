import 'package:ecommerce_new/app/app.dart';
import 'package:ecommerce_new/app/router/app_router.dart';
import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/features/browse_catalog/index.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_auth_storage.dart';

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
            (ref) async => {'totalItems': 0, 'items': []},
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
}
