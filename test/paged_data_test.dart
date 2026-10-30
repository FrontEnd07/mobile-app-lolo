import 'package:ecommerce_new/shared/model/paged_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Lazy pagination appends pages and stops at total', () async {
    final skips = <int>[];
    final notifier = PagedDataNotifier((skip) async {
      skips.add(skip);
      return {
        'totalItems': 4,
        'items': [
          {'id': '${skip + 1}'},
          {'id': '${skip + 2}'},
        ],
      };
    });
    addTearDown(notifier.dispose);

    await notifier.initialized;
    await notifier.loadMore();
    await notifier.loadMore();

    expect(skips, [0, 2]);
    expect(notifier.state.value!.items, hasLength(4));
    expect(notifier.state.value!.hasMore, isFalse);
  });

  test('Lazy pagination keeps loaded items when next page fails', () async {
    final notifier = PagedDataNotifier((skip) async {
      if (skip > 0) throw StateError('Offline');
      return {
        'totalItems': 2,
        'items': [
          {'id': '1'},
        ],
      };
    });
    addTearDown(notifier.dispose);

    await notifier.initialized;
    await notifier.loadMore();

    expect(notifier.state.value!.items, hasLength(1));
    expect(notifier.state.value!.loadMoreError, isA<StateError>());
  });
}
