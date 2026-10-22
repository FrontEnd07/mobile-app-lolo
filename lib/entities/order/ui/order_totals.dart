import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/text/price_text.dart';

class OrderTotals extends StatelessWidget {
  const OrderTotals({super.key, required this.order});
  final Json order;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget row(String label, String key, {bool total = false}) => ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: PriceText(
        amount: order[key] as num? ?? 0,
        currency: order['currencyCode'] as String,
        style: total ? Theme.of(context).textTheme.titleLarge : null,
      ),
    );
    return Column(
      children: [
        row(l.orderSubtotal, 'subTotalWithTax'),
        row(l.orderShipping, 'shippingWithTax'),
        row(l.orderTotal, 'totalWithTax', total: true),
      ],
    );
  }
}
