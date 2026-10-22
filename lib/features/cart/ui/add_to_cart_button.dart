import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/shared/api/shop_api.dart';

class AddToCartButton extends ConsumerWidget {
  const AddToCartButton({
    super.key,
    required this.variantId,
    required this.inStock,
    required this.onLogin,
    required this.onOpenCart,
  });
  final String variantId;
  final bool inStock;
  final VoidCallback onLogin, onOpenCart;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final busy = ref.watch(cartBusyProvider);
    return FilledButton.icon(
      icon: const Icon(Icons.add_shopping_cart),
      label: Text(busy ? l.cartAdding : l.cartAdd),
      onPressed: !inStock || busy
          ? null
          : () async {
              if (!ref.read(shopApiProvider).isAuthenticated) {
                onLogin();
                return;
              }
              try {
                await ref
                    .read(cartProvider.notifier)
                    .change('addItemToOrder', variantId, 1);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.cartAdded),
                    action: SnackBarAction(
                      label: l.commonOpen,
                      onPressed: onOpenCart,
                    ),
                  ),
                );
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(cartMessage(error, l))),
                  );
                }
              }
            },
    );
  }
}
