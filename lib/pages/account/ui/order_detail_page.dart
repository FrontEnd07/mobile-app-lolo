import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/images/app_network_image.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/settings/index.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.code});
  final String code;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final language = ref.watch(settingsProvider).locale.languageCode;
    final order = ref.watch(orderDetailProvider(code));
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/orders'),
        title: Text('#$code'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(orderDetailProvider(code)),
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
          ),
        ],
      ),
      body: AsyncContent(
        value: order,
        onRetry: () => ref.invalidate(orderDetailProvider(code)),
        builder: (data) {
          if (data == null) {
            return Center(child: Text(l.orderUnavailable));
          }
          String price(num value) =>
              formatPrice(value, data['currencyCode'] as String, language);
          final address = data['shippingAddress'] as Json?;
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(orderDetailProvider(code));
              await ref.read(orderDetailProvider(code).future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Chip(label: Text(orderStatus(data['state'] as String, l))),
                Text(orderDate(data['createdAt'] as String, language)),
                const SizedBox(height: 24),
                Text(
                  l.orderItems,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                for (final line in List<Json>.from(data['lines']))
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: AppNetworkImage(
                        url:
                            line['productVariant']['product']['featuredAsset']?['preview']
                                as String?,
                      ),
                    ),
                    title: Text(line['productVariant']['name'] as String),
                    subtitle: Text('× ${line['quantity']}'),
                    trailing: Text(price(line['linePriceWithTax'] as num)),
                  ),
                const Divider(),
                OrderTotals(order: data),
                const SizedBox(height: 16),
                if (address != null) ...[
                  Text(
                    l.orderRecipientAddress,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    [
                      address['fullName'],
                      address['phoneNumber'],
                      address['country'],
                      address['city'],
                      address['streetLine1'],
                      address['streetLine2'],
                      address['postalCode'],
                    ].whereType<String>().where((s) => s.isNotEmpty).join('\n'),
                  ),
                ],
                for (final shipping in List<Json>.from(
                  data['shippingLines'] ?? [],
                ))
                  ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: Text(shipping['shippingMethod']['name'] as String),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
