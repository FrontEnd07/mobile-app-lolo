import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/features/cart/index.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/widgets/cart_indicator/index.dart';
import 'package:ecommerce_new/shared/ui/images/app_network_image.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/catalog/index.dart';
import 'package:ecommerce_new/entities/settings/index.dart';
import 'package:ecommerce_new/entities/store/index.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key, required this.slug, this.channelToken});
  final String slug;
  final String? channelToken;
  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  String? selectedId;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final product = widget.channelToken == null
        ? ref.watch(productProvider(widget.slug))
        : ref.watch(
            storeProductProvider((
              slug: widget.slug,
              channelToken: widget.channelToken!,
            )),
          );
    final locale = ref.watch(settingsProvider).locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/'),
        title: Text(l.productDetails),
        actions: const [CartButton()],
      ),
      body: AsyncContent(
        value: product,
        onRetry: () => widget.channelToken == null
            ? ref.invalidate(productProvider(widget.slug))
            : ref.invalidate(
                storeProductProvider((
                  slug: widget.slug,
                  channelToken: widget.channelToken!,
                )),
              ),
        builder: (item) {
          if (item == null) {
            return Center(child: Text(l.productUnavailable));
          }
          final variants = List<Json>.from(item['variants']);
          final assets = List<Json>.from(item['assets']);
          final stores = List<Json>.from(item['marketplaceStores'] ?? const []);
          final selected =
              variants.where((v) => v['id'] == selectedId).firstOrNull ??
              variants.firstOrNull;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: 320,
                child: assets.isEmpty
                    ? const AppNetworkImage(url: null)
                    : PageView(
                        children: [
                          for (final asset in assets)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: AppNetworkImage(
                                url: asset['preview'] as String,
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              Text(
                item['name'] as String,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              if (selected != null) ...[
                Text(
                  formatPrice(
                    selected['priceWithTax'] as num,
                    selected['currencyCode'] as String,
                    locale,
                  ),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  selected['stockLevel'] == 'OUT_OF_STOCK'
                      ? l.productOutOfStock
                      : l.productInStock,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final variant in variants)
                      ChoiceChip(
                        label: Text(variant['name'] as String),
                        selected: variant['id'] == selected['id'],
                        onSelected: (_) => setState(
                          () => selectedId = variant['id'] as String,
                        ),
                      ),
                  ],
                ),
              ],
              if (selected != null && widget.channelToken == null) ...[
                const SizedBox(height: 20),
                AddToCartButton(
                  variantId: selected['id'] as String,
                  inStock: selected['stockLevel'] != 'OUT_OF_STOCK',
                  onLogin: () => context.push(
                    '/login?from=${Uri.encodeComponent('/product/${widget.slug}')}',
                  ),
                  onOpenCart: () => context.push('/cart'),
                ),
              ],
              if (stores.isNotEmpty) ...[
                const SizedBox(height: 24),
                for (final store in stores) ...[
                  StoreLinkCard(
                    name: store['name'] as String,
                    onTap: () => context.push(
                      '/store/${Uri.encodeComponent(store['channelToken'] as String)}',
                    ),
                  ),
                  if (store != stores.last) const SizedBox(height: 8),
                ],
              ],
              const SizedBox(height: 24),
              Text(
                l.productDescription,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SelectableText(
                (item['description'] as String)
                    .replaceAll(RegExp(r'<[^>]*>'), ' ')
                    .replaceAll('&nbsp;', ' ')
                    .replaceAll('&amp;', '&')
                    .trim(),
              ),
            ],
          );
        },
      ),
    );
  }
}
