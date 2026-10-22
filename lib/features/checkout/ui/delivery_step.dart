import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/lib/format_price.dart';

class DeliveryStep extends StatelessWidget {
  const DeliveryStep({
    super.key,
    required this.methods,
    required this.currency,
    required this.selected,
    required this.busy,
    required this.onSelect,
    required this.onContinue,
    required this.onRetry,
  });
  final List<Json> methods;
  final String currency;
  final String? selected;
  final bool busy;
  final ValueChanged<String> onSelect;
  final VoidCallback onContinue, onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        if (methods.isEmpty) Text(l.checkoutNoDelivery),
        for (final method in methods)
          ListTile(
            leading: Icon(
              selected == method['id']
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
            ),
            title: Text(method['name'] as String),
            subtitle: Text(
              formatPrice(method['priceWithTax'] as num, currency, language),
            ),
            onTap: busy ? null : () => onSelect(method['id'] as String),
          ),
        if (methods.isEmpty)
          TextButton(
            onPressed: busy ? null : onRetry,
            child: Text(l.commonRetry),
          ),
        FilledButton(
          onPressed: busy || selected == null ? null : onContinue,
          child: Text(l.checkoutReview),
        ),
      ],
    );
  }
}
