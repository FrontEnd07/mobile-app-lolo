import 'package:intl/intl.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

String orderStatus(String state, AppLocalizations l) => switch (state) {
  'AddingItems' => l.orderStatusAddingItems,
  'ArrangingPayment' => l.orderStatusArrangingPayment,
  'PaymentAuthorized' => l.orderStatusPaymentAuthorized,
  'PaymentSettled' => l.orderStatusPaymentSettled,
  'PartiallyShipped' => l.orderStatusPartiallyShipped,
  'Shipped' => l.orderStatusShipped,
  'PartiallyDelivered' => l.orderStatusPartiallyDelivered,
  'Delivered' => l.orderStatusDelivered,
  'Cancelled' => l.orderStatusCancelled,
  _ => state,
};

String orderDate(String value, String language) {
  final date = DateTime.tryParse(value)?.toLocal();
  if (date == null) return value;
  return DateFormat.yMMMd(language == 'tg' ? 'ru' : language).format(date);
}
