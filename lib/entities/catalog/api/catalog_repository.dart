import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

class CatalogRepository {
  CatalogRepository(this.api, {this.channelToken});
  final ShopApi api;
  final String? channelToken;
  Future<Json> query(String document, [Json variables = const {}]) =>
      api.execute(
        document,
        variables,
        false,
        authenticated: false,
        channelToken: channelToken,
      );

  Future<List<Json>> collections() async {
    final data = await query(r"""
      query { collections(options: { filter: { parentId: { eq: "1" } }, take: 100 }) {
        items { id name slug }
      } }
    """);
    return List<Json>.from(data['collections']['items']);
  }

  Future<Json> search(String term, String? collectionId, int skip) async {
    final data = await query(
      r"""
      query Catalog($input: SearchInput!) {
        search(input: $input) { totalItems items {
          productId productName slug currencyCode productAsset { preview }
          marketplaceStores { id name channelToken }
          priceWithTax { ... on SinglePrice { value } ... on PriceRange { min max } }
        } }
      }
    """,
      {
        'input': {
          'term': term,
          'groupByProduct': true,
          'take': 20,
          'skip': skip,
          'collectionId': ?collectionId,
        },
      },
    );
    return data['search'] as Json;
  }

  Future<Json?> product(String slug) async {
    final data = await query(
      r"""
      query Product($slug: String!) {
        product(slug: $slug) { id name description assets { preview }
          marketplaceStores { id name channelToken }
          variants { id name sku priceWithTax currencyCode stockLevel }
        }
      }
    """,
      {'slug': slug},
    );
    return data['product'] as Json?;
  }
}
