import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/auth/index.dart';

import 'package:ecommerce_new/features/auth/model/auth_notifier.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authStorageProvider)),
);
