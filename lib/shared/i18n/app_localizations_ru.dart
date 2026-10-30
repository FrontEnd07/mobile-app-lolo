// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'LOLO';

  @override
  String get navHome => 'Главная';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Корзина';

  @override
  String get navOrders => 'Заказы';

  @override
  String get navProfile => 'Профиль';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsCurrency => 'Валюта';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountSubtitle =>
      'Запросить удаление аккаунта и персональных данных';

  @override
  String get deleteAccountConfirmation =>
      'Отправить запрос на удаление аккаунта? Команда LOLO проверит запрос и удалит или обезличит данные, кроме сведений, которые необходимо хранить по закону.';

  @override
  String get deleteAccountRequest => 'Отправить запрос';

  @override
  String get deleteAccountRequestReceived => 'Запрос на удаление принят';

  @override
  String get deleteAccountRequestError =>
      'Не удалось отправить запрос. Повторите попытку.';

  @override
  String get linkOpenError => 'Не удалось открыть ссылку';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageTg => 'Таджикский';

  @override
  String get languageEn => 'Английский';

  @override
  String get commonLoading => 'Загрузка…';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonEmpty => 'Пусто';

  @override
  String get commonError => 'Ошибка';

  @override
  String get pageNotFoundTitle => 'Страница не найдена';

  @override
  String get pageNotFoundDescription =>
      'Похоже, такой страницы больше нет или адрес указан неверно.';

  @override
  String get pageNotFoundHome => 'На главную';

  @override
  String get homeWelcome => 'Добро пожаловать!';

  @override
  String get homeCurrentSettings => 'Текущие настройки';

  @override
  String get fieldRequired => 'Обязательное поле';

  @override
  String get fieldInvalidEmail => 'Некорректный email';

  @override
  String get passwordTooShort => 'Минимум 6 символов';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginButton => 'Войти';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerButton => 'Зарегистрироваться';

  @override
  String get firstNameLabel => 'Имя';

  @override
  String get lastNameLabel => 'Фамилия';

  @override
  String get noAccountPrompt => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get alreadyHaveAccountPrompt => 'Уже есть аккаунт? Войти';

  @override
  String get logoutLabel => 'Выход';

  @override
  String get profileLabel => 'Профиль';

  @override
  String get authErrorInvalidCredentials => 'Неверный email или пароль';

  @override
  String get authErrorNetwork => 'Ошибка сети. Проверьте подключение';

  @override
  String get authErrorRegistrationFailed => 'Не удалось зарегистрироваться';

  @override
  String get authErrorNativeStrategy => 'Ошибка настройки авторизации';

  @override
  String get authErrorNotVerified => 'Аккаунт не подтверждён. Проверьте email';

  @override
  String get authErrorMissingPassword => 'Не указан пароль';

  @override
  String get authErrorEmailTaken =>
      'Этот email уже зарегистрирован. Попробуйте войти';

  @override
  String get authErrorPasswordValidation =>
      'Пароль не соответствует требованиям';

  @override
  String get phoneAuthTitle => 'Вход по телефону';

  @override
  String get phoneLabel => 'Номер телефона';

  @override
  String get phoneHint => '+992 __ ______';

  @override
  String get sendOtpButton => 'Получить код';

  @override
  String get verificationMethodTitle => 'Куда отправить код?';

  @override
  String get verificationWhatsApp => 'WhatsApp';

  @override
  String get verificationTelegram => 'Telegram';

  @override
  String get otpTitle => 'Введите код';

  @override
  String otpSubtitle(String phone) {
    return 'Мы отправили код на номер $phone';
  }

  @override
  String otpSubtitleWhatsApp(String phone) {
    return 'Мы отправили код в WhatsApp на номер $phone';
  }

  @override
  String get otpSubtitleTelegram =>
      'Введите код, который отправил Telegram-бот';

  @override
  String get otpLabel => 'Код подтверждения';

  @override
  String get verifyOtpButton => 'Подтвердить';

  @override
  String get changePhoneButton => 'Изменить номер';

  @override
  String get telegramVerificationTitle => 'Подтверждение через Telegram';

  @override
  String get telegramVerificationDescription =>
      'Откройте бота и нажмите Start. Бот пришлёт шестизначный код подтверждения.';

  @override
  String get openTelegramButton => 'Открыть Telegram';

  @override
  String get telegramWaitingMessage => 'Ожидаем сообщение боту…';

  @override
  String get authErrorInvalidPhone => 'Неверный формат номера';

  @override
  String get authErrorInvalidOtp => 'Неверный код';

  @override
  String get authErrorTelegramUnavailable =>
      'Telegram-бот сейчас недоступен. Переподключите его в админке.';

  @override
  String get authErrorWhatsAppUnavailable =>
      'WhatsApp сейчас недоступен. Переподключите его в админке.';

  @override
  String get authErrorOtpCooldown =>
      'Подождите минуту перед повторной отправкой кода.';

  @override
  String get authErrorVerificationFailed =>
      'Не удалось запросить код подтверждения.';

  @override
  String get catalogHeading => 'Найдите то, что вам нужно';

  @override
  String get catalogSearch => 'Поиск товаров';

  @override
  String get catalogRetryCategories => 'Загрузить категории';

  @override
  String get catalogAllProducts => 'Все товары';

  @override
  String get catalogLoadError =>
      'Не удалось загрузить товары. Проверьте подключение к серверу.';

  @override
  String get catalogEmpty => 'Товары не найдены';

  @override
  String catalogProductCount(int total) {
    return 'Товаров: $total';
  }

  @override
  String get commonRefresh => 'Обновить';

  @override
  String get cartEmpty => 'Корзина пока пуста';

  @override
  String get cartBrowseProducts => 'Перейти к покупкам';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get cartDecreaseQuantity => 'Уменьшить количество';

  @override
  String get cartIncreaseQuantity => 'Увеличить количество';

  @override
  String get cartShippingAtCheckout =>
      'Доставка рассчитывается при оформлении заказа.';

  @override
  String get cartCheckout => 'Оформить заказ';

  @override
  String get productDetails => 'О товаре';

  @override
  String get productUnavailable => 'Товар не найден';

  @override
  String get productOutOfStock => 'Нет в наличии';

  @override
  String get productInStock => 'В наличии';

  @override
  String get productDescription => 'Описание';

  @override
  String get ordersTitle => 'Мои заказы';

  @override
  String get sessionExpired => 'Сессия истекла. Войдите снова.';

  @override
  String get ordersEmpty => 'Заказов пока нет';

  @override
  String get orderUnavailable => 'Заказ не найден или недоступен';

  @override
  String get orderItems => 'Состав заказа';

  @override
  String get orderRecipientAddress => 'Получатель и адрес';

  @override
  String get sessionExpiredSignOut => 'Сессия истекла. Выйти';

  @override
  String get commonSignOut => 'Выйти';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get profileSaveError => 'Не удалось сохранить профиль';

  @override
  String get profileNameRequired => 'Введите имя';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get formRequired => 'Заполните поле';

  @override
  String get addressRecipient => 'Имя получателя';

  @override
  String get addressCountry => 'Страна';

  @override
  String get addressChooseCountry => 'Выберите страну';

  @override
  String get addressCity => 'Город';

  @override
  String get addressStreet => 'Улица, дом и квартира';

  @override
  String get addressPostalCode => 'Почтовый индекс';

  @override
  String get checkoutContinueDelivery => 'К доставке';

  @override
  String get checkoutCompleted => 'Заказ оформлен';

  @override
  String get checkoutTestOrder => 'Тестовый заказ';

  @override
  String get checkoutContinueShopping => 'К покупкам';

  @override
  String get checkoutTitle => 'Оформление заказа';

  @override
  String get checkoutTestNotice => 'Тестовое оформление без списания денег';

  @override
  String get checkoutAddressStep => '1. Получатель и адрес';

  @override
  String get checkoutDeliveryStep => '2. Доставка';

  @override
  String get checkoutReviewStep => '3. Проверка заказа';

  @override
  String get checkoutOrderChanged =>
      'Заказ изменился. Вернитесь к адресу и проверьте сумму заново.';

  @override
  String get checkoutActionError =>
      'Не удалось выполнить действие. Проверьте соединение.';

  @override
  String get checkoutEditAddress => 'Изменить адрес';

  @override
  String get checkoutNoDelivery =>
      'Для этого адреса нет доступных способов доставки.';

  @override
  String get checkoutReview => 'Проверить заказ';

  @override
  String get checkoutNoPayment =>
      'Нет доступного способа оплаты. Заказ сохранён в корзине.';

  @override
  String get checkoutResponseLost =>
      'Ответ подтверждения не получен. Проверьте историю заказов перед повторным оформлением.';

  @override
  String get ordersCheckHistory => 'Проверить мои заказы';

  @override
  String get checkoutConfirmTestOrder => 'Подтвердить тестовый заказ';

  @override
  String get cartAdding => 'Добавляем…';

  @override
  String get cartAdd => 'В корзину';

  @override
  String get cartAdded => 'Товар добавлен в корзину';

  @override
  String get commonOpen => 'Открыть';

  @override
  String get orderSubtotal => 'Товары';

  @override
  String get orderShipping => 'Доставка';

  @override
  String get orderTotal => 'Итого';

  @override
  String get commonBack => 'Назад';

  @override
  String get currencyTjs => 'TJS — Сомони';

  @override
  String get currencyUsd => 'USD — Доллар';

  @override
  String get currencyRub => 'RUB — Рубль';

  @override
  String get cartStockError => 'Недостаточно товара в наличии';

  @override
  String get cartLimitError => 'Достигнут лимит количества товаров';

  @override
  String get cartLoginRequired => 'Войдите, чтобы пользоваться корзиной';

  @override
  String get cartUpdateError =>
      'Не удалось обновить корзину. Обновите её и повторите попытку.';

  @override
  String get orderStatusAddingItems => 'В корзине';

  @override
  String get orderStatusArrangingPayment => 'Ожидает оплаты';

  @override
  String get orderStatusPaymentAuthorized => 'Оплата авторизована';

  @override
  String get orderStatusPaymentSettled => 'Оплачен';

  @override
  String get orderStatusPartiallyShipped => 'Частично отправлен';

  @override
  String get orderStatusShipped => 'Отправлен';

  @override
  String get orderStatusPartiallyDelivered => 'Частично доставлен';

  @override
  String get orderStatusDelivered => 'Доставлен';

  @override
  String get orderStatusCancelled => 'Отменён';

  @override
  String get addressesTitle => 'Мои адреса';

  @override
  String get addressesSaved => 'Сохранённые адреса';

  @override
  String get addressesEnterManually => 'Ввести новый адрес';

  @override
  String get addressesAdd => 'Добавить адрес';

  @override
  String get addressesEdit => 'Изменить адрес';

  @override
  String get addressesEmpty => 'Сохранённых адресов пока нет';

  @override
  String get addressesLoadError => 'Не удалось загрузить сохранённые адреса';

  @override
  String get addressesSaveError => 'Не удалось сохранить адрес';

  @override
  String get addressesDeleteError => 'Не удалось удалить адрес';

  @override
  String get addressesDeleteConfirm => 'Удалить этот адрес?';

  @override
  String get addressesDefaultShipping => 'Основной адрес доставки';

  @override
  String get addressesDefaultBilling => 'Основной платёжный адрес';

  @override
  String get addressDetails => 'Квартира и дополнительные сведения';

  @override
  String get commonCancel => 'Отмена';

  @override
  String productStore(String name) {
    return 'Магазин: $name';
  }

  @override
  String get openStore => 'Перейти в магазин';

  @override
  String get storesTitle => 'Магазины';

  @override
  String get storesEmpty => 'Магазинов пока нет';

  @override
  String get storesLoadError => 'Не удалось загрузить магазины';

  @override
  String get storeUnavailable => 'Магазин не найден';

  @override
  String get storeCategories => 'Категории магазина';

  @override
  String get storeProducts => 'Товары магазина';
}
