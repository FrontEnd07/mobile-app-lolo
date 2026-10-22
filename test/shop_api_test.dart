import 'dart:convert';

import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class TrackingClient extends MockClient {
  TrackingClient(super.handler);
  bool closed = false;
  @override
  void close() {
    closed = true;
    super.close();
  }
}

void main() {
  test(
    'Transport closes owned clients after failures without replaying mutation',
    () async {
      var calls = 0;
      final client = TrackingClient((_) async {
        calls++;
        throw http.ClientException('Lost response');
      });
      final api = ShopApi(
        readToken: () async => 'session',
        createHttpClient: () => client,
      );
      await expectLater(
        api.execute('mutation { logout { success } }', {}, true),
        throwsA(isA<ApiException>()),
      );
      expect(calls, 1);
      expect(client.closed, isTrue);
    },
  );
  test('Transport leaves injected client ownership to caller', () async {
    final client = TrackingClient((request) async {
      expect(request.url.queryParameters['currencyCode'], 'TJS');
      return http.Response(
        jsonEncode({
          'data': {'__typename': 'Query', 'ok': true},
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    addTearDown(client.close);
    final api = ShopApi(httpClient: client);
    final data = await api.execute(
      'query { __typename }',
      {},
      false,
      authenticated: false,
    );
    expect(data['ok'], isTrue);
    expect(client.closed, isFalse);
  });
  test('Forbidden response is distinguished from transport failure', () async {
    final api = ShopApi(
      readToken: () async => 'session',
      createHttpClient: () => MockClient(
        (_) async => http.Response(
          jsonEncode({
            'errors': [
              {
                'message': 'Forbidden',
                'extensions': {'code': 'FORBIDDEN'},
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );
    await expectLater(
      api.execute('query { activeCustomer { id } }', {}, false),
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'ACCESS_DENIED'),
      ),
    );
  });

  test('Selected currency is sent to Vendure', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['currencyCode'], 'RUB');
      return http.Response(
        jsonEncode({
          'data': {'__typename': 'Query'},
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    addTearDown(client.close);
    await ShopApi(
      currency: 'RUB',
      httpClient: client,
    ).execute('query { __typename }', {}, false, authenticated: false);
  });
}
