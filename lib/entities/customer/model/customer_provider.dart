import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';

import 'package:ecommerce_new/entities/customer/api/customer_repository.dart';

final customerRepositoryProvider = Provider(
  (ref) => CustomerRepository(ref.watch(shopApiProvider)),
);
final customerProfileProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(customerRepositoryProvider).customer(),
);
