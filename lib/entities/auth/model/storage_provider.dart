import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ecommerce_new/entities/auth/model/auth_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);
final authStorageProvider = Provider<AuthStorage>(
  (ref) => AuthStorage(ref.watch(secureStorageProvider)),
);
