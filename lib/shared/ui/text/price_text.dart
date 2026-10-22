import 'package:flutter/material.dart';

import 'package:ecommerce_new/shared/lib/format_price.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
    this.oldAmount,
  });
  final num amount;
  final String currency;
  final TextStyle? style;
  final num? oldAmount;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final price = Text(formatPrice(amount, currency, locale), style: style);
    if (oldAmount == null || oldAmount! <= amount) return price;
    return Wrap(
      spacing: 8,
      children: [
        price,
        Text(
          formatPrice(oldAmount!, currency, locale),
          style: (style ?? const TextStyle()).copyWith(
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
