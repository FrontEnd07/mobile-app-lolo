import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

class StoreRepository {
  StoreRepository(this.api);
  final ShopApi api;

  Future<Json> list({String search = ''}) => api
      .execute(
        r'''
      query Stores($options: MarketplaceStoreListOptions) {
        marketplaceStores(options: $options) {
          totalItems items { id name channels { id token } }
        }
      }
    ''',
        {
          'options': {'take': 100, 'search': search},
        },
        false,
        authenticated: false,
      )
      .then((data) => data['marketplaceStores'] as Json);
}
