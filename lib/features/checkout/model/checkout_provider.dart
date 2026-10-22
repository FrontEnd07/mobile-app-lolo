import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';

import 'package:ecommerce_new/features/checkout/api/checkout_repository.dart';

final checkoutRepositoryProvider = Provider(
  (ref) => CheckoutRepository(ref.watch(shopApiProvider)),
);
final checkoutOrderProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(checkoutRepositoryProvider).order(),
);
final checkoutCountriesProvider = customerCountriesProvider;
