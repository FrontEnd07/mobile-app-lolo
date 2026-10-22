import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import '../api/store_repository.dart';

final storeRepositoryProvider = Provider(
  (ref) => StoreRepository(ref.watch(shopApiProvider)),
);
final storesProvider = FutureProvider<Json>(
  (ref) => ref.watch(storeRepositoryProvider).list(),
);
