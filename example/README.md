# example приложение ypay_inventory

## Getting Started

Для запуска проекта необходимо в app/build.gradle
указать manifestPlaceholders = [YANDEX_CLIENT_ID: "your-client-id"]

Также заполнить конфигурацию в main.dart

код
```
   configuration: const YPayInventoryConfiguration(
        merchantId: 'merchantId',
        merchantName: 'merchantName',
        merchantUrl: 'merchantUrl',
      )
```

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
