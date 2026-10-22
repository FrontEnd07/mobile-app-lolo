import 'support/test_app.dart';
import 'support/fake_auth_storage.dart';
import 'support/sample_order.dart';

import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/pages/cart/index.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'dart:convert';

import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/shared/storage/settings_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestCart extends CartNotifier {
  TestCart([Json? order]) : order = order ?? sampleOrder;
  final Json? order;
  final operations = <String>[];
  @override
  Future<Json?> build() async => order;
  @override
  Future<void> change(String operation, String id, [int? quantity]) async {
    operations.add('$operation:$id:$quantity');
    if (operation == 'removeOrderLine') {
      state = const AsyncData(null);
    }
  }
}

void main() {
  test('Cart follows the selected currency', () async {
    var calls = 0;
    final repository = CartRepository(
      ShopApi(
        currency: 'RUB',
        readToken: TestStorage('session').readToken,
        createHttpClient: () => MockClient((request) async {
          calls++;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          if (calls == 1) {
            return http.Response(
              jsonEncode({
                'data': {'activeOrder': sampleOrder},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(body['variables'], {'currency': 'RUB'});
          expect(body['query'], contains('setCurrencyCodeForOrder'));
          return http.Response(
            jsonEncode({
              'data': {
                'setCurrencyCodeForOrder': {
                  '__typename': 'Order',
                  ...sampleOrder,
                  'currencyCode': 'RUB',
                },
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      ),
    );

    final order = await repository.load();

    expect(order?['currencyCode'], 'RUB');
    expect(calls, 2);
  });

  test('Cart sends stored bearer token and variant ID to backend', () async {
    final repository = CartRepository(
      ShopApi(
        readToken: TestStorage('session').readToken,
        createHttpClient: () => MockClient((request) async {
          expect(request.headers['authorization'], 'Bearer session');
          final body = jsonDecode(request.body);
          expect(body['variables'], {'id': 'v1', 'quantity': 1});
          expect(body['query'], contains('productVariantId:'));
          return http.Response(
            jsonEncode({
              'data': {
                '__typename': 'Mutation',
                'addItemToOrder': {'__typename': 'Order', ...sampleOrder},
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      ),
    );
    final result = await repository.update('addItemToOrder', {
      'id': 'v1',
      'quantity': 1,
    });
    expect(result['totalQuantity'], 2);
  });

  test('Stock error stays an error rather than an updated order', () async {
    final repository = CartRepository(
      ShopApi(
        readToken: TestStorage('session').readToken,
        createHttpClient: () => MockClient(
          (_) async => http.Response(
            jsonEncode({
              'data': {
                '__typename': 'Mutation',
                'adjustOrderLine': {
                  '__typename': 'InsufficientStockError',
                  'errorCode': 'INSUFFICIENT_STOCK_ERROR',
                  'message': 'Stock',
                },
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      ),
    );
    await expectLater(
      repository.update('adjustOrderLine', {'id': 'l1', 'quantity': 100}),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'INSUFFICIENT_STOCK_ERROR',
        ),
      ),
    );
  });

  test('Missing login fails before sending a cart request', () async {
    final repository = CartRepository(
      ShopApi(
        readToken: TestStorage(null).readToken,
        createHttpClient: () => throw StateError('Must not send'),
      ),
    );
    await expectLater(
      repository.load(),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'LOGIN_REQUIRED'),
      ),
    );
  });

  testWidgets(
    'Cart quantity controls use order line ID and removal empties cart',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cart = TestCart();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsStorageProvider.overrideWithValue(SettingsStorage(prefs)),
            cartProvider.overrideWith(() => cart),
          ],
          child: const TestApp(home: CartPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test phone'), findsOneWidget);
      expect(find.textContaining('246'), findsWidgets);
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();
      expect(cart.operations, contains('adjustOrderLine:l1:3'));
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      expect(find.text('Корзина пока пуста'), findsOneWidget);
    },
  );

  testWidgets('Each quantity control targets its own cart line', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final order = {
      ...sampleOrder,
      'lines': [
        ...List<Json>.from(sampleOrder['lines'] as List),
        {
          'id': 'l2',
          'quantity': 1,
          'linePriceWithTax': 100,
          'productVariant': {
            'id': 'v2',
            'name': 'Second phone',
            'product': {'slug': 'second-phone', 'featuredAsset': null},
          },
        },
      ],
    };
    final secondCart = TestCart(order);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsStorageProvider.overrideWithValue(SettingsStorage(prefs)),
          cartProvider.overrideWith(() => secondCart),
        ],
        child: const TestApp(home: CartPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('cart-increase-l2')));
    await tester.pumpAndSettle();

    expect(secondCart.operations, ['adjustOrderLine:l2:2']);
  });
}
