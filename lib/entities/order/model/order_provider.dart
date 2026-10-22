import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'package:ecommerce_new/entities/order/api/order_repository.dart';

final orderRepositoryProvider = Provider(
  (ref) => OrderRepository(ref.watch(shopApiProvider)),
);
final orderHistoryOffsetProvider = StateProvider.autoDispose<int>((ref) => 0);
final orderHistoryProvider = FutureProvider.autoDispose(
  (ref) => ref
      .watch(orderRepositoryProvider)
      .orders(ref.watch(orderHistoryOffsetProvider)),
);
final orderDetailProvider = FutureProvider.autoDispose.family<Json?, String>(
  (ref, code) => ref.watch(orderRepositoryProvider).detail(code),
);
