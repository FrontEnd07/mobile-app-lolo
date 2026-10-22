import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/images/app_network_image.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final order = ref.watch(cartProvider);
    final busy = ref.watch(cartBusyProvider);
    final language = ref.watch(settingsProvider).locale.languageCode;
    Future<void> change(String operation, String id, [int? quantity]) async {
      try {
        await ref.read(cartProvider.notifier).change(operation, id, quantity);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(cartMessage(error, l))));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.navCart),
        actions: [
          IconButton(
            onPressed: busy ? null : () => ref.invalidate(cartProvider),
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
          ),
        ],
      ),
      body: order.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cartMessage(error, l), textAlign: TextAlign.center),
                TextButton(
                  onPressed: () => ref.invalidate(cartProvider),
                  child: Text(l.commonRetry),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          final lines = List<Json>.from(data?['lines'] ?? []);
          if (lines.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    l.cartEmpty,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/'),
                    child: Text(l.cartBrowseProducts),
                  ),
                ],
              ),
            );
          }
          final currency = data!['currencyCode'] as String;
          String price(num amount) => formatPrice(amount, currency, language);
          return RefreshIndicator(
            onRefresh: () async {
              if (!busy) {
                ref.invalidate(cartProvider);
                await ref.read(cartProvider.future);
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (busy) const LinearProgressIndicator(),
                for (final line in lines)
                  Card(
                    key: ValueKey('cart-line-${line['id']}'),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 76,
                                height: 76,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AppNetworkImage(
                                    url:
                                        line['productVariant']['product']['featuredAsset']?['preview']
                                            as String?,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () => context.push(
                                        '/product/${Uri.encodeComponent(line['productVariant']['product']['slug'] as String)}',
                                      ),
                                      child: Text(
                                        line['productVariant']['name']
                                            as String,
                                      ),
                                    ),
                                    Text(
                                      price(line['linePriceWithTax'] as num),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                key: ValueKey('cart-remove-${line['id']}'),
                                tooltip: l.commonRemove,
                                onPressed: busy
                                    ? null
                                    : () => change(
                                        'removeOrderLine',
                                        line['id'] as String,
                                      ),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                key: ValueKey('cart-decrease-${line['id']}'),
                                tooltip: l.cartDecreaseQuantity,
                                onPressed: busy
                                    ? null
                                    : () => (line['quantity'] as int) == 1
                                          ? change(
                                              'removeOrderLine',
                                              line['id'] as String,
                                            )
                                          : change(
                                              'adjustOrderLine',
                                              line['id'] as String,
                                              (line['quantity'] as int) - 1,
                                            ),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text('${line['quantity']}'),
                              IconButton(
                                key: ValueKey('cart-increase-${line['id']}'),
                                tooltip: l.cartIncreaseQuantity,
                                onPressed: busy
                                    ? null
                                    : () => change(
                                        'adjustOrderLine',
                                        line['id'] as String,
                                        (line['quantity'] as int) + 1,
                                      ),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                OrderTotals(order: data),
                const SizedBox(height: 12),
                Text(l.cartShippingAtCheckout),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: busy ? null : () => context.push('/checkout'),
                  child: Text(l.cartCheckout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
