import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:ecommerce_new/shared/i18n/app_localizations.dart';

/// International mobile phone input. The controller exposes an E.164 number.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.autofocus = false,
    this.onSubmitted,
    this.enabled = true,
  });

  final PhoneController controller;
  final String? labelText;
  final String? hintText;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PhoneFormField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumber],
      countrySelectorNavigator:
          const CountrySelectorNavigator.draggableBottomSheet(
            favorites: [IsoCode.TJ, IsoCode.RU, IsoCode.UZ, IsoCode.KZ],
          ),
      countryButtonStyle: const CountryButtonStyle(
        showDialCode: true,
        showIsoCode: false,
        showFlag: true,
      ),
      validator: PhoneValidator.compose([
        PhoneValidator.required(context, errorText: l.fieldRequired),
        PhoneValidator.validMobile(context, errorText: l.authErrorInvalidPhone),
      ]),
      decoration: InputDecoration(
        labelText: labelText ?? l.phoneLabel,
        hintText: hintText,
      ),
      onSubmitted: (phone) => onSubmitted?.call(phone.international),
    );
  }
}
