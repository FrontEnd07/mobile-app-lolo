import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PageLoader = Future<Json?> Function(int skip);

class PagedData {
  const PagedData({
    required this.items,
    required this.total,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory PagedData.fromJson(Json data) => PagedData(
    items: List<Json>.from(data['items'] as List),
    total: data['totalItems'] as int,
  );

  final List<Json> items;
  final int total;
  final bool isLoadingMore;
  final Object? loadMoreError;

  bool get hasMore => items.length < total;

  PagedData copyWith({
    List<Json>? items,
    int? total,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
  }) => PagedData(
    items: items ?? this.items,
    total: total ?? this.total,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
  );
}

class PagedDataNotifier extends StateNotifier<AsyncValue<PagedData?>> {
  PagedDataNotifier(this._loadPage) : super(const AsyncValue.loading()) {
    initialized = refresh();
  }

  final PageLoader _loadPage;
  late final Future<void> initialized;
  bool _refreshing = false;

  Future<void> refresh({bool showLoading = true}) async {
    if (_refreshing) return;
    _refreshing = true;
    if (showLoading) state = const AsyncValue.loading();
    try {
      final data = await _loadPage(0);
      state = AsyncValue.data(data == null ? null : PagedData.fromJson(data));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } finally {
      _refreshing = false;
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true, clearLoadMoreError: true),
    );
    try {
      final data = await _loadPage(current.items.length);
      if (data == null) {
        state = AsyncValue.data(current.copyWith(isLoadingMore: false));
        return;
      }
      final page = PagedData.fromJson(data);
      state = AsyncValue.data(
        PagedData(items: [...current.items, ...page.items], total: page.total),
      );
    } catch (error) {
      state = AsyncValue.data(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }
}
