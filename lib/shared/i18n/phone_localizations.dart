import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// The package has no Tajik translations. Keep app labels in Tajik and
/// fall back to Russian for the country picker and package-provided strings.
final phoneLocalizationsDelegates = PhoneFieldLocalization.delegates
    .map((delegate) => _PhoneLocalizationFallback(delegate))
    .toList(growable: false);

class _PhoneLocalizationFallback<T> extends LocalizationsDelegate<T> {
  const _PhoneLocalizationFallback(this.delegate);
  final LocalizationsDelegate<T> delegate;

  @override
  Type get type => delegate.type;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'tg' || delegate.isSupported(locale);

  @override
  Future<T> load(Locale locale) =>
      delegate.load(locale.languageCode == 'tg' ? const Locale('ru') : locale);

  @override
  bool shouldReload(covariant _PhoneLocalizationFallback<T> old) =>
      delegate.shouldReload(old.delegate);
}
