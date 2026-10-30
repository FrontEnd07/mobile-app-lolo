import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class LazyLoadFooter extends StatelessWidget {
  const LazyLoadFooter({
    super.key,
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  final bool loading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context).commonRetry),
          ),
        ),
      );
    }
    return const SizedBox(height: 24);
  }
}
