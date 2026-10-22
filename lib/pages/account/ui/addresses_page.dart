import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';
import 'package:ecommerce_new/shared/ui/navigation/app_back_button.dart';

class AddressesPage extends ConsumerStatefulWidget {
  const AddressesPage({super.key});
  @override
  ConsumerState<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends ConsumerState<AddressesPage> {
  String? deleting;
  Future<void> remove(Json address) async {
    if (deleting != null) return;
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.addressesDeleteConfirm),
        content: Text('${address['city']}, ${address['streetLine1']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.commonRemove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final repository = ref.read(customerRepositoryProvider);
    setState(() => deleting = address['id'] as String);
    try {
      await repository.deleteAddress(address['id'] as String);
      if (mounted &&
          identical(repository, ref.read(customerRepositoryProvider))) {
        ref.invalidate(customerAddressesProvider);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.addressesDeleteError)));
      }
    } finally {
      if (mounted) setState(() => deleting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallback: '/profile'),
        title: Text(l.addressesTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: deleting == null
            ? () => context.push('/addresses/new')
            : null,
        icon: const Icon(Icons.add),
        label: Text(l.addressesAdd),
      ),
      body: AsyncContent(
        value: ref.watch(customerAddressesProvider),
        onRetry: () => ref.invalidate(customerAddressesProvider),
        builder: (items) => RefreshIndicator(
          onRefresh: () async {
            if (deleting == null) {
              ref.invalidate(customerAddressesProvider);
              await ref.read(customerAddressesProvider.future);
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: Text(l.addressesEmpty)),
                ),
              for (final address in items)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address['fullName'] as String? ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          [
                                address['country']?['name'],
                                address['city'],
                                address['streetLine1'],
                                address['streetLine2'],
                                address['postalCode'],
                                address['phoneNumber'],
                              ]
                              .whereType<String>()
                              .where((value) => value.isNotEmpty)
                              .join('\n'),
                        ),
                        if (address['defaultShippingAddress'] == true)
                          Chip(label: Text(l.addressesDefaultShipping)),
                        if (address['defaultBillingAddress'] == true)
                          Chip(label: Text(l.addressesDefaultBilling)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: deleting == null
                                  ? () => context.push(
                                      '/addresses/${Uri.encodeComponent(address['id'] as String)}',
                                    )
                                  : null,
                              icon: const Icon(Icons.edit_outlined),
                              label: Text(l.addressesEdit),
                            ),
                            IconButton(
                              tooltip: l.commonRemove,
                              onPressed: deleting == null
                                  ? () => remove(address)
                                  : null,
                              icon: deleting == address['id']
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
