import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'package:ecommerce_new/entities/order/api/cart_repository.dart';

final cartRepositoryProvider = Provider(
  (ref) => CartRepository(ref.watch(shopApiProvider)),
);
final cartProvider = AsyncNotifierProvider<CartNotifier, Json?>(
  CartNotifier.new,
);
final cartBusyProvider = StateProvider<bool>((ref) => false);

class CartNotifier extends AsyncNotifier<Json?> {
  bool _disposed = false;
  int _generation = 0;
  @override
  Future<Json?> build() async {
    _disposed = false;
    _generation++;
    ref.onDispose(() => _disposed = true);
    final authenticated = ref.watch(shopApiProvider).isAuthenticated;
    final repository = ref.watch(cartRepositoryProvider);
    if (!authenticated) return null;
    return repository.load();
  }

  Future<void> change(String operation, String id, [int? quantity]) async {
    if (ref.read(cartBusyProvider)) {
      throw const ApiException('OPERATION_IN_PROGRESS');
    }
    final generation = _generation;
    ref.read(cartBusyProvider.notifier).state = true;
    final repository = ref.read(cartRepositoryProvider);
    try {
      if (state.isLoading) await future;
      if (_disposed || generation != _generation) {
        throw const ApiException('SESSION_CHANGED');
      }
      final result = await repository.update(operation, {
        'id': id,
        'quantity': ?quantity,
      });
      // An auth or language change invalidates this operation's UI state.
      if (!_disposed &&
          identical(repository, ref.read(cartRepositoryProvider)) &&
          ref.read(shopApiProvider).isAuthenticated &&
          !_disposed) {
        state = AsyncData(result);
      }
    } finally {
      if (!_disposed) ref.read(cartBusyProvider.notifier).state = false;
    }
  }
}
