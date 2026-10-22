import 'order_result.dart';

import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'package:ecommerce_new/entities/order/api/order_fields.dart';

class CartRepository {
  CartRepository(this.api);
  final ShopApi api;
  Future<Json?> load() async {
    final data = await api.execute(
      'query { activeOrder { $orderFields } }',
      {},
      false,
    );
    final order = data['activeOrder'] as Json?;
    if (order == null || order['currencyCode'] == api.currency) return order;
    final updated = await api.execute(
      r'''mutation SetOrderCurrency($currency: CurrencyCode!) {
        setCurrencyCodeForOrder(currencyCode: $currency) {
          __typename
          ... on Order { '''
      '$orderFields'
      r''' }
          ... on ErrorResult { errorCode message }
        }
      }''',
      {'currency': api.currency},
      true,
    );
    return orderResult(updated, 'setCurrencyCodeForOrder');
  }

  Future<Json> update(String operation, Json variables) async {
    final (declarations, arguments) = switch (operation) {
      'addItemToOrder' => (
        r'$id: ID!, $quantity: Int!',
        r'productVariantId: $id, quantity: $quantity',
      ),
      'adjustOrderLine' => (
        r'$id: ID!, $quantity: Int!',
        r'orderLineId: $id, quantity: $quantity',
      ),
      'removeOrderLine' => (r'$id: ID!', r'orderLineId: $id'),
      _ => throw ArgumentError.value(operation, 'operation'),
    };
    final data = await api.execute(
      'mutation Cart($declarations) { $operation($arguments) { __typename ... on Order { $orderFields } ... on ErrorResult { errorCode message } } }',
      variables,
      true,
    );
    return orderResult(data, operation);
  }
}
