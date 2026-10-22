import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'package:ecommerce_new/entities/catalog/api/catalog_repository.dart';

final catalogRepositoryProvider = Provider(
  (ref) => CatalogRepository(ref.watch(shopApiProvider)),
);
final collectionsProvider = FutureProvider(
  (ref) => ref.watch(catalogRepositoryProvider).collections(),
);
final productProvider = FutureProvider.family<Json?, String>(
  (ref, slug) => ref.watch(catalogRepositoryProvider).product(slug),
);
final storeCollectionsProvider = FutureProvider.family<List<Json>, String>(
  (ref, token) => CatalogRepository(
    ref.watch(shopApiProvider),
    channelToken: token,
  ).collections(),
);
typedef StoreProductQuery = ({
  String channelToken,
  String? collectionId,
  String term,
  int skip,
});
final storeProductsProvider = FutureProvider.family<Json, StoreProductQuery>(
  (ref, query) => CatalogRepository(
    ref.watch(shopApiProvider),
    channelToken: query.channelToken,
  ).search(query.term, query.collectionId, query.skip),
);
typedef StoreProductDetail = ({String slug, String channelToken});
final storeProductProvider = FutureProvider.family<Json?, StoreProductDetail>(
  (ref, query) => CatalogRepository(
    ref.watch(shopApiProvider),
    channelToken: query.channelToken,
  ).product(query.slug),
);
