import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/navigation/pagination_bar.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/settings/index.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final language = ref.watch(settingsProvider).locale.languageCode;
    final orders = ref.watch(orderHistoryProvider);
    final offset = ref.watch(orderHistoryOffsetProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/profile'),
        title: Text(l.ordersTitle),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(orderHistoryProvider),
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
          ),
        ],
      ),
      body: AsyncContent(
        value: orders,
        onRetry: () => ref.invalidate(orderHistoryProvider),
        builder: (data) {
          if (data == null) {
            return Center(child: Text(l.sessionExpired));
          }
          final items = List<Json>.from(data['items']);
          final total = data['totalItems'] as int;
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(orderHistoryProvider);
              await ref.read(orderHistoryProvider.future);
            },
            child: ListView(
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
                if (total > 10 || offset > 0)
                  PaginationBar(
                    offset: offset,
                    count: items.length,
                    total: total,
                    pageSize: 10,
                    onChanged: (value) =>
                        ref.read(orderHistoryOffsetProvider.notifier).state =
                            value,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
