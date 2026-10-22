import 'package:ecommerce_new/entities/auth/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TestStorage extends AuthStorage {
  TestStorage(this.token) : super(const FlutterSecureStorage());
  final String? token;
  @override
  Future<String?> readToken() async => token;
}
