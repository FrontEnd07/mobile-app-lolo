// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appTitle => 'LOLO';

  @override
  String get navHome => 'Асосӣ';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Сабад';

  @override
  String get navOrders => 'Фармоишҳо';

  @override
  String get navProfile => 'Профил';

  @override
  String get settingsTitle => 'Танзимот';

  @override
  String get settingsLanguage => 'Забон';

  @override
  String get settingsCurrency => 'Асъор';

  @override
  String get settingsTheme => 'Мавзӯъ';

  @override
  String get privacyPolicy => 'Сиёсати махфият';

  @override
  String get deleteAccount => 'Нест кардани ҳисоб';

  @override
  String get deleteAccountSubtitle =>
      'Дархости нест кардани ҳисоб ва маълумоти шахсӣ';

  @override
  String get deleteAccountConfirmation =>
      'Дархости нест кардани ҳисоб фиристода шавад? Дастаи LOLO онро месанҷад ва маълумотро нест ё беном мекунад, ба истиснои маълумоте, ки тибқи қонун нигоҳ доштан лозим аст.';

  @override
  String get deleteAccountRequest => 'Фиристодани дархост';

  @override
  String get deleteAccountRequestReceived => 'Дархости несткунӣ қабул шуд';

  @override
  String get deleteAccountRequestError =>
      'Дархост фиристода нашуд. Дубора кӯшиш кунед.';

  @override
  String get linkOpenError => 'Кушодани пайванд имкон нашуд';

  @override
  String get themeLight => 'Равшан';

  @override
  String get themeDark => 'Торик';

  @override
  String get themeSystem => 'Системавӣ';

  @override
  String get languageRu => 'Русӣ';

  @override
  String get languageTg => 'Тоҷикӣ';

  @override
  String get languageEn => 'Англисӣ';

  @override
  String get commonLoading => 'Боргирӣ…';

  @override
  String get commonRetry => 'Такрор';

  @override
  String get commonEmpty => 'Холӣ';

  @override
  String get commonError => 'Хатогӣ';

  @override
  String get pageNotFoundTitle => 'Саҳифа ёфт нашуд';

  @override
  String get pageNotFoundDescription =>
      'Чунин саҳифа вуҷуд надорад ё суроға нодуруст навишта шудааст.';

  @override
  String get pageNotFoundHome => 'Ба саҳифаи асосӣ';

  @override
  String get homeWelcome => 'Хуш омадед!';

  @override
  String get homeCurrentSettings => 'Танзимоти ҷорӣ';

  @override
  String get fieldRequired => 'Майдони ҳатмӣ';

  @override
  String get fieldInvalidEmail => 'Email нодуруст';

  @override
  String get passwordTooShort => 'Ҳадди ақал 6 аломат';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Рамз';

  @override
  String get loginTitle => 'Даромадан';

  @override
  String get loginButton => 'Даромадан';

  @override
  String get registerTitle => 'Бақайдгирӣ';

  @override
  String get registerButton => 'Бақайд гирифтан';

  @override
  String get firstNameLabel => 'Ном';

  @override
  String get lastNameLabel => 'Насаб';

  @override
  String get noAccountPrompt => 'Ҳисоб надоред? Бақайд гиред';

  @override
  String get alreadyHaveAccountPrompt => 'Ҳисоб доред? Дароед';

  @override
  String get logoutLabel => 'Баромадан';

  @override
  String get profileLabel => 'Профил';

  @override
  String get authErrorInvalidCredentials => 'Email ё рамз нодуруст';

  @override
  String get authErrorNetwork => 'Хатои шабака. Пайвастагиро тафтиш кунед';

  @override
  String get authErrorRegistrationFailed => 'Бақайдгирӣ муваффақ нашуд';

  @override
  String get authErrorNativeStrategy => 'Хатои танзими authorization';

  @override
  String get authErrorNotVerified =>
      'Ҳисоб тасдиқ нашудааст. Email-ро тафтиш кунед';

  @override
  String get authErrorMissingPassword => 'Рамз нишон дода нашудааст';

  @override
  String get authErrorEmailTaken =>
      'Ин email аллакай бақайд гирифта шудааст. Дароед';

  @override
  String get authErrorPasswordValidation => 'Рамз ба талабот ҷавобгӯ нест';

  @override
  String get phoneAuthTitle => 'Даромадан бо телефон';

  @override
  String get phoneLabel => 'Рақами телефон';

  @override
  String get phoneHint => '+992 __ ______';

  @override
  String get sendOtpButton => 'Гирифтани код';

  @override
  String get verificationMethodTitle => 'Кодро ба куҷо фиристем?';

  @override
  String get verificationWhatsApp => 'WhatsApp';

  @override
  String get verificationTelegram => 'Telegram';

  @override
  String get otpTitle => 'Кодро ворид кунед';

  @override
  String otpSubtitle(String phone) {
    return 'Мо кодро ба $phone фиристодем';
  }

  @override
  String otpSubtitleWhatsApp(String phone) {
    return 'Мо кодро ба WhatsApp-и рақами $phone фиристодем';
  }

  @override
  String get otpSubtitleTelegram =>
      'Коди фиристодаи Telegram-ботро ворид кунед';

  @override
  String get otpSubtitlePlayReview =>
      'Рамзи санҷиширо барои ҳисоби Google Play ворид кунед';

  @override
  String get otpLabel => 'Коди тасдиқ';

  @override
  String get verifyOtpButton => 'Тасдиқ';

  @override
  String get changePhoneButton => 'Ивази рақам';

  @override
  String get telegramVerificationTitle => 'Тасдиқ тавассути Telegram';

  @override
  String get telegramVerificationDescription =>
      'Ботро кушоед ва Start-ро пахш кунед. Бот коди шашрақамаи тасдиқро мефиристад.';

  @override
  String get openTelegramButton => 'Кушодани Telegram';

  @override
  String get telegramWaitingMessage => 'Паёми шумо ба ботро интизорем…';

  @override
  String get authErrorInvalidPhone => 'Формати рақам нодуруст';

  @override
  String get authErrorInvalidOtp => 'Код нодуруст';

  @override
  String get authErrorTelegramUnavailable =>
      'Боти Telegram ҳоло дастнорас аст. Онро дар админка дубора пайваст кунед.';

  @override
  String get authErrorWhatsAppUnavailable =>
      'WhatsApp ҳоло дастнорас аст. Онро дар админка дубора пайваст кунед.';

  @override
  String get authErrorOtpCooldown =>
      'Пеш аз дархости рамзи нав як дақиқа интизор шавед.';

  @override
  String get authErrorVerificationFailed => 'Дархости рамзи тасдиқ иҷро нашуд.';

  @override
  String get catalogHeading => 'Он чизеро, ки лозим аст, ёбед';

  @override
  String get catalogSearch => 'Ҷустуҷӯи молҳо';

  @override
  String get catalogRetryCategories => 'Категорияҳоро бор кунед';

  @override
  String get catalogAllProducts => 'Ҳамаи молҳо';

  @override
  String get catalogLoadError => 'Молҳо бор нашуданд. Пайвастшавиро санҷед.';

  @override
  String get catalogEmpty => 'Молҳо ёфт нашуданд';

  @override
  String catalogProductCount(int total) {
    return '$total мол';
  }

  @override
  String get commonRefresh => 'Навсозӣ';

  @override
  String get cartEmpty => 'Сабад холӣ аст';

  @override
  String get cartBrowseProducts => 'Харид кардан';

  @override
  String get commonRemove => 'Нест кардан';

  @override
  String get cartDecreaseQuantity => 'Кам кардан';

  @override
  String get cartIncreaseQuantity => 'Зиёд кардан';

  @override
  String get cartShippingAtCheckout =>
      'Расонидан ҳангоми фармоиш ҳисоб карда мешавад.';

  @override
  String get cartCheckout => 'Оформ кардани фармоиш';

  @override
  String get productDetails => 'Дар бораи мол';

  @override
  String get productUnavailable => 'Мол ёфт нашуд';

  @override
  String get productOutOfStock => 'Мавҷуд нест';

  @override
  String get productInStock => 'Мавҷуд аст';

  @override
  String get productDescription => 'Тавсиф';

  @override
  String get ordersTitle => 'Фармоишҳои ман';

  @override
  String get sessionExpired => 'Дубора ворид шавед.';

  @override
  String get ordersEmpty => 'Фармоишҳо ҳоло нестанд';

  @override
  String get orderUnavailable => 'Фармоиш ёфт нашуд';

  @override
  String get orderItems => 'Молҳои фармоиш';

  @override
  String get orderRecipientAddress => 'Қабулкунанда ва суроға';

  @override
  String get sessionExpiredSignOut => 'Сессия ба охир расид. Баромадан';

  @override
  String get commonSignOut => 'Баромадан';

  @override
  String get profileSaved => 'Профил нигоҳ дошта шуд';

  @override
  String get profileSaveError => 'Профил нигоҳ дошта нашуд';

  @override
  String get profileNameRequired => 'Номро ворид кунед';

  @override
  String get commonSave => 'Нигоҳ доштан';

  @override
  String get formRequired => 'Майдонро пур кунед';

  @override
  String get addressRecipient => 'Номи қабулкунанда';

  @override
  String get addressCountry => 'Кишвар';

  @override
  String get addressChooseCountry => 'Кишварро интихоб кунед';

  @override
  String get addressCity => 'Шаҳр';

  @override
  String get addressStreet => 'Кӯча, хона ва ҳуҷра';

  @override
  String get addressPostalCode => 'Индекси почта';

  @override
  String get checkoutContinueDelivery => 'Ба расонидан';

  @override
  String get checkoutCompleted => 'Фармоиш қабул шуд';

  @override
  String get checkoutTestOrder => 'Фармоиши санҷишӣ';

  @override
  String get checkoutContinueShopping => 'Харид кардан';

  @override
  String get checkoutTitle => 'Оформ кардани фармоиш';

  @override
  String get checkoutTestNotice => 'Оформ кардани санҷишӣ бе пардохт';

  @override
  String get checkoutAddressStep => '1. Қабулкунанда ва суроға';

  @override
  String get checkoutDeliveryStep => '2. Расонидан';

  @override
  String get checkoutReviewStep => '3. Санҷиши фармоиш';

  @override
  String get checkoutOrderChanged =>
      'Фармоиш тағйир ёфт. Маблағро дубора санҷед.';

  @override
  String get checkoutActionError => 'Амал иҷро нашуд. Пайвастшавиро санҷед.';

  @override
  String get checkoutEditAddress => 'Тағйири суроға';

  @override
  String get checkoutNoDelivery => 'Барои ин суроға расонидан дастрас нест.';

  @override
  String get checkoutReview => 'Санҷидани фармоиш';

  @override
  String get checkoutNoPayment => 'Усули пардохт дастрас нест.';

  @override
  String get checkoutResponseLost =>
      'Ҷавоби тасдиқ нарасид. Таърихи фармоишҳоро санҷед.';

  @override
  String get ordersCheckHistory => 'Санҷиши фармоишҳои ман';

  @override
  String get checkoutConfirmTestOrder => 'Тасдиқи фармоиши санҷишӣ';

  @override
  String get cartAdding => 'Илова…';

  @override
  String get cartAdd => 'Ба сабад';

  @override
  String get cartAdded => 'Мол ба сабад илова шуд';

  @override
  String get commonOpen => 'Кушодан';

  @override
  String get orderSubtotal => 'Молҳо';

  @override
  String get orderShipping => 'Расонидан';

  @override
  String get orderTotal => 'Ҳамагӣ';

  @override
  String get commonBack => 'Қафо';

  @override
  String get currencyTjs => 'TJS — Сомонӣ';

  @override
  String get currencyUsd => 'USD — Доллар';

  @override
  String get currencyRub => 'RUB — Рубл';

  @override
  String get cartStockError => 'Мол ба миқдори кофӣ нест';

  @override
  String get cartLimitError => 'Ҳадди миқдори молҳо расид';

  @override
  String get cartLoginRequired => 'Барои сабад ворид шавед';

  @override
  String get cartUpdateError => 'Сабад нав нашуд. Навсозӣ карда такрор кунед.';

  @override
  String get orderStatusAddingItems => 'Дар сабад';

  @override
  String get orderStatusArrangingPayment => 'Интизори пардохт';

  @override
  String get orderStatusPaymentAuthorized => 'Пардохт тасдиқ шуд';

  @override
  String get orderStatusPaymentSettled => 'Пардохт шуд';

  @override
  String get orderStatusPartiallyShipped => 'Қисман фиристода шуд';

  @override
  String get orderStatusShipped => 'Фиристода шуд';

  @override
  String get orderStatusPartiallyDelivered => 'Қисман расид';

  @override
  String get orderStatusDelivered => 'Расонида шуд';

  @override
  String get orderStatusCancelled => 'Бекор шуд';

  @override
  String get addressesTitle => 'Суроғаҳои ман';

  @override
  String get addressesSaved => 'Суроғаҳои нигоҳдошта';

  @override
  String get addressesEnterManually => 'Суроғаи навро ворид кунед';

  @override
  String get addressesAdd => 'Илова кардани суроға';

  @override
  String get addressesEdit => 'Тағйири суроға';

  @override
  String get addressesEmpty => 'Суроғаҳои нигоҳдошта ҳоло нестанд';

  @override
  String get addressesLoadError => 'Суроғаҳо бор нашуданд';

  @override
  String get addressesSaveError => 'Суроға нигоҳ дошта нашуд';

  @override
  String get addressesDeleteError => 'Суроға нест карда нашуд';

  @override
  String get addressesDeleteConfirm => 'Ин суроғаро нест мекунед?';

  @override
  String get addressesDefaultShipping => 'Суроғаи асосии расонидан';

  @override
  String get addressesDefaultBilling => 'Суроғаи асосии пардохт';

  @override
  String get addressDetails => 'Ҳуҷра ва маълумоти иловагӣ';

  @override
  String get commonCancel => 'Бекор кардан';

  @override
  String productStore(String name) {
    return 'Мағоза: $name';
  }

  @override
  String get openStore => 'Кушодани мағоза';

  @override
  String get storesTitle => 'Мағозаҳо';

  @override
  String get storesEmpty => 'Ҳоло мағоза нест';

  @override
  String get storesLoadError => 'Мағозаҳоро бор карда нашуд';

  @override
  String get storeUnavailable => 'Мағоза ёфт нашуд';

  @override
  String get storeCategories => 'Категорияҳои мағоза';

  @override
  String get storeProducts => 'Маҳсулоти мағоза';
}
