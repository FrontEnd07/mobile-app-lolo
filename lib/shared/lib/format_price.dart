import 'package:intl/intl.dart';

String formatPrice(num minorUnits, String currency, String locale) =>
    NumberFormat.currency(
      locale: locale == 'tg' ? 'ru' : locale,
      symbol: currency,
    ).format(minorUnits / 100);
