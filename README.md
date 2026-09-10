# Dino Home · iOS

SwiftUI-приложение с домашней веб-консолью. Кнопка «Сервер» задаёт ваш HTTPS-адрес. Вход — по одноразовому приглашению из авторизованной консоли; Google открывается во внешнем браузере.

## Сборка и TestFlight

Нужны macOS, Xcode, XcodeGen, SwiftLint. Для TestFlight — своя Apple Developer Team и приложение в App Store Connect.

```bash
brew install xcodegen swiftlint
xcodegen generate
swiftlint lint --strict
xcodebuild test -project DinoHome.xcodeproj -scheme DinoHome \
  -destination 'platform=iOS Simulator,name=iPhone 16'
pre-commit install
pre-commit run --all-files
```

В Xcode выберите Team и уникальный Bundle ID → Archive → Distribute App → App Store Connect → TestFlight.

Workflow `iOS Device IPA` собирает неподписанный IPA — вручную и по тегу `vX.Y.Z`, публикуя файл в релизы. Для установки нужна ваша подпись: [инструкция по sideload](https://github.com/dinosaur-tv/.github/blob/main/docs/INSTALL.md#iphone-sideload). В TestFlight он ничего не отправляет.

Xcode и SwiftLint на Windows не запускаются. Проверьте macOS CI и на iPhone: вход, загрузку фото, возврат из Google и восстановление сети.

Пульт включается только через `TV_REMOTE_ENABLED=true` на backend. [Безопасность](SECURITY.md) · [MIT](LICENSE).
