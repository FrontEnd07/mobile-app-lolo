import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/model/paged_data.dart';

import 'package:ecommerce_new/entities/order/api/order_repository.dart';

final orderRepositoryProvider = Provider(
  (ref) => OrderRepository(ref.watch(shopApiProvider)),
);
final orderHistoryProvider =
    StateNotifierProvider.autoDispose<
      PagedDataNotifier,
      AsyncValue<PagedData?>
    >((ref) {
      final repository = ref.watch(orderRepositoryProvider);
      return PagedDataNotifier(repository.orders);
    });
final orderDetailProvider = FutureProvider.autoDispose.family<Json?, String>(
  (ref, code) => ref.watch(orderRepositoryProvider).detail(code),
);
