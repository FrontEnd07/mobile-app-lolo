import 'package:ecommerce_new/shared/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:ecommerce_new/shared/lib/json.dart';
import 'package:ecommerce_new/shared/ui/inputs/phone_field.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({
    super.key,
    required this.countries,
    required this.initialAddress,
    required this.busy,
    required this.onSubmit,
    required this.submitLabel,
    this.additionalFields = const [],
  });
  final List<Json> countries;
  final String submitLabel;
  final List<Widget> additionalFields;
  final Json? initialAddress;
  final bool busy;
  final Future<void> Function(Json) onSubmit;
  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      street = TextEditingController(),
      city = TextEditingController(),
      postal = TextEditingController(),
      extra = TextEditingController();
  final phone = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.TJ, nsn: ''),
  );
  String? country;
  @override
  void initState() {
    super.initState();
    final address = widget.initialAddress;
    name.text = address?['fullName'] as String? ?? '';
    street.text = address?['streetLine1'] as String? ?? '';
    city.text = address?['city'] as String? ?? '';
    postal.text = address?['postalCode'] as String? ?? '';
    extra.text = address?['streetLine2'] as String? ?? '';
    final number = address?['phoneNumber'] as String?;
    if (number != null && number.isNotEmpty) {
      try {
        phone.value = PhoneNumber.parse(number);
      } catch (_) {
        /* Invalid stored number is re-entered. */
      }
    }
    country =
        address?['countryCode'] as String? ??
        (address?['country'] is Map
            ? address!['country']['code'] as String?
            : null) ??
        widget.countries
                .where((item) => item['name'] == address?['country'])
                .firstOrNull?['code']
            as String? ??
        (widget.countries.any((item) => item['code'] == 'TJ')
            ? 'TJ'
            : widget.countries.firstOrNull?['code'] as String?);
  }

  @override
  void dispose() {
    for (final controller in [name, street, city, postal, extra]) {
      controller.dispose();
    }
    phone.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (widget.busy || !(form.currentState?.validate() ?? false)) return;
    await widget.onSubmit({
      'fullName': name.text.trim(),
      'streetLine1': street.text.trim(),
      'streetLine2': extra.text.trim(),
      'city': city.text.trim(),
      'postalCode': postal.text.trim(),
      'countryCode': country!,
      'phoneNumber': phone.value.international,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget field(
      TextEditingController controller,
      String label, {
      bool required = true,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !widget.busy,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (value) =>
                  value == null || value.trim().isEmpty ? l.formRequired : null
            : null,
      ),
    );
    return Form(
      key: form,
      child: Column(
        children: [
          field(name, l.addressRecipient),
          PhoneField(controller: phone, enabled: !widget.busy),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: country,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.addressCountry),
            items: [
              for (final item in widget.countries)
                DropdownMenuItem(
                  value: item['code'] as String,
                  child: Text(
                    item['name'] as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: widget.busy
                ? null
                : (value) => setState(() => country = value),
            validator: (value) => value == null ? l.addressChooseCountry : null,
          ),
          const SizedBox(height: 16),
          field(city, l.addressCity),
          field(street, l.addressStreet),
          field(extra, l.addressDetails, required: false),
          field(postal, l.addressPostalCode, required: false),
          ...widget.additionalFields,
          FilledButton(
            onPressed: widget.busy || widget.countries.isEmpty ? null : submit,
            child: Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
