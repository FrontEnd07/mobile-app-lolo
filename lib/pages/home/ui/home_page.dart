import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/features/auth/index.dart';
import 'package:ecommerce_new/widgets/catalog/index.dart';
import 'package:ecommerce_new/widgets/cart_indicator/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune),
            tooltip: l.settingsTitle,
          ),
          const CartButton(),
          const AuthAvatar(),
        ],
      ),
      body: const CatalogView(),
    );
  }
}
