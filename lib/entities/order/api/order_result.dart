import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/api/api_exception.dart';

Json orderResult(Json data, String field) {
  final result = data[field] as Json;
  if (result['__typename'] != 'Order') {
    throw ApiException(
      result['errorCode'] as String? ?? 'UNKNOWN',
      result['message'] as String?,
    );
  }
  return result;
}
