import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tg.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('tg'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'MarketplaceAmid'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navCatalog.
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get navCatalog;

  /// No description provided for @navCart.
  ///
  /// In ru, this message translates to:
  /// **'Корзина'**
  String get navCart;

  /// No description provided for @navOrders.
  ///
  /// In ru, this message translates to:
  /// **'Заказы'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In ru, this message translates to:
  /// **'Валюта'**
  String get settingsCurrency;

  /// No description provided for @settingsTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get settingsTheme;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @languageRu.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRu;

  /// No description provided for @languageTg.
  ///
  /// In ru, this message translates to:
  /// **'Таджикский'**
  String get languageTg;

  /// No description provided for @languageEn.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get languageEn;

  /// No description provided for @commonLoading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка…'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get commonRetry;

  /// No description provided for @commonEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пусто'**
  String get commonEmpty;

  /// No description provided for @commonError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get commonError;

  /// No description provided for @homeWelcome.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать!'**
  String get homeWelcome;

  /// No description provided for @homeCurrentSettings.
  ///
  /// In ru, this message translates to:
  /// **'Текущие настройки'**
  String get homeCurrentSettings;

  /// No description provided for @fieldRequired.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get fieldRequired;

  /// No description provided for @fieldInvalidEmail.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный email'**
  String get fieldInvalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 6 символов'**
  String get passwordTooShort;

  /// No description provided for @emailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get passwordLabel;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginButton;

  /// No description provided for @registerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registerTitle;

  /// No description provided for @registerButton.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get registerButton;

  /// No description provided for @firstNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Фамилия'**
  String get lastNameLabel;

  /// No description provided for @noAccountPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта? Зарегистрироваться'**
  String get noAccountPrompt;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @logoutLabel.
  ///
  /// In ru, this message translates to:
  /// **'Выход'**
  String get logoutLabel;

  /// No description provided for @profileLabel.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileLabel;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In ru, this message translates to:
  /// **'Неверный email или пароль'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сети. Проверьте подключение'**
  String get authErrorNetwork;

  /// No description provided for @authErrorRegistrationFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось зарегистрироваться'**
  String get authErrorRegistrationFailed;

  /// No description provided for @authErrorNativeStrategy.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка настройки авторизации'**
  String get authErrorNativeStrategy;

  /// No description provided for @authErrorNotVerified.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт не подтверждён. Проверьте email'**
  String get authErrorNotVerified;

  /// No description provided for @authErrorMissingPassword.
  ///
  /// In ru, this message translates to:
  /// **'Не указан пароль'**
  String get authErrorMissingPassword;

  /// No description provided for @authErrorEmailTaken.
  ///
  /// In ru, this message translates to:
  /// **'Этот email уже зарегистрирован. Попробуйте войти'**
  String get authErrorEmailTaken;

  /// No description provided for @authErrorPasswordValidation.
  ///
  /// In ru, this message translates to:
  /// **'Пароль не соответствует требованиям'**
  String get authErrorPasswordValidation;

  /// No description provided for @phoneAuthTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход по телефону'**
  String get phoneAuthTitle;

  /// No description provided for @phoneLabel.
  ///
  /// In ru, this message translates to:
  /// **'Номер телефона'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In ru, this message translates to:
  /// **'+992 __ ______'**
  String get phoneHint;

  /// No description provided for @sendOtpButton.
  ///
  /// In ru, this message translates to:
  /// **'Получить код'**
  String get sendOtpButton;

  /// No description provided for @verificationMethodTitle.
  ///
  /// In ru, this message translates to:
  /// **'Куда отправить код?'**
  String get verificationMethodTitle;

  /// No description provided for @verificationWhatsApp.
  ///
  /// In ru, this message translates to:
  /// **'WhatsApp'**
  String get verificationWhatsApp;

  /// No description provided for @verificationTelegram.
  ///
  /// In ru, this message translates to:
  /// **'Telegram'**
  String get verificationTelegram;

  /// No description provided for @otpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили код на номер {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpSubtitleWhatsApp.
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили код в WhatsApp на номер {phone}'**
  String otpSubtitleWhatsApp(String phone);

  /// No description provided for @otpSubtitleTelegram.
  ///
  /// In ru, this message translates to:
  /// **'Введите код, который отправил Telegram-бот'**
  String get otpSubtitleTelegram;

  /// No description provided for @otpLabel.
  ///
  /// In ru, this message translates to:
  /// **'Код подтверждения'**
  String get otpLabel;

  /// No description provided for @verifyOtpButton.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get verifyOtpButton;

  /// No description provided for @changePhoneButton.
  ///
  /// In ru, this message translates to:
  /// **'Изменить номер'**
  String get changePhoneButton;

  /// No description provided for @telegramVerificationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение через Telegram'**
  String get telegramVerificationTitle;

  /// No description provided for @telegramVerificationDescription.
  ///
  /// In ru, this message translates to:
  /// **'Откройте бота и нажмите Start. Бот пришлёт шестизначный код подтверждения.'**
  String get telegramVerificationDescription;

  /// No description provided for @openTelegramButton.
  ///
  /// In ru, this message translates to:
  /// **'Открыть Telegram'**
  String get openTelegramButton;

  /// No description provided for @telegramWaitingMessage.
  ///
  /// In ru, this message translates to:
  /// **'Ожидаем сообщение боту…'**
  String get telegramWaitingMessage;

  /// No description provided for @authErrorInvalidPhone.
  ///
  /// In ru, this message translates to:
  /// **'Неверный формат номера'**
  String get authErrorInvalidPhone;

  /// No description provided for @authErrorInvalidOtp.
  ///
  /// In ru, this message translates to:
  /// **'Неверный код'**
  String get authErrorInvalidOtp;

  /// No description provided for @catalogHeading.
  ///
  /// In ru, this message translates to:
  /// **'Найдите то, что вам нужно'**
  String get catalogHeading;

  /// No description provided for @catalogSearch.
  ///
  /// In ru, this message translates to:
  /// **'Поиск товаров'**
  String get catalogSearch;

  /// No description provided for @catalogRetryCategories.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить категории'**
  String get catalogRetryCategories;

  /// No description provided for @catalogAllProducts.
  ///
  /// In ru, this message translates to:
  /// **'Все товары'**
  String get catalogAllProducts;

  /// No description provided for @catalogLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить товары. Проверьте подключение к серверу.'**
  String get catalogLoadError;

  /// No description provided for @catalogEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Товары не найдены'**
  String get catalogEmpty;

  /// No description provided for @catalogProductCount.
  ///
  /// In ru, this message translates to:
  /// **'Товаров: {total}'**
  String catalogProductCount(int total);

  /// No description provided for @commonRefresh.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get commonRefresh;

  /// No description provided for @cartEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Корзина пока пуста'**
  String get cartEmpty;

  /// No description provided for @cartBrowseProducts.
  ///
  /// In ru, this message translates to:
  /// **'Перейти к покупкам'**
  String get cartBrowseProducts;

  /// No description provided for @commonRemove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get commonRemove;

  /// No description provided for @cartDecreaseQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Уменьшить количество'**
  String get cartDecreaseQuantity;

  /// No description provided for @cartIncreaseQuantity.
  ///
  /// In ru, this message translates to:
  /// **'Увеличить количество'**
  String get cartIncreaseQuantity;

  /// No description provided for @cartShippingAtCheckout.
  ///
  /// In ru, this message translates to:
  /// **'Доставка рассчитывается при оформлении заказа.'**
  String get cartShippingAtCheckout;

  /// No description provided for @cartCheckout.
  ///
  /// In ru, this message translates to:
  /// **'Оформить заказ'**
  String get cartCheckout;

  /// No description provided for @commonPrevious.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get commonPrevious;

  /// No description provided for @commonNext.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get commonNext;

  /// No description provided for @productDetails.
  ///
  /// In ru, this message translates to:
  /// **'О товаре'**
  String get productDetails;

  /// No description provided for @productUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Товар не найден'**
  String get productUnavailable;

  /// No description provided for @productOutOfStock.
  ///
  /// In ru, this message translates to:
  /// **'Нет в наличии'**
  String get productOutOfStock;

  /// No description provided for @productInStock.
  ///
  /// In ru, this message translates to:
  /// **'В наличии'**
  String get productInStock;

  /// No description provided for @productDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get productDescription;

  /// No description provided for @ordersTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои заказы'**
  String get ordersTitle;

  /// No description provided for @sessionExpired.
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла. Войдите снова.'**
  String get sessionExpired;

  /// No description provided for @ordersEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Заказов пока нет'**
  String get ordersEmpty;

  /// No description provided for @orderUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Заказ не найден или недоступен'**
  String get orderUnavailable;

  /// No description provided for @orderItems.
  ///
  /// In ru, this message translates to:
  /// **'Состав заказа'**
  String get orderItems;

  /// No description provided for @orderRecipientAddress.
  ///
  /// In ru, this message translates to:
  /// **'Получатель и адрес'**
  String get orderRecipientAddress;

  /// No description provided for @sessionExpiredSignOut.
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла. Выйти'**
  String get sessionExpiredSignOut;

  /// No description provided for @commonSignOut.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get commonSignOut;

  /// No description provided for @profileSaved.
  ///
  /// In ru, this message translates to:
  /// **'Профиль сохранён'**
  String get profileSaved;

  /// No description provided for @profileSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить профиль'**
  String get profileSaveError;

  /// No description provided for @profileNameRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get profileNameRequired;

  /// No description provided for @commonSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get commonSave;

  /// No description provided for @formRequired.
  ///
  /// In ru, this message translates to:
  /// **'Заполните поле'**
  String get formRequired;

  /// No description provided for @addressRecipient.
  ///
  /// In ru, this message translates to:
  /// **'Имя получателя'**
  String get addressRecipient;

  /// No description provided for @addressCountry.
  ///
  /// In ru, this message translates to:
  /// **'Страна'**
  String get addressCountry;

  /// No description provided for @addressChooseCountry.
  ///
  /// In ru, this message translates to:
  /// **'Выберите страну'**
  String get addressChooseCountry;

  /// No description provided for @addressCity.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get addressCity;

  /// No description provided for @addressStreet.
  ///
  /// In ru, this message translates to:
  /// **'Улица, дом и квартира'**
  String get addressStreet;

  /// No description provided for @addressPostalCode.
  ///
  /// In ru, this message translates to:
  /// **'Почтовый индекс'**
  String get addressPostalCode;

  /// No description provided for @checkoutContinueDelivery.
  ///
  /// In ru, this message translates to:
  /// **'К доставке'**
  String get checkoutContinueDelivery;

  /// No description provided for @checkoutCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Заказ оформлен'**
  String get checkoutCompleted;

  /// No description provided for @checkoutTestOrder.
  ///
  /// In ru, this message translates to:
  /// **'Тестовый заказ'**
  String get checkoutTestOrder;

  /// No description provided for @checkoutContinueShopping.
  ///
  /// In ru, this message translates to:
  /// **'К покупкам'**
  String get checkoutContinueShopping;

  /// No description provided for @checkoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Оформление заказа'**
  String get checkoutTitle;

  /// No description provided for @checkoutTestNotice.
  ///
  /// In ru, this message translates to:
  /// **'Тестовое оформление без списания денег'**
  String get checkoutTestNotice;

  /// No description provided for @checkoutAddressStep.
  ///
  /// In ru, this message translates to:
  /// **'1. Получатель и адрес'**
  String get checkoutAddressStep;

  /// No description provided for @checkoutDeliveryStep.
  ///
  /// In ru, this message translates to:
  /// **'2. Доставка'**
  String get checkoutDeliveryStep;

  /// No description provided for @checkoutReviewStep.
  ///
  /// In ru, this message translates to:
  /// **'3. Проверка заказа'**
  String get checkoutReviewStep;

  /// No description provided for @checkoutOrderChanged.
  ///
  /// In ru, this message translates to:
  /// **'Заказ изменился. Вернитесь к адресу и проверьте сумму заново.'**
  String get checkoutOrderChanged;

  /// No description provided for @checkoutActionError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось выполнить действие. Проверьте соединение.'**
  String get checkoutActionError;

  /// No description provided for @checkoutEditAddress.
  ///
  /// In ru, this message translates to:
  /// **'Изменить адрес'**
  String get checkoutEditAddress;

  /// No description provided for @checkoutNoDelivery.
  ///
  /// In ru, this message translates to:
  /// **'Для этого адреса нет доступных способов доставки.'**
  String get checkoutNoDelivery;

  /// No description provided for @checkoutReview.
  ///
  /// In ru, this message translates to:
  /// **'Проверить заказ'**
  String get checkoutReview;

  /// No description provided for @checkoutNoPayment.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступного способа оплаты. Заказ сохранён в корзине.'**
  String get checkoutNoPayment;

  /// No description provided for @checkoutResponseLost.
  ///
  /// In ru, this message translates to:
  /// **'Ответ подтверждения не получен. Проверьте историю заказов перед повторным оформлением.'**
  String get checkoutResponseLost;

  /// No description provided for @ordersCheckHistory.
  ///
  /// In ru, this message translates to:
  /// **'Проверить мои заказы'**
  String get ordersCheckHistory;

  /// No description provided for @checkoutConfirmTestOrder.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить тестовый заказ'**
  String get checkoutConfirmTestOrder;

  /// No description provided for @cartAdding.
  ///
  /// In ru, this message translates to:
  /// **'Добавляем…'**
  String get cartAdding;

  /// No description provided for @cartAdd.
  ///
  /// In ru, this message translates to:
  /// **'В корзину'**
  String get cartAdd;

  /// No description provided for @cartAdded.
  ///
  /// In ru, this message translates to:
  /// **'Товар добавлен в корзину'**
  String get cartAdded;

  /// No description provided for @commonOpen.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get commonOpen;

  /// No description provided for @orderSubtotal.
  ///
  /// In ru, this message translates to:
  /// **'Товары'**
  String get orderSubtotal;

  /// No description provided for @orderShipping.
  ///
  /// In ru, this message translates to:
  /// **'Доставка'**
  String get orderShipping;

  /// No description provided for @orderTotal.
  ///
  /// In ru, this message translates to:
  /// **'Итого'**
  String get orderTotal;

  /// No description provided for @commonBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get commonBack;

  /// No description provided for @currencyTjs.
  ///
  /// In ru, this message translates to:
  /// **'TJS — Сомони'**
  String get currencyTjs;

  /// No description provided for @currencyUsd.
  ///
  /// In ru, this message translates to:
  /// **'USD — Доллар'**
  String get currencyUsd;

  /// No description provided for @currencyRub.
  ///
  /// In ru, this message translates to:
  /// **'RUB — Рубль'**
  String get currencyRub;

  /// No description provided for @cartStockError.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно товара в наличии'**
  String get cartStockError;

  /// No description provided for @cartLimitError.
  ///
  /// In ru, this message translates to:
  /// **'Достигнут лимит количества товаров'**
  String get cartLimitError;

  /// No description provided for @cartLoginRequired.
  ///
  /// In ru, this message translates to:
  /// **'Войдите, чтобы пользоваться корзиной'**
  String get cartLoginRequired;

  /// No description provided for @cartUpdateError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить корзину. Обновите её и повторите попытку.'**
  String get cartUpdateError;

  /// No description provided for @orderStatusAddingItems.
  ///
  /// In ru, this message translates to:
  /// **'В корзине'**
  String get orderStatusAddingItems;

  /// No description provided for @orderStatusArrangingPayment.
  ///
  /// In ru, this message translates to:
  /// **'Ожидает оплаты'**
  String get orderStatusArrangingPayment;

  /// No description provided for @orderStatusPaymentAuthorized.
  ///
  /// In ru, this message translates to:
  /// **'Оплата авторизована'**
  String get orderStatusPaymentAuthorized;

  /// No description provided for @orderStatusPaymentSettled.
  ///
  /// In ru, this message translates to:
  /// **'Оплачен'**
  String get orderStatusPaymentSettled;

  /// No description provided for @orderStatusPartiallyShipped.
  ///
  /// In ru, this message translates to:
  /// **'Частично отправлен'**
  String get orderStatusPartiallyShipped;

  /// No description provided for @orderStatusShipped.
  ///
  /// In ru, this message translates to:
  /// **'Отправлен'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusPartiallyDelivered.
  ///
  /// In ru, this message translates to:
  /// **'Частично доставлен'**
  String get orderStatusPartiallyDelivered;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In ru, this message translates to:
  /// **'Доставлен'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Отменён'**
  String get orderStatusCancelled;

  /// No description provided for @addressesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои адреса'**
  String get addressesTitle;

  /// No description provided for @addressesSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые адреса'**
  String get addressesSaved;

  /// No description provided for @addressesEnterManually.
  ///
  /// In ru, this message translates to:
  /// **'Ввести новый адрес'**
  String get addressesEnterManually;

  /// No description provided for @addressesAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить адрес'**
  String get addressesAdd;

  /// No description provided for @addressesEdit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить адрес'**
  String get addressesEdit;

  /// No description provided for @addressesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённых адресов пока нет'**
  String get addressesEmpty;

  /// No description provided for @addressesLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить сохранённые адреса'**
  String get addressesLoadError;

  /// No description provided for @addressesSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить адрес'**
  String get addressesSaveError;

  /// No description provided for @addressesDeleteError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить адрес'**
  String get addressesDeleteError;

  /// No description provided for @addressesDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить этот адрес?'**
  String get addressesDeleteConfirm;

  /// No description provided for @addressesDefaultShipping.
  ///
  /// In ru, this message translates to:
  /// **'Основной адрес доставки'**
  String get addressesDefaultShipping;

  /// No description provided for @addressesDefaultBilling.
  ///
  /// In ru, this message translates to:
  /// **'Основной платёжный адрес'**
  String get addressesDefaultBilling;

  /// No description provided for @addressDetails.
  ///
  /// In ru, this message translates to:
  /// **'Квартира и дополнительные сведения'**
  String get addressDetails;

  /// No description provided for @commonCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get commonCancel;

  /// No description provided for @productStore.
  ///
  /// In ru, this message translates to:
  /// **'Магазин: {name}'**
  String productStore(String name);

  /// No description provided for @openStore.
  ///
  /// In ru, this message translates to:
  /// **'Перейти в магазин'**
  String get openStore;

  /// No description provided for @storesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Магазины'**
  String get storesTitle;

  /// No description provided for @storesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Магазинов пока нет'**
  String get storesEmpty;

  /// No description provided for @storesLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить магазины'**
  String get storesLoadError;

  /// No description provided for @storeUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Магазин не найден'**
  String get storeUnavailable;

  /// No description provided for @storeCategories.
  ///
  /// In ru, this message translates to:
  /// **'Категории магазина'**
  String get storeCategories;

  /// No description provided for @storeProducts.
  ///
  /// In ru, this message translates to:
  /// **'Товары магазина'**
  String get storeProducts;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'tg'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tg':
      return AppLocalizationsTg();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
