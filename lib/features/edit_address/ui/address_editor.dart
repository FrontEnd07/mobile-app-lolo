import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/ui/inputs/address_form.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';

class AddressEditor extends ConsumerStatefulWidget {
  const AddressEditor({super.key, this.address, required this.onSaved});
  final Json? address;
  final VoidCallback onSaved;
  @override
  ConsumerState<AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends ConsumerState<AddressEditor> {
  bool busy = false, shipping = false, billing = false;
  String? error;
  @override
  void initState() {
    super.initState();
    shipping = widget.address?['defaultShippingAddress'] == true;
    billing = widget.address?['defaultBillingAddress'] == true;
  }

  Future<void> save(Json input) async {
    if (busy) return;
    final l = AppLocalizations.of(context);
    final repository = ref.read(customerRepositoryProvider);
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await repository.saveAddress({
        ...input,
        'defaultShippingAddress': shipping,
        'defaultBillingAddress': billing,
      }, id: widget.address?['id'] as String?);
      if (!mounted ||
          !identical(repository, ref.read(customerRepositoryProvider))) {
        return;
      }
      ref.invalidate(customerAddressesProvider);
      widget.onSaved();
    } catch (_) {
      if (mounted) setState(() => error = l.addressesSaveError);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: !busy,
      child: AsyncContent(
        value: ref.watch(customerCountriesProvider),
        onRetry: () => ref.invalidate(customerCountriesProvider),
        builder: (countries) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            if (busy) const LinearProgressIndicator(),
            AddressForm(
              countries: countries,
              initialAddress: widget.address,
              busy: busy,
              submitLabel: l.commonSave,
              onSubmit: save,
              additionalFields: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.addressesDefaultShipping),
                  value: shipping,
                  onChanged: busy
                      ? null
                      : (value) => setState(() => shipping = value ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.addressesDefaultBilling),
                  value: billing,
                  onChanged: busy
                      ? null
                      : (value) => setState(() => billing = value ?? false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
