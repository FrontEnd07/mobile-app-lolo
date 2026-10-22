import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/lib/error_localizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/features/auth/model/auth_provider.dart';
import 'package:ecommerce_new/entities/auth/index.dart';

void useAuthErrorListener(BuildContext context, WidgetRef ref) {
  ref.listen<AuthState>(authProvider, (prev, next) {
    final error = next.error;
    if (error == null || error == prev?.error) return;

    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(localizeError(l, error)),
          behavior: SnackBarBehavior.floating,
        ),
      );

    ref.read(authProvider.notifier).clearError();
  });
}
