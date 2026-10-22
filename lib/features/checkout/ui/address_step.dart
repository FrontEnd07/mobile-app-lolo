import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_new/entities/customer/index.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/inputs/address_form.dart';
import 'package:ecommerce_new/shared/ui/feedback/async_content.dart';

class AddressStep extends ConsumerStatefulWidget {
  const AddressStep({
    super.key,
    required this.countries,
    required this.initialAddress,
    required this.busy,
    required this.onSubmit,
  });
  final List<Json> countries;
  final Json? initialAddress;
  final bool busy;
  final Future<void> Function(Json) onSubmit;
  @override
  ConsumerState<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends ConsumerState<AddressStep> {
  String? selected;
  Widget form(Json? address, String key) => AddressForm(
    key: ValueKey(key),
    countries: widget.countries,
    initialAddress: address,
    busy: widget.busy,
    onSubmit: widget.onSubmit,
    submitLabel: AppLocalizations.of(context).checkoutContinueDelivery,
  );
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final addresses = ref.watch(customerAddressesProvider);
    return addresses.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Column(
        children: [
          RetryView(
            message: l.addressesLoadError,
            onRetry: () => ref.invalidate(customerAddressesProvider),
          ),
          form(widget.initialAddress, 'manual'),
        ],
      ),
      data: (items) {
        final hasInitial =
            (widget.initialAddress?['streetLine1'] as String?)?.isNotEmpty ==
            true;
        final defaultAddress = items
            .where((item) => item['defaultShippingAddress'] == true)
            .firstOrNull;
        final selectedExists = items.any((item) => item['id'] == selected);
        final choice = selectedExists
            ? selected!
            : hasInitial
            ? 'manual'
            : defaultAddress?['id'] as String? ?? 'manual';
        final saved = items.where((item) => item['id'] == choice).firstOrNull;
        return Column(
          children: [
            if (items.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                key: ValueKey(choice),
                initialValue: choice,
                isExpanded: true,
                decoration: InputDecoration(labelText: l.addressesSaved),
                items: [
                  DropdownMenuItem(
                    value: 'manual',
                    child: Text(l.addressesEnterManually),
                  ),
                  for (final item in items)
                    DropdownMenuItem(
                      value: item['id'] as String,
                      child: Text(
                        '${item['city']}, ${item['streetLine1']}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: widget.busy
                    ? null
                    : (value) => setState(() => selected = value),
              ),
              const SizedBox(height: 16),
            ],
            form(
              saved ?? (selected == 'manual' ? null : widget.initialAddress),
              choice,
            ),
          ],
        );
      },
    );
  }
}
