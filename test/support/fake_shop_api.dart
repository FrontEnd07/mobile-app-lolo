import 'package:ecommerce_new/shared/api/shop_api.dart';
import 'package:ecommerce_new/shared/lib/json.dart';

class FakeApi extends ShopApi {
  FakeApi(this.replies) : super();
  final List<Json> replies;
  final calls = <Json>[];
  @override
  Future<Json> execute(
    String document,
    Json variables,
    bool mutation, {
    bool authenticated = true,
    String? channelToken,
  }) async {
    calls.add({
      'document': document,
      'variables': variables,
      'mutation': mutation,
    });
    return replies.removeAt(0);
  }
}
