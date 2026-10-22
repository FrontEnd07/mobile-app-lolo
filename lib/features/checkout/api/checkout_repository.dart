import 'dart:convert';

import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/entities/order/index.dart';

class CheckoutRepository {
  CheckoutRepository(this.api);
  final ShopApi api;
  static const fields =
      """
    $orderFields
    state shippingAddress { fullName streetLine1 streetLine2 city postalCode country phoneNumber }
    shippingLines { shippingMethod { id name } }
  """;
  Future<Json?> order() async =>
      (await api.execute(
            'query { activeOrder { $fields } }',
            {},
            false,
          ))['activeOrder']
          as Json?;
  Future<Json> mutation(
    String field,
    String declaration,
    String arguments,
    Json variables,
  ) async {
    final data = await api.execute(
      'mutation Checkout($declaration) { $field($arguments) { __typename ... on Order { $fields } ... on ErrorResult { errorCode message } } }',
      variables,
      true,
    );
    return orderResult(data, field);
  }

  Future<Json> address(Json input) async {
    final current = await order();
    if (current?['state'] == 'ArrangingPayment') {
      await mutation(
        'transitionOrderToState',
        r'$state: String!',
        r'state: $state',
        {'state': 'AddingItems'},
      );
    }
    return mutation(
      'setOrderShippingAddress',
      r'$input: CreateAddressInput!',
      r'input: $input',
      {'input': input},
    );
  }

  Future<List<Json>> shippingMethods() async => List<Json>.from(
    (await api.execute(
      'query { eligibleShippingMethods { id name priceWithTax } }',
      {},
      false,
    ))['eligibleShippingMethods'],
  );
  Future<Json> shipping(String id) => mutation(
    'setOrderShippingMethod',
    r'$ids: [ID!]!',
    r'shippingMethodId: $ids',
    {
      'ids': [id],
    },
  );
  Future<List<Json>> paymentMethods() async => List<Json>.from(
    (await api.execute(
      'query { eligiblePaymentMethods { code name isEligible } }',
      {},
      false,
    ))['eligiblePaymentMethods'],
  );

  String _snapshot(Json order) {
    final lines =
        List<Json>.from(order['lines'] ?? [])
            .map(
              (line) => {
                'variant': line['productVariant']?['id'],
                'quantity': line['quantity'],
                'amount': line['linePriceWithTax'],
              },
            )
            .toList()
          ..sort((a, b) => '${a['variant']}'.compareTo('${b['variant']}'));
    return jsonEncode({
      'id': order['id'],
      'total': order['totalWithTax'],
      'quantity': order['totalQuantity'],
      'currency': order['currencyCode'],
      'lines': lines,
      'address': order['shippingAddress'],
      'shipping': order['shippingLines'],
    });
  }

  Future<Json> confirmTestOrder(String method, {Json? reviewedOrder}) async {
    final current = await order();
    if (current == null || current['totalQuantity'] == 0) {
      throw const ApiException('NO_ACTIVE_ORDER_ERROR');
    }
    if (reviewedOrder != null &&
        _snapshot(current) != _snapshot(reviewedOrder)) {
      throw const ApiException('ORDER_CHANGED');
    }
    if (current['state'] == 'AddingItems') {
      await mutation(
        'transitionOrderToState',
        r'$state: String!',
        r'state: $state',
        {'state': 'ArrangingPayment'},
      );
    } else if (current['state'] != 'ArrangingPayment') {
      throw const ApiException('ORDER_STATE_TRANSITION_ERROR');
    }
    return mutation(
      'addPaymentToOrder',
      r'$input: PaymentInput!',
      r'input: $input',
      {
        'input': {'method': method, 'metadata': {}},
      },
    );
  }
}
