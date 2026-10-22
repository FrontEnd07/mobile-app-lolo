import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

import 'package:ecommerce_new/entities/order/api/order_fields.dart';

class OrderRepository {
  OrderRepository(this.api);
  final ShopApi api;
  Future<Json?> orders(int skip) async {
    final result = await api.execute(
      r"""
      query Orders($skip: Int!) {
        activeCustomer { orders(options: { skip: $skip, take: 10,
          sort: { createdAt: DESC }, filter: { active: { eq: false } } }) {
          totalItems items { id code state createdAt totalWithTax currencyCode totalQuantity }
        } }
      }
    """,
      {'skip': skip},
      false,
    );
    return result['activeCustomer']?['orders'] as Json?;
  }

  Future<Json?> detail(String code) async {
    try {
      final result = await api.execute(
        """
      query OrderDetail(\$code: String!) { orderByCode(code: \$code) {
        $orderFields
        state createdAt
        shippingAddress { fullName streetLine1 streetLine2 city postalCode country phoneNumber }
        shippingLines { shippingMethod { name } }
        payments { method state amount }
      } }
    """,
        {'code': code},
        false,
      );
      return result['orderByCode'] as Json?;
    } on ApiException catch (error) {
      if (error.code == 'ACCESS_DENIED') return null;
      rethrow;
    }
  }
}
