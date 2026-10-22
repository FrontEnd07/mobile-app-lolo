import 'package:ecommerce_new/shared/i18n/app_localizations_en.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_shop_api.dart';

class DeniedApi extends ShopApi {
  DeniedApi() : super();
  @override
  Future<Json> execute(
    String document,
    Json variables,
    bool mutation, {
    bool authenticated = true,
    String? channelToken,
  }) async => throw const ApiException('ACCESS_DENIED');
}

void main() {
  test(
    'History uses pagination, newest first, and excludes active carts',
    () async {
      final api = FakeApi([
        {
          'activeCustomer': {
            'orders': {'totalItems': 11, 'items': []},
          },
        },
      ]);
      final history = await OrderRepository(api).orders(10);
      expect(history!['totalItems'], 11);
      expect(api.calls.single['variables'], {'skip': 10});
      expect(api.calls.single['document'], contains('createdAt: DESC'));
      expect(api.calls.single['document'], contains('active: { eq: false }'));
    },
  );
  test(
    'Profile update trims names and does not change verified phone',
    () async {
      final api = FakeApi([
        {
          'updateCustomer': {
            'id': 'c1',
            'firstName': 'Ali',
            'lastName': 'Test',
          },
        },
      ]);
      await CustomerRepository(api).updateNames(' Ali ', ' Test ');
      expect(api.calls.single['variables'], {
        'input': {'firstName': 'Ali', 'lastName': 'Test'},
      });
    },
  );
  test('Order detail passes code as a variable', () async {
    final api = FakeApi([
      {
        'orderByCode': {'code': 'ABC'},
      },
    ]);
    final order = await OrderRepository(api).detail('ABC');
    expect(api.calls.single['variables'], {'code': 'ABC'});
    expect(order!['code'], 'ABC');
  });
  test('Forbidden order is unavailable rather than a retry loop', () async {
    expect(await OrderRepository(DeniedApi()).detail('OTHER'), isNull);
  });
  test(
    'Unknown states remain visible and authorization is not called paid',
    () {
      expect(
        orderStatus('PaymentAuthorized', AppLocalizationsEn()),
        'Payment authorized',
      );
      expect(orderStatus('CustomState', AppLocalizationsEn()), 'CustomState');
      expect(
        isGeneratedPhoneEmail('+992917123456+noreply@phone-auth.local'),
        isTrue,
      );
      expect(isGeneratedPhoneEmail('buyer@example.com'), isFalse);
    },
  );
}
