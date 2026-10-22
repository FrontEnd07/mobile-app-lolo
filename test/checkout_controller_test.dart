import 'dart:async';

import 'package:ecommerce_new/features/checkout/index.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_shop_api.dart';

class DeferredCheckout extends CheckoutRepository {
  DeferredCheckout() : super(FakeApi([]));
  final response = Completer<Json>();
  int calls = 0;
  @override
  Future<Json> confirmTestOrder(String method, {Json? reviewedOrder}) {
    calls++;
    return response.future;
  }
}

void main() {
  test('Repeated confirmation while pending does not pay twice', () async {
    final repository = DeferredCheckout();
    var changes = 0;
    final controller = CheckoutController(repository, () => changes++);
    addTearDown(controller.dispose);
    controller.selectPayment('test');
    final first = controller.confirm();
    await controller.confirm();
    expect(repository.calls, 1);
    repository.response.complete({
      'state': 'PaymentAuthorized',
      'code': 'TEST',
    });
    await first;
    expect(controller.completed!['code'], 'TEST');
    expect(changes, 1);
  });
  test(
    'Leaving checkout during confirmation does not notify disposed UI',
    () async {
      final repository = DeferredCheckout();
      var changes = 0;
      final controller = CheckoutController(repository, () => changes++);
      controller.selectPayment('test');
      final pending = controller.confirm();
      controller.dispose();
      repository.response.complete({
        'state': 'PaymentAuthorized',
        'code': 'TEST',
      });
      await pending;
      expect(changes, 0);
      expect(controller.completed, isNull);
    },
  );
}
