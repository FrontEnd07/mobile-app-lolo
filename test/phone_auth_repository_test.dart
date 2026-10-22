import 'dart:convert';

import 'package:ecommerce_new/features/auth/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('WhatsApp request sends the current storefront locale', () async {
    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['query'], contains('requestWhatsAppVerification'));
      expect(body['variables'], {
        'countryCode': 'TJ',
        'phoneNumber': '+992929090904',
        'locale': 'tg',
      });
      return http.Response(
        jsonEncode({
          'data': {
            'requestWhatsAppVerification': {
              'challengeId': 'challenge-1',
              'expiresAt': '2026-10-21T12:00:00.000Z',
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    addTearDown(client.close);

    final challenge = await PhoneAuthRepository(httpClient: client)
        .requestVerification(
          phoneNumber: '+992929090904',
          method: VerificationMethod.whatsapp,
          locale: 'tg',
        );

    expect(challenge.id, 'challenge-1');
    expect(challenge.method, VerificationMethod.whatsapp);
  });

  test('Telegram request keeps the deep link returned by the server', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({
          'data': {
            'requestTelegramVerification': {
              'challengeId': 'challenge-2',
              'telegramUrl': 'https://t.me/example_bot?start=VERIFY_CODE',
              'expiresAt': '2026-10-21T12:00:00.000Z',
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    addTearDown(client.close);

    final challenge = await PhoneAuthRepository(httpClient: client)
        .requestVerification(
          phoneNumber: '+992929090904',
          method: VerificationMethod.telegram,
          locale: 'ru',
        );

    expect(challenge.telegramUrl, contains('t.me/example_bot'));
  });

  test('OTP confirmation captures the Vendure session token', () async {
    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['query'], contains('confirmCustomerPhoneVerification'));
      expect(body['variables'], {
        'challengeId': 'challenge-1',
        'code': '123456',
      });
      return http.Response(
        jsonEncode({
          'data': {
            'confirmCustomerPhoneVerification': {
              'id': '14',
              'identifier': 'test-user',
            },
          },
        }),
        200,
        headers: {
          'content-type': 'application/json',
          'vendure-auth-token': 'test-session',
        },
      );
    });
    addTearDown(client.close);
    final repository = PhoneAuthRepository(httpClient: client);

    final user = await repository.verifyOtp(
      challengeId: 'challenge-1',
      code: '123456',
    );

    expect(user.id, '14');
    expect(repository.capturedToken, 'test-session');
  });
}
