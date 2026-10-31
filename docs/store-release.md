# LOLO: публикация в Google Play и App Store

## Идентификаторы и версия

- Название: `LOLO`
- Android application ID: `tj.lolo.app`
- Apple bundle ID: `tj.lolo.app`
- Production Shop API: `https://lolo.tj/shop-api`
- Текущая версия: `1.0.0+1`

После первой публикации идентификаторы менять нельзя. Для каждого обновления
увеличивайте build number после `+` в `pubspec.yaml`.

## Обязательные блокеры перед модерацией

1. Опубликовать политику конфиденциальности на `https://lolo.tj/privacy`.
2. После развёртывания текущих изменений проверить удаление аккаунта:
   - кнопка находится в настройках авторизованного пользователя;
   - публичная страница будет доступна на `https://lolo.tj/account/delete`;
   - запросы обрабатывает SuperAdmin в разделе «Контент → Удаление аккаунтов»;
   - перевод запроса в статус «Завершён» удаляет адреса, обезличивает профиль и
     отключает учётную запись; сведения заказов, обязательные по закону, остаются;
   - этот URL нужно указать в Google Play Console.
3. Настроить production-канал Vendure: нужные валюты, доставка и реальная
   оплата вместо тестового payment handler.
4. Подготовить отдельный аккаунт покупателя для App Review и инструкции по
   получению OTP. Для Google Play используется reviewer-номер
   `+992000001234` и приватный код из production-переменной `PLAY_REVIEW_OTP`.
5. Проверить юридические тексты и сроки хранения заказов с юристом.

## Данные, которые нужно задекларировать

Проверьте фактическую production-конфигурацию перед заполнением форм магазинов.
Текущий клиент работает со следующими категориями данных:

- телефон и идентификатор пользователя;
- имя, фамилия и необязательный email;
- адрес доставки;
- корзина, заказы и история покупок;
- токен авторизации, сохранённый в защищённом хранилище устройства;
- технические сетевые данные, которые автоматически получает сервер.

В приложении сейчас нет рекламного SDK и намеренного межсайтового трекинга.
Это нужно повторно проверить по production-инфраструктуре и политикам Telegram,
WhatsApp, платёжного и аналитического провайдеров.

## Google Play

### 1. Принять лицензии SDK

Лицензии принимает владелец рабочей станции:

```powershell
flutter doctor --android-licenses
```

### 2. Создать upload key

Постоянный upload key и `key.properties` хранятся в приватном репозитории по
решению владельца проекта. Ограничьте доступ к репозиторию и сохраните ещё одну
зашифрованную резервную копию вне GitHub.

```powershell
keytool -genkeypair -v `
  -keystore android/upload-keystore.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload
Copy-Item android/key.properties.example android/key.properties
```

Заполните `android/key.properties`. Включите Play App Signing при создании
первого релиза.

### 3. Собрать Android App Bundle

```powershell
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release `
  --obfuscate `
  --split-debug-info=build/symbols/android
```

AAB появится в `build/app/outputs/bundle/release/app-release.aab`. Сохраните
папку символов рядом с артефактами релиза для расшифровки crash stack traces.

Проект нацелен на Android API 36. Перед загрузкой заполните Data safety,
Data deletion, Content rating, Target audience, App access и раздел рекламы.

Готовые материалы карточки Google Play:

- иконка 512×512: `assets/store/google-play/app-icon-512.png`;
- feature graphic 1024×500: `assets/store/google-play/feature-graphic-1024x500.png`.

Для скриншотов нужны реальные экраны production-сборки: телефон, каталог,
карточка товара, магазин, корзина и профиль. Не используйте мокапы функций,
которых ещё нет в production.

## App Store

Финальная iOS-сборка выполняется только на macOS с Xcode 26 или новее.

1. Зарегистрируйте Bundle ID `tj.lolo.app` в Apple Developer.
2. Откройте `ios/Runner.xcworkspace` и выберите Apple Developer Team.
3. Проверьте Signing & Capabilities для конфигурации Release.
4. Выполните:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios
```

5. Загрузите IPA через Xcode Organizer или Transporter.
6. В App Store Connect заполните App Privacy, Privacy Policy URL, возрастной
   рейтинг, контакты, скриншоты и Review Notes. Укажите тестовый аккаунт и
   пошаговое получение OTP.

`ITSAppUsesNonExemptEncryption` установлен в `false`, поскольку клиент
использует стандартное HTTPS-шифрование операционной системы. Перепроверьте это,
если добавите собственную криптографию или новый SDK.

## Проверка перед каждым релизом

- backend доступен и использует HTTPS;
- регистрация, вход, восстановление сессии и удаление аккаунта работают;
- каталог, магазины, карточка товара, корзина и оформление заказа работают;
- выбранные валюты доступны в production-канале;
- ссылки политики и удаления аккаунта открываются без авторизации;
- нет тестовых способов оплаты, тестовых данных и отладочных endpoint;
- номер версии и build number увеличены;
- release-пакет подписан production upload key;
- сохранены AAB/IPA и symbol files;
- скриншоты соответствуют реальному интерфейсу текущей версии.
