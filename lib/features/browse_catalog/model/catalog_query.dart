import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/shared/model/paged_data.dart';

final searchTermProvider = StateProvider<String>((ref) => '');
final selectedCollectionProvider = StateProvider<String?>((ref) => null);
final catalogProvider =
    StateNotifierProvider.autoDispose<
      PagedDataNotifier,
      AsyncValue<PagedData?>
    >((ref) {
      final repository = ref.watch(catalogRepositoryProvider);
      final term = ref.watch(searchTermProvider);
      final collectionId = ref.watch(selectedCollectionProvider);
      return PagedDataNotifier(
        (skip) => repository.search(term, collectionId, skip),
      );
    });
