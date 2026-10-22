import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/features/checkout/model/checkout_provider.dart';
import 'package:ecommerce_new/features/checkout/model/checkout_controller.dart';
import 'package:ecommerce_new/features/checkout/ui/address_step.dart';
import 'package:ecommerce_new/features/checkout/ui/delivery_step.dart';
import 'package:ecommerce_new/features/checkout/ui/review_step.dart';

class CheckoutFlow extends ConsumerWidget {
  const CheckoutFlow({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final controller = ref.watch(checkoutControllerProvider);
    final completed = controller.completed;
    if (completed != null) {
      return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallback: '/orders'),
          title: Text(l.checkoutCompleted),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 72),
              Text(
                l.checkoutTestOrder,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SelectableText('#${completed['code']}'),
              TextButton(
                onPressed: () => context.go('/orders'),
                child: Text(l.ordersTitle),
              ),
              FilledButton(
                onPressed: () => context.go('/'),
                child: Text(l.checkoutContinueShopping),
              ),
            ],
          ),
        ),
      );
    }
    return PopScope(
      canPop: !controller.busy,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(fallback: '/cart', enabled: !controller.busy),
          title: Text(l.checkoutTitle),
        ),
        body: AsyncContent(
          value: ref.watch(checkoutOrderProvider),
          onRetry: () => ref.invalidate(checkoutOrderProvider),
          builder: (initial) {
            if (initial == null || initial['totalQuantity'] == 0) {
              return Center(child: Text(l.cartEmpty));
            }
            return AsyncContent(
              value: ref.watch(checkoutCountriesProvider),
              onRetry: () => ref.invalidate(checkoutCountriesProvider),
              builder: (countries) {
                final order = controller.order ?? initial;
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(l.checkoutTestNotice),
                    const SizedBox(height: 16),
                    Text(
                      [
                        l.checkoutAddressStep,
                        l.checkoutDeliveryStep,
                        l.checkoutReviewStep,
                      ][controller.step.index],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    if (controller.busy) const LinearProgressIndicator(),
                    if (controller.failure != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          controller.failure!.code == 'ORDER_CHANGED'
                              ? l.checkoutOrderChanged
                              : l.checkoutActionError,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    switch (controller.step) {
                      CheckoutStep.address => AddressStep(
                        initialAddress: order['shippingAddress'],
                        countries: countries,
                        busy: controller.busy,
                        onSubmit: controller.saveAddress,
                      ),
                      CheckoutStep.delivery => DeliveryStep(
                        methods: controller.deliveries,
                        currency: order['currencyCode'] as String,
                        selected: controller.delivery,
                        busy: controller.busy,
                        onSelect: controller.selectDelivery,
                        onContinue: controller.saveDelivery,
                        onRetry: controller.retryDelivery,
                      ),
                      CheckoutStep.review => ReviewStep(
                        order: order,
                        methods: controller.payments,
                        selected: controller.payment,
                        busy: controller.busy,
                        uncertain: controller.uncertain,
                        onSelect: controller.selectPayment,
                        onConfirm: controller.confirm,
                        onViewOrders: () => context.go('/orders'),
                      ),
                    },
                    if (controller.step != CheckoutStep.address)
                      TextButton(
                        onPressed: controller.busy || controller.uncertain
                            ? null
                            : controller.editAddress,
                        child: Text(l.checkoutEditAddress),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
