import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/entities/store/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/feedback/lazy_load_footer.dart';
import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key, required this.channelToken});
  final String channelToken;

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  final search = TextEditingController();
  final scrollController = ScrollController();
  String term = '';
  String? collectionId;

  StoreProductQuery get productQuery => (
    channelToken: widget.channelToken,
    collectionId: collectionId,
    term: term,
  );

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (scrollController.position.extentAfter < 600) {
      ref.read(storeProductsProvider(productQuery).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    search.dispose();
    scrollController
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stores = ref.watch(storesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/stores'),
        title: Text(l.storesTitle),
      ),
      body: stores.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => RetryView(
          message: l.storesLoadError,
          onRetry: () => ref.invalidate(storesProvider),
        ),
        data: (result) {
          final store = _findStore(result);
          if (store == null) return Center(child: Text(l.storeUnavailable));
          return _catalog(context, store);
        },
      ),
    );
  }

  Json? _findStore(Json result) {
    for (final store in List<Json>.from(result['items'])) {
      final channels = List<Json>.from(store['channels']);
      if (channels.any((channel) => channel['token'] == widget.channelToken)) {
        return store;
      }
    }
    return null;
  }

  Widget _catalog(BuildContext context, Json store) {
    final l = AppLocalizations.of(context);
    final collections = ref.watch(
      storeCollectionsProvider(widget.channelToken),
    );
    final products = ref.watch(storeProductsProvider(productQuery));
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(storeCollectionsProvider(widget.channelToken));
        await ref
            .read(storeProductsProvider(productQuery).notifier)
            .refresh(showLoading: false);
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['name'] as String,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: search,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l.catalogSearch,
                    ),
                    onSubmitted: (value) => setState(() {
                      term = value.trim();
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.storeCategories,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: collections.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (_, _) => Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => ref.invalidate(
                            storeCollectionsProvider(widget.channelToken),
                          ),
                          child: Text(l.catalogRetryCategories),
                        ),
                      ),
                      data: (items) => ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ChoiceChip(
                            label: Text(l.catalogAllProducts),
                            selected: collectionId == null,
                            onSelected: (_) => _selectCollection(null),
                          ),
                          for (final item in items)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ChoiceChip(
                                label: Text(item['name'] as String),
                                selected: collectionId == item['id'],
                                onSelected: (_) =>
                                    _selectCollection(item['id'] as String),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.storeProducts,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          ...products.when(
            loading: () => [
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (_, _) => [
              SliverFillRemaining(
                child: RetryView(
                  message: l.catalogLoadError,
                  onRetry: () => ref
                      .read(storeProductsProvider(productQuery).notifier)
                      .refresh(),
                ),
              ),
            ],
            data: (data) {
              final page = data!;
              final items = page.items;
              if (items.isEmpty) {
                return [
                  SliverFillRemaining(
                    child: Center(child: Text(l.catalogEmpty)),
                  ),
                ];
              }
              return [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(l.catalogProductCount(page.total)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) => SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (constraints.crossAxisExtent / 190)
                            .floor()
                            .clamp(2, 5),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 290,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: items[index],
                          onTap: () => context.push(
                            '/product/${Uri.encodeComponent(items[index]['slug'] as String)}?channel=${Uri.encodeComponent(widget.channelToken)}',
                          ),
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: LazyLoadFooter(
                    loading: page.isLoadingMore,
                    error: page.loadMoreError,
                    onRetry: () => ref
                        .read(storeProductsProvider(productQuery).notifier)
                        .loadMore(),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  void _selectCollection(String? id) => setState(() {
    collectionId = id;
  });
}
