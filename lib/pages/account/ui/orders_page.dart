import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/feedback/lazy_load_footer.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/settings/index.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (scrollController.position.extentAfter < 400) {
      ref.read(orderHistoryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final language = ref.watch(settingsProvider).locale.languageCode;
    final orders = ref.watch(orderHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/profile'),
        title: Text(l.ordersTitle),
        actions: [
          IconButton(
            onPressed: () => ref.read(orderHistoryProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
          ),
        ],
      ),
      body: AsyncContent(
        value: orders,
        onRetry: () => ref.read(orderHistoryProvider.notifier).refresh(),
        builder: (data) {
          if (data == null) {
            return Center(child: Text(l.sessionExpired));
          }
          final items = data.items;
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(orderHistoryProvider.notifier)
                  .refresh(showLoading: false);
            },
            child: ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Center(child: Text(l.ordersEmpty)),
                  ),
                for (final item in items)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      isThreeLine: true,
                      title: Text('#${item['code']}'),
                      subtitle: Text(
                        '${orderStatus(item['state'] as String, l)}\n${orderDate(item['createdAt'] as String, language)}',
                      ),
                      trailing: Text(
                        formatPrice(
                          item['totalWithTax'] as num,
                          item['currencyCode'] as String,
                          language,
                        ),
                      ),
                      onTap: () => context.push(
                        '/orders/${Uri.encodeComponent(item['code'] as String)}',
                      ),
                    ),
                  ),
                LazyLoadFooter(
                  loading: data.isLoadingMore,
                  error: data.loadMoreError,
                  onRetry: () =>
                      ref.read(orderHistoryProvider.notifier).loadMore(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
