import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

class CustomerRepository {
  CustomerRepository(this.api);
  final ShopApi api;
  Future<Json?> customer() async =>
      (await api.execute(
            'query { activeCustomer { id firstName lastName emailAddress phoneNumber } }',
            {},
            false,
          ))['activeCustomer']
          as Json?;
  Future<Json> updateNames(String firstName, String lastName) async {
    final result = await api.execute(
      r"""
      mutation Profile($input: UpdateCustomerInput!) {
        updateCustomer(input: $input) { id firstName lastName emailAddress phoneNumber }
      }
    """,
      {
        'input': {'firstName': firstName.trim(), 'lastName': lastName.trim()},
      },
      true,
    );
    return result['updateCustomer'] as Json;
  }

  static const addressFields = '''
    id fullName streetLine1 streetLine2 city postalCode phoneNumber
    country { code name } defaultShippingAddress defaultBillingAddress
  ''';
  Future<List<Json>> addresses() async {
    final data = await api.execute(
      'query { activeCustomer { addresses { $addressFields } } }',
      {},
      false,
    );
    if (data['activeCustomer'] == null) {
      throw const ApiException('LOGIN_REQUIRED');
    }
    return List<Json>.from(data['activeCustomer']['addresses']);
  }

  Future<List<Json>> countries() async => List<Json>.from(
    (await api.execute(
      'query { availableCountries { code name } }',
      {},
      false,
    ))['availableCountries'],
  );
  Future<Json> saveAddress(Json input, {String? id}) async {
    final field = id == null
        ? 'createCustomerAddress'
        : 'updateCustomerAddress';
    final type = id == null ? 'CreateAddressInput' : 'UpdateAddressInput';
    final result = await api.execute(
      'mutation Address($input: $type!) { $field(input: $input) { $addressFields } }',
      {
        'input': {'id': ?id, ...input},
      },
      true,
    );
    return result[field] as Json;
  }

  Future<void> deleteAddress(String id) async {
    final result = await api.execute(
      r'mutation DeleteAddress($id: ID!) { deleteCustomerAddress(id: $id) { success } }',
      {'id': id},
      true,
    );
    if (result['deleteCustomerAddress']?['success'] != true) {
      throw const ApiException('ADDRESS_DELETE_FAILED');
    }
  }
}
