import 'package:ecommerce_new/shared/api/api_exception.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

String cartMessage(Object error, AppLocalizations l) =>
    switch (error is ApiException ? error.code : 'NETWORK') {
      'INSUFFICIENT_STOCK_ERROR' => l.cartStockError,
      'ORDER_LIMIT_ERROR' => l.cartLimitError,
      'LOGIN_REQUIRED' => l.cartLoginRequired,
      _ => l.cartUpdateError,
    };
