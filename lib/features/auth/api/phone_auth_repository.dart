import 'package:http/http.dart' as http;
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/features/auth/model/phone_auth_flow.dart';

class PhoneAuthRepository {
  PhoneAuthRepository({http.Client? httpClient})
    : api = ShopApi(httpClient: httpClient);

  final ShopApi api;
  String? get capturedToken => api.capturedToken;

  static const _requestTelegramMutation = r'''
    mutation RequestTelegramVerification(
      $countryCode: String!
      $phoneNumber: String!
      $locale: String
    ) {
      requestTelegramVerification(
        countryCode: $countryCode
        phoneNumber: $phoneNumber
        locale: $locale
      ) {
        challengeId
        telegramUrl
        expiresAt
      }
    }
  ''';

  static const _requestWhatsAppMutation = r'''
    mutation RequestWhatsAppVerification(
      $countryCode: String!
      $phoneNumber: String!
      $locale: String
    ) {
      requestWhatsAppVerification(
        countryCode: $countryCode
        phoneNumber: $phoneNumber
        locale: $locale
      ) {
        challengeId
        expiresAt
      }
    }
  ''';

  static const _telegramStatusQuery = r'''
    query TelegramVerificationStatus($challengeId: String!) {
      telegramVerificationStatus(challengeId: $challengeId) {
        messageReceived
      }
    }
  ''';

  static const _confirmMutation = r'''
    mutation ConfirmCustomerPhoneVerification(
      $challengeId: String!
      $code: String!
    ) {
      confirmCustomerPhoneVerification(
        challengeId: $challengeId
        code: $code
      ) {
        id
        identifier
      }
    }
  ''';

  Future<PhoneVerificationChallenge> requestVerification({
    required String phoneNumber,
    required VerificationMethod method,
    required String locale,
  }) async {
    final field = method == VerificationMethod.telegram
        ? 'requestTelegramVerification'
        : 'requestWhatsAppVerification';
    final result = await api.execute(
      method == VerificationMethod.telegram
          ? _requestTelegramMutation
          : _requestWhatsAppMutation,
      {'countryCode': 'TJ', 'phoneNumber': phoneNumber, 'locale': locale},
      true,
      authenticated: false,
    );
    final data = result[field] as Json?;
    if (data == null) {
      throw const PhoneAuthException('EMPTY_RESPONSE', 'Empty auth response');
    }
    return PhoneVerificationChallenge(
      id: data['challengeId'] as String,
      method: method,
      telegramUrl: data['telegramUrl'] as String?,
    );
  }

  Future<bool> isTelegramMessageReceived(String challengeId) async {
    final result = await api.execute(
      _telegramStatusQuery,
      {'challengeId': challengeId},
      false,
      authenticated: false,
    );
    final data = result['telegramVerificationStatus'] as Json?;
    return data?['messageReceived'] == true;
  }

  Future<AuthUser> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    final result = await api.execute(
      _confirmMutation,
      {'challengeId': challengeId, 'code': code},
      true,
      authenticated: false,
    );
    final data = result['confirmCustomerPhoneVerification'] as Json?;
    if (data == null) {
      throw const PhoneAuthException('EMPTY_RESPONSE', 'Empty auth response');
    }
    return AuthUser(
      id: data['id'] as String,
      email: data['identifier'] as String,
    );
  }
}

class PhoneAuthException implements Exception {
  const PhoneAuthException(this.errorCode, this.message);
  final String errorCode, message;
  @override
  String toString() => message;
}
