import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/features/edit_address/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';

class EditAddressPage extends ConsumerWidget {
  const EditAddressPage({super.key, this.id});
  final String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    Widget editor(address) => AddressEditor(
      key: ValueKey(id ?? 'new'),
      address: address,
      onSaved: () => context.go('/addresses'),
    );
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/addresses'),
        title: Text(id == null ? l.addressesAdd : l.addressesEdit),
      ),
      body: id == null
          ? editor(null)
          : AsyncContent(
              value: ref.watch(customerAddressesProvider),
              onRetry: () => ref.invalidate(customerAddressesProvider),
              builder: (items) {
                final address = items
                    .where((item) => item['id'] == id)
                    .firstOrNull;
                return address == null
                    ? Center(child: Text(l.addressesLoadError))
                    : editor(address);
              },
            ),
    );
  }
}
