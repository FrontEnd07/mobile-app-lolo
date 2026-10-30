import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final channelCurrenciesProvider = FutureProvider<List<String>>((ref) async {
  final data = await ref
      .watch(shopApiProvider)
      .execute(
        'query { activeChannel { defaultCurrencyCode availableCurrencyCodes } }',
        const {},
        false,
        authenticated: false,
      );
  final channel = data['activeChannel'] as Map<String, dynamic>;
  final currencies = List<String>.from(channel['availableCurrencyCodes']);
  if (currencies.isNotEmpty) return currencies;
  return [channel['defaultCurrencyCode'] as String];
});
