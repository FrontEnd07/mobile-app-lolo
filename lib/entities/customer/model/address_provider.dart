import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customer_provider.dart';

final customerAddressesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(customerRepositoryProvider).addresses(),
);
final customerCountriesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(customerRepositoryProvider).countries(),
);
