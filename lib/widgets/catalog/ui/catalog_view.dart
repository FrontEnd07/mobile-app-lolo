import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/navigation/pagination_bar.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';

import 'package:ecommerce_new/features/browse_catalog/index.dart';

class CatalogView extends ConsumerWidget {
  const CatalogView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final products = ref.watch(catalogProvider);
    final collections = ref.watch(collectionsProvider);
    final selected = ref.watch(selectedCollectionProvider);
    final offset = ref.watch(catalogPageProvider);
    void resetPage() => ref.read(catalogPageProvider.notifier).state = 0;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(collectionsProvider);
        ref.invalidate(catalogProvider);
        await ref.read(catalogProvider.future);
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.catalogHeading,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/stores'),
                      icon: const Icon(Icons.storefront_outlined),
                      label: Text(l.storesTitle),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: ref.read(searchTermProvider),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l.catalogSearch,
                    ),
                    onFieldSubmitted: (value) {
                      resetPage();
                      ref.read(searchTermProvider.notifier).state = value
                          .trim();
                    },
                  ),
                  const SizedBox(height: 12),
                  collections.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => TextButton(
                      onPressed: () => ref.invalidate(collectionsProvider),
                      child: Text(l.catalogRetryCategories),
                    ),
                    data: (items) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(l.catalogAllProducts),
                            selected: selected == null,
                            onSelected: (_) {
                              resetPage();
                              ref
                                      .read(selectedCollectionProvider.notifier)
                                      .state =
                                  null;
                            },
                          ),
                          for (final item in items)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ChoiceChip(
                                label: Text(item['name'] as String),
                                selected: selected == item['id'],
                                onSelected: (_) {
                                  resetPage();
                                  ref
                                          .read(
                                            selectedCollectionProvider.notifier,
                                          )
                                          .state =
                                      item['id'] as String;
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_outlined, size: 48),
                        const SizedBox(height: 12),
                        Text(l.catalogLoadError, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => ref.invalidate(catalogProvider),
                          child: Text(l.commonRetry),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            data: (data) {
              final items = List<Json>.from(data['items']);
              final total = data['totalItems'] as int;
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
                    child: Text(l.catalogProductCount(total)),
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
                            '/product/${Uri.encodeComponent(items[index]['slug'] as String)}',
                          ),
                        ),
                        childCount: items.length,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: PaginationBar(
                    offset: offset,
                    count: items.length,
                    total: total,
                    pageSize: 20,
                    onChanged: (value) =>
                        ref.read(catalogPageProvider.notifier).state = value,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
