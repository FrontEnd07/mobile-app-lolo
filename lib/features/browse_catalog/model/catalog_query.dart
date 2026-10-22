import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';

final searchTermProvider = StateProvider<String>((ref) => '');
final selectedCollectionProvider = StateProvider<String?>((ref) => null);
final catalogPageProvider = StateProvider<int>((ref) => 0);
final catalogProvider = FutureProvider(
  (ref) => ref
      .watch(catalogRepositoryProvider)
      .search(
        ref.watch(searchTermProvider),
        ref.watch(selectedCollectionProvider),
        ref.watch(catalogPageProvider),
      ),
);
