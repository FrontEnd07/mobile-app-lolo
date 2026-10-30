import 'package:vendure/vendure.dart';
import 'package:ecommerce_new/shared/config/env.dart';

class VendureClient {
  VendureClient._();

  static Future<void> initialize({
    required String languageCode,
    String? token,
  }) async {
    if (token != null && token.isNotEmpty) {
      // Токен есть — создаём клиент СРАЗУ с заголовком Authorization
      await Vendure.initializeWithCustomAuth(
        endpoint: Env.vendureEndpoint,
        channelToken: Env.channelToken,
        languageCode: languageCode,
        tokenParams: {'token': token},
        fetchToken: (params) async => params['token'] as String,
      );
    } else {
      // Гостевой режим
      await Vendure.initialize(
        endpoint: Env.vendureEndpoint,
        channelToken: Env.channelToken,
        languageCode: languageCode,
        useVendureGuestSession: true,
      );
    }
  }

  static Future<void> setAuthToken(String token) async {
    Vendure.setAuthToken(token);
  }

  static void clearAuthToken() => Vendure.setAuthToken('');
  static Vendure get instance => Vendure.instance;
}
