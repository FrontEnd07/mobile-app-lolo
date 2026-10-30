import 'dart:convert';

import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('retries with the channel default when selected currency is unavailable', () async {
    final urls = <Uri>[];
    final client = MockClient((request) async {
      urls.add(request.url);
      if (urls.length == 1) {
        return http.Response(
          jsonEncode({
            'errors': [
              {
                'message': 'The currency "TJS" is not available in the current Channel',
                'extensions': {'code': 'USER_INPUT_ERROR'},
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response(
        jsonEncode({
          'data': {
            'activeChannel': {
              'defaultCurrencyCode': 'USD',
              'availableCurrencyCodes': ['USD'],
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final result = await ShopApi(currency: 'TJS', httpClient: client).execute(
      'query { activeChannel { defaultCurrencyCode availableCurrencyCodes } }',
      const {},
      false,
      authenticated: false,
    );

    expect(result['activeChannel']['defaultCurrencyCode'], 'USD');
    expect(urls, hasLength(2));
    expect(urls.first.queryParameters['currencyCode'], 'TJS');
    expect(urls.last.queryParameters.containsKey('currencyCode'), isFalse);
  });
}
