import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/features/checkout/api/checkout_repository.dart';
import 'package:ecommerce_new/features/checkout/model/checkout_provider.dart';

enum CheckoutStep { address, delivery, review }

class CheckoutController extends ChangeNotifier {
  CheckoutController(this.repository, this.onOrderChanged);
  final CheckoutRepository repository;
  final VoidCallback onOrderChanged;
  CheckoutStep step = CheckoutStep.address;
  Json? order, completed;
  List<Json> deliveries = [], payments = [];
  String? delivery, payment;
  ApiException? failure;
  bool busy = false, uncertain = false, _disposed = false;

  void selectDelivery(String id) {
    delivery = id;
    notifyListeners();
  }

  void selectPayment(String code) {
    payment = code;
    notifyListeners();
  }

  void editAddress() {
    if (busy || uncertain) return;
    step = CheckoutStep.address;
    delivery = payment = null;
    failure = null;
    notifyListeners();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (busy || _disposed) return;
    busy = true;
    failure = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      failure = error is ApiException ? error : const ApiException('NETWORK');
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> saveAddress(Json input) => _run(() async {
    final updated = await repository.address(input);
    final available = await repository.shippingMethods();
    if (_disposed) return;
    order = updated;
    deliveries = available;
    delivery = null;
    step = CheckoutStep.delivery;
    onOrderChanged();
  });
  Future<void> retryDelivery() => _run(() async {
    final available = await repository.shippingMethods();
    if (!_disposed) deliveries = available;
  });
  Future<void> saveDelivery() => _run(() async {
    if (delivery == null) return;
    final updated = await repository.shipping(delivery!);
    final available = await repository.paymentMethods();
    if (_disposed) return;
    order = updated;
    payments = available
        .where((method) => method['isEligible'] == true)
        .toList();
    payment = null;
    step = CheckoutStep.review;
    onOrderChanged();
  });
  Future<void> confirm() => _run(() async {
    if (payment == null || uncertain) return;
    try {
      final result = await repository.confirmTestOrder(
        payment!,
        reviewedOrder: order,
      );
      if (!['PaymentSettled', 'PaymentAuthorized'].contains(result['state'])) {
        throw const ApiException('ORDER_STATE_TRANSITION_ERROR');
      }
      if (_disposed) return;
      completed = result;
      onOrderChanged();
    } catch (error) {
      uncertain = error is! ApiException || error.code == 'NETWORK';
      rethrow;
    }
  });
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

final checkoutControllerProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CheckoutController(
    ref.watch(checkoutRepositoryProvider),
    () => ref.invalidate(cartProvider),
  ),
);
