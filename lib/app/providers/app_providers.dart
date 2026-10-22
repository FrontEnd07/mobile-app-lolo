import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/features/auth/index.dart';

final appProviderOverrides = [
  shopApiProvider.overrideWith((ref) {
    final userId = ref.watch(authProvider.select((state) => state.user?.id));
    return ShopApi(
      language: ref.watch(
        settingsProvider.select((state) => state.locale.languageCode),
      ),
      currency: ref.watch(
        settingsProvider.select((state) => state.currencyCode),
      ),
      isAuthenticated: userId != null,
      readToken: ref.watch(authStorageProvider).readToken,
    );
  }),
];
