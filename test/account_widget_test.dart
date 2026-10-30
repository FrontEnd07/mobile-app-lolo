import 'support/test_app.dart';

import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/pages/account/index.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:ecommerce_new/shared/model/paged_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SettingsStorage> storage() async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    return SettingsStorage(await SharedPreferences.getInstance());
  }

  testWidgets('Phone profile hides generated email and shows verified phone', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStorageProvider.overrideWithValue(await storage()),
          customerProfileProvider.overrideWith(
            (ref) async => {
              'id': 'c1',
              'firstName': 'Ali',
              'lastName': 'Test',
              'emailAddress': '+992917123456+noreply@phone-auth.local',
              'phoneNumber': '+992917123456',
            },
          ),
        ],
        child: const TestApp(home: ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('+992917123456'), findsOneWidget);
    expect(find.textContaining('@phone-auth.local'), findsNothing);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
  testWidgets('Empty history has no fabricated orders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStorageProvider.overrideWithValue(await storage()),
          orderHistoryProvider.overrideWith(
            (ref) =>
                PagedDataNotifier((_) async => {'totalItems': 0, 'items': []}),
          ),
        ],
        child: const TestApp(home: OrdersPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Missing or forbidden order shows no private data', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStorageProvider.overrideWithValue(await storage()),
          orderDetailProvider('OTHER').overrideWith((ref) async => null),
        ],
        child: const TestApp(home: OrderDetailPage(code: 'OTHER')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
