# Dino Home iOS

Нативная SwiftUI-оболочка для домашней консоли Dino TV. Структура повторяет подход Clino: исходники отдельно, проект генерируется через XcodeGen и готовится к TestFlight.

## Локальный запуск

1. Установите [XcodeGen](https://github.com/yonaskolb/XcodeGen).
2. В этой папке выполните `xcodegen generate`.
3. Откройте `DinoHome.xcodeproj`, выберите свою Team и уникальный Bundle ID.
4. Archive → Distribute App → TestFlight.

Пока Mini App авторизуется через Telegram `initData`. Перед релизом iOS нужно добавить отдельный QR/pairing-вход, чтобы приложение не зависело от Telegram-сессии.

## Sideload IPA

На GitHub Actions есть ручной workflow **iOS Device IPA (Sideload)**. Он не запускается с пуша: Actions → workflow → Run workflow. Артефакт `DinoHome-Device.ipa` ставится на телефон по проводу через Sideloadly / Apple Configurator.

Локально то же самое:

```bash
xcodegen generate
xcodebuild \
  -project DinoHome.xcodeproj \
  -scheme DinoHome \
  -configuration Release \
  -sdk iphoneos \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGN_ENTITLEMENTS=DinoHome/DinoHome-Sideload.entitlements \
  build
```

On macOS, install [XcodeGen](https://github.com/yonaskolb/XcodeGen), [SwiftLint](https://github.com/realm/SwiftLint) and [pre-commit](https://pre-commit.com/). Коммит проверяет только пробелы и YAML; SwiftLint и тесты гоняет CI.

```bash
xcodegen generate
swiftlint lint --strict
xcodebuild test -project DinoHome.xcodeproj -scheme DinoHome -destination 'platform=iOS Simulator,name=iPhone 16'
pre-commit install
```
