import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/app_localizations.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.fallback = '/', this.enabled = true});
  final String fallback;
  final bool enabled;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: AppLocalizations.of(context).commonBack,
    icon: const Icon(Icons.arrow_back),
    onPressed: !enabled
        ? null
        : () {
            final router = GoRouter.maybeOf(context);
            if (router == null) {
              Navigator.of(context).maybePop();
            } else if (router.canPop()) {
              router.pop();
            } else {
              router.go(fallback);
            }
          },
  );
}
