import 'support/fake_shop_api.dart';

import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/features/checkout/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Shipping selection passes IDs as a list required by Vendure', () async {
    final api = FakeApi([
      {
        'setOrderShippingMethod': {
          '__typename': 'Order',
          'id': 'o1',
          'totalWithTax': 15000,
        },
      },
    ]);
    final result = await CheckoutRepository(api).shipping('s1');
    expect(api.calls.single['variables'], {
      'ids': ['s1'],
    });
    expect(result['totalWithTax'], 15000);
  });

  test('Address sends full international phone and country code', () async {
    final api = FakeApi([
      {
        'activeOrder': {'state': 'AddingItems'},
      },
      {
        'setOrderShippingAddress': {'__typename': 'Order', 'id': 'o1'},
      },
    ]);
    await CheckoutRepository(api).address({
      'countryCode': 'TJ',
      'phoneNumber': '+992917123456',
      'fullName': 'Test',
    });
    expect(api.calls.last['variables']['input']['countryCode'], 'TJ');
    expect(
      api.calls.last['variables']['input']['phoneNumber'],
      '+992917123456',
    );
  });

  test(
    'Payment transitions order before paying and uses selected method',
    () async {
      final api = FakeApi([
        {
          'activeOrder': {
            'id': 'o1',
            'state': 'AddingItems',
            'totalQuantity': 1,
          },
        },
        {
          'transitionOrderToState': {
            '__typename': 'Order',
            'state': 'ArrangingPayment',
          },
        },
        {
          'addPaymentToOrder': {
            '__typename': 'Order',
            'state': 'PaymentSettled',
            'code': 'TEST',
          },
        },
      ]);
      final result = await CheckoutRepository(api)
          .confirmTestOrder('test-payment');
      expect(api.calls[1]['variables'], {'state': 'ArrangingPayment'});
      expect(api.calls[2]['variables']['input']['method'], 'test-payment');
      expect(result['code'], 'TEST');
    },
  );

  test('Transition failure prevents payment request', () async {
    final api = FakeApi([
      {
        'activeOrder': {'state': 'AddingItems', 'totalQuantity': 1},
      },
      {
        'transitionOrderToState': {
          '__typename': 'OrderStateTransitionError',
          'errorCode': 'ORDER_STATE_TRANSITION_ERROR',
        },
      },
    ]);
    await expectLater(
      CheckoutRepository(api).confirmTestOrder('test'),
      throwsA(isA<ApiException>()),
    );
    expect(api.calls, hasLength(2));
  });

  test('Empty active order cannot submit payment', () async {
    final api = FakeApi([
      {'activeOrder': null},
    ]);
    await expectLater(
      CheckoutRepository(api).confirmTestOrder('test'),
      throwsA(isA<ApiException>()),
    );
    expect(api.calls, hasLength(1));
  });
  test('Changed total blocks payment before transition', () async {
    final api = FakeApi([
      {
        'activeOrder': {
          'id': 'o1',
          'totalWithTax': 20000,
          'totalQuantity': 1,
          'state': 'AddingItems',
        },
      },
    ]);
    await expectLater(
      CheckoutRepository(api).confirmTestOrder(
        'test',
        reviewedOrder: {'id': 'o1', 'totalWithTax': 10000, 'totalQuantity': 1},
      ),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'ORDER_CHANGED'),
      ),
    );
    expect(api.calls, hasLength(1));
  });

  test(
    'Substituted variant with same quantity and total requires a new review',
    () async {
      final api = FakeApi([
        {
          'activeOrder': {
            'id': 'o1',
            'totalWithTax': 10000,
            'totalQuantity': 1,
            'state': 'AddingItems',
            'lines': [
              {
                'productVariant': {'id': 'new'},
                'quantity': 1,
                'linePriceWithTax': 10000,
              },
            ],
          },
        },
      ]);
      await expectLater(
        CheckoutRepository(api).confirmTestOrder(
          'test',
          reviewedOrder: {
            'id': 'o1',
            'totalWithTax': 10000,
            'totalQuantity': 1,
            'lines': [
              {
                'productVariant': {'id': 'old'},
                'quantity': 1,
                'linePriceWithTax': 10000,
              },
            ],
          },
        ),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'ORDER_CHANGED'),
        ),
      );
      expect(api.calls, hasLength(1));
    },
  );
}
