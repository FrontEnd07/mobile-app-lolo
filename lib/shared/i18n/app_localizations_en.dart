// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LOLO';

  @override
  String get navHome => 'Home';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCart => 'Cart';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle =>
      'Request deletion of your account and personal data';

  @override
  String get deleteAccountConfirmation =>
      'Submit an account deletion request? The LOLO team will review it and delete or anonymize your data, except information that must be retained by law.';

  @override
  String get deleteAccountRequest => 'Submit request';

  @override
  String get deleteAccountRequestReceived => 'Deletion request received';

  @override
  String get deleteAccountRequestError =>
      'The request could not be sent. Please retry.';

  @override
  String get linkOpenError => 'Could not open the link';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageRu => 'Russian';

  @override
  String get languageTg => 'Tajik';

  @override
  String get languageEn => 'English';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonEmpty => 'Empty';

  @override
  String get commonError => 'Error';

  @override
  String get pageNotFoundTitle => 'Page not found';

  @override
  String get pageNotFoundDescription =>
      'This page no longer exists or the address is incorrect.';

  @override
  String get pageNotFoundHome => 'Go home';

  @override
  String get homeWelcome => 'Welcome!';

  @override
  String get homeCurrentSettings => 'Current settings';

  @override
  String get fieldRequired => 'Required field';

  @override
  String get fieldInvalidEmail => 'Invalid email';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerTitle => 'Sign up';

  @override
  String get registerButton => 'Sign up';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get noAccountPrompt => 'No account? Sign up';

  @override
  String get alreadyHaveAccountPrompt => 'Already have an account? Sign in';

  @override
  String get logoutLabel => 'Log out';

  @override
  String get profileLabel => 'Profile';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password';

  @override
  String get authErrorNetwork => 'Network error. Check your connection';

  @override
  String get authErrorRegistrationFailed => 'Registration failed';

  @override
  String get authErrorNativeStrategy => 'Authentication configuration error';

  @override
  String get authErrorNotVerified => 'Account not verified. Check your email';

  @override
  String get authErrorMissingPassword => 'Password is required';

  @override
  String get authErrorEmailTaken =>
      'This email is already registered. Try signing in';

  @override
  String get authErrorPasswordValidation =>
      'Password does not meet requirements';

  @override
  String get phoneAuthTitle => 'Phone sign in';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '+992 __ ______';

  @override
  String get sendOtpButton => 'Get code';

  @override
  String get verificationMethodTitle => 'Where should we send the code?';

  @override
  String get verificationWhatsApp => 'WhatsApp';

  @override
  String get verificationTelegram => 'Telegram';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSubtitle(String phone) {
    return 'We sent a code to $phone';
  }

  @override
  String otpSubtitleWhatsApp(String phone) {
    return 'We sent a WhatsApp code to $phone';
  }

  @override
  String get otpSubtitleTelegram => 'Enter the code sent by the Telegram bot';

  @override
  String get otpSubtitlePlayReview =>
      'Enter the test code for the Google Play account';

  @override
  String get otpLabel => 'Verification code';

  @override
  String get verifyOtpButton => 'Confirm';

  @override
  String get changePhoneButton => 'Change number';

  @override
  String get telegramVerificationTitle => 'Verify with Telegram';

  @override
  String get telegramVerificationDescription =>
      'Open the bot and tap Start. The bot will send a six-digit verification code.';

  @override
  String get openTelegramButton => 'Open Telegram';

  @override
  String get telegramWaitingMessage => 'Waiting for your message to the bot…';

  @override
  String get authErrorInvalidPhone => 'Invalid phone format';

  @override
  String get authErrorInvalidOtp => 'Invalid code';

  @override
  String get authErrorTelegramUnavailable =>
      'The Telegram bot is currently unavailable. Reconnect it in the dashboard.';

  @override
  String get authErrorWhatsAppUnavailable =>
      'WhatsApp is currently unavailable. Reconnect it in the dashboard.';

  @override
  String get authErrorOtpCooldown =>
      'Wait one minute before requesting another code.';

  @override
  String get authErrorVerificationFailed =>
      'Could not request a verification code.';

  @override
  String get catalogHeading => 'Find your next favorite';

  @override
  String get catalogSearch => 'Search products';

  @override
  String get catalogRetryCategories => 'Retry categories';

  @override
  String get catalogAllProducts => 'All products';

  @override
  String get catalogLoadError =>
      'Cannot load products. Check the server connection.';

  @override
  String get catalogEmpty => 'No products found';

  @override
  String catalogProductCount(int total) {
    return '$total products';
  }

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartBrowseProducts => 'Browse products';

  @override
  String get commonRemove => 'Remove';

  @override
  String get cartDecreaseQuantity => 'Decrease quantity';

  @override
  String get cartIncreaseQuantity => 'Increase quantity';

  @override
  String get cartShippingAtCheckout => 'Shipping is calculated at checkout.';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get productDetails => 'Product details';

  @override
  String get productUnavailable => 'Product not found';

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get productInStock => 'In stock';

  @override
  String get productDescription => 'Description';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get sessionExpired => 'Session expired. Sign in again.';

  @override
  String get ordersEmpty => 'No orders yet';

  @override
  String get orderUnavailable => 'Order not found or unavailable';

  @override
  String get orderItems => 'Order items';

  @override
  String get orderRecipientAddress => 'Recipient and address';

  @override
  String get sessionExpiredSignOut => 'Session expired. Sign out';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveError => 'Could not save profile';

  @override
  String get profileNameRequired => 'Enter your name';

  @override
  String get commonSave => 'Save';

  @override
  String get formRequired => 'Required';

  @override
  String get addressRecipient => 'Recipient name';

  @override
  String get addressCountry => 'Country';

  @override
  String get addressChooseCountry => 'Choose country';

  @override
  String get addressCity => 'City';

  @override
  String get addressStreet => 'Street and apartment';

  @override
  String get addressPostalCode => 'Postal code';

  @override
  String get checkoutContinueDelivery => 'Continue to delivery';

  @override
  String get checkoutCompleted => 'Order placed';

  @override
  String get checkoutTestOrder => 'Test order';

  @override
  String get checkoutContinueShopping => 'Continue shopping';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutTestNotice => 'Test checkout — no money charged';

  @override
  String get checkoutAddressStep => '1. Recipient and address';

  @override
  String get checkoutDeliveryStep => '2. Delivery';

  @override
  String get checkoutReviewStep => '3. Review order';

  @override
  String get checkoutOrderChanged =>
      'Order changed. Review the address and total again.';

  @override
  String get checkoutActionError =>
      'Could not complete this step. Check connection.';

  @override
  String get checkoutEditAddress => 'Edit address';

  @override
  String get checkoutNoDelivery => 'No delivery methods for this address.';

  @override
  String get checkoutReview => 'Review order';

  @override
  String get checkoutNoPayment =>
      'No payment methods available. Your cart is saved.';

  @override
  String get checkoutResponseLost =>
      'Confirmation response was lost. Check your order history before retrying.';

  @override
  String get ordersCheckHistory => 'Check my orders';

  @override
  String get checkoutConfirmTestOrder => 'Place test order';

  @override
  String get cartAdding => 'Adding…';

  @override
  String get cartAdd => 'Add to cart';

  @override
  String get cartAdded => 'Added to cart';

  @override
  String get commonOpen => 'Open';

  @override
  String get orderSubtotal => 'Subtotal';

  @override
  String get orderShipping => 'Shipping';

  @override
  String get orderTotal => 'Total';

  @override
  String get commonBack => 'Back';

  @override
  String get currencyTjs => 'TJS — Somoni';

  @override
  String get currencyUsd => 'USD — Dollar';

  @override
  String get currencyRub => 'RUB — Ruble';

  @override
  String get cartStockError => 'Not enough stock';

  @override
  String get cartLimitError => 'Order quantity limit reached';

  @override
  String get cartLoginRequired => 'Sign in to use your cart';

  @override
  String get cartUpdateError => 'Could not update cart. Refresh it and retry.';

  @override
  String get orderStatusAddingItems => 'In cart';

  @override
  String get orderStatusArrangingPayment => 'Awaiting payment';

  @override
  String get orderStatusPaymentAuthorized => 'Payment authorized';

  @override
  String get orderStatusPaymentSettled => 'Paid';

  @override
  String get orderStatusPartiallyShipped => 'Partially shipped';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusPartiallyDelivered => 'Partially delivered';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get addressesTitle => 'My addresses';

  @override
  String get addressesSaved => 'Saved addresses';

  @override
  String get addressesEnterManually => 'Enter a new address';

  @override
  String get addressesAdd => 'Add address';

  @override
  String get addressesEdit => 'Edit address';

  @override
  String get addressesEmpty => 'No saved addresses yet';

  @override
  String get addressesLoadError => 'Could not load saved addresses';

  @override
  String get addressesSaveError => 'Could not save address';

  @override
  String get addressesDeleteError => 'Could not remove address';

  @override
  String get addressesDeleteConfirm => 'Remove this address?';

  @override
  String get addressesDefaultShipping => 'Default shipping address';

  @override
  String get addressesDefaultBilling => 'Default billing address';

  @override
  String get addressDetails => 'Apartment and address details';

  @override
  String get commonCancel => 'Cancel';

  @override
  String productStore(String name) {
    return 'Store: $name';
  }

  @override
  String get openStore => 'Open store';

  @override
  String get storesTitle => 'Stores';

  @override
  String get storesEmpty => 'No stores yet';

  @override
  String get storesLoadError => 'Could not load stores';

  @override
  String get storeUnavailable => 'Store not found';

  @override
  String get storeCategories => 'Store categories';

  @override
  String get storeProducts => 'Store products';
}
