import 'package:ecommerce_new/features/browse_catalog/index.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/shared/model/paged_data.dart';
import 'package:ecommerce_new/app/app.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:ecommerce_new/shared/ui/branding/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> mount(
  WidgetTester tester, {
  bool fail = false,
  bool empty = false,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsStorageProvider.overrideWithValue(SettingsStorage(prefs)),
        collectionsProvider.overrideWith((ref) async => []),
        catalogProvider.overrideWith(
          (ref) => PagedDataNotifier((_) async {
            if (fail) throw StateError('Offline');
            return {
              'totalItems': empty ? 0 : 1,
              'items': empty
                  ? []
                  : [
                      {
                        'productId': '1',
                        'productName': 'Test phone',
                        'slug': 'test-phone',
                        'currencyCode': 'TJS',
                        'productAsset': null,
                        'priceWithTax': {'value': 12345},
                      },
                    ],
            };
          }),
        ),
        productProvider('test-phone').overrideWith(
          (ref) async => {
            'name': 'Test phone',
            'description': '<p>Phone description</p>',
            'assets': [],
            'variants': [
              {
                'id': 'v1',
                'name': 'Black',
                'priceWithTax': 12345,
                'currencyCode': 'TJS',
                'stockLevel': 'IN_STOCK',
              },
              {
                'id': 'v2',
                'name': 'White',
                'priceWithTax': 15000,
                'currencyCode': 'TJS',
                'stockLevel': 'OUT_OF_STOCK',
              },
            ],
          },
        ),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('Vendure prices use minor units and server currency', () {
    expect(formatPrice(12345, 'TJS', 'en'), contains('123.45'));
    expect(formatPrice(12345, 'TJS', 'en'), contains('TJS'));
  });
  testWidgets('Catalog opens product and changes selected variant', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await mount(tester);
    expect(find.byType(AppLogo), findsOneWidget);
    await tester.tap(find.text('Test phone'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(SelectableText),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.byType(SelectableText), findsOneWidget);
    await tester.ensureVisible(find.text('White'));
    await tester.tap(find.text('White'));
    await tester.pumpAndSettle();
    expect(find.textContaining('150'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(2));
  });
  testWidgets('Offline catalog offers retry', (tester) async {
    await mount(tester, fail: true);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(GridView), findsNothing);
  });
  testWidgets('Empty search shows no product cards', (tester) async {
    await mount(tester, empty: true);
    expect(find.byType(Card), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
