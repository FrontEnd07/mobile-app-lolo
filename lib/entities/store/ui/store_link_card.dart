import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class StoreLinkCard extends StatelessWidget {
  const StoreLinkCard({super.key, required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: colors.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.storefront_outlined,
          color: colors.onPrimaryContainer,
        ),
        title: Text(
          l.productStore(name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(l.openStore),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
