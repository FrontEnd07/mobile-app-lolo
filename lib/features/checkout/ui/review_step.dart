import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_new/entities/order/index.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/text/price_text.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({
    super.key,
    required this.order,
    required this.methods,
    required this.selected,
    required this.busy,
    required this.uncertain,
    required this.onSelect,
    required this.onConfirm,
    required this.onViewOrders,
  });
  final Json order;
  final List<Json> methods;
  final String? selected;
  final bool busy, uncertain;
  final ValueChanged<String> onSelect;
  final VoidCallback onConfirm, onViewOrders;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final address = order['shippingAddress'] as Json?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (address != null)
          Text(
            [
              address['fullName'],
              address['phoneNumber'],
              address['city'],
              address['streetLine1'],
            ].whereType<String>().join('\n'),
          ),
        for (final line in List<Json>.from(order['lines']))
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(line['productVariant']['name'] as String),
            subtitle: Text('× ${line['quantity']}'),
            trailing: PriceText(
              amount: line['linePriceWithTax'] as num,
              currency: order['currencyCode'] as String,
            ),
          ),
        const Divider(),
        OrderTotals(order: order),
        for (final method in methods)
          ListTile(
            leading: Icon(
              selected == method['code']
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
            ),
            title: Text(method['name'] as String),
            onTap: busy || uncertain
                ? null
                : () => onSelect(method['code'] as String),
          ),
        if (methods.isEmpty) Text(l.checkoutNoPayment),
        if (uncertain) ...[
          Text(l.checkoutResponseLost),
          TextButton(
            onPressed: onViewOrders,
            child: Text(l.ordersCheckHistory),
          ),
        ],
        FilledButton(
          onPressed: busy || selected == null || uncertain ? null : onConfirm,
          child: Text(l.checkoutConfirmTestOrder),
        ),
      ],
    );
  }
}
