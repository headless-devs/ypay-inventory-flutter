# YPay Inventory Flutter Plugin

YPay inventory Flutter Plugin позволяет интегрировать встроенные бейджи и виджеты YandexPaySDK в ваши проекты. Инвентарь — это набор визуальных элементов с брендированными продуктами Яндекса.

Библиотека реализует все варианты нативных бейджей и виджетов, включая их настройку и кастомизацию.

# Описание

[Бейджи](https://pay.yandex.ru/docs/ru/custom/android-sdk/inventory/badges) — небольшие элементы на карточке товара, которые содержат информацию о кешбэке баллами Плюса или платежах Яндекс Сплит.\
[Виджеты](https://pay.yandex.ru/docs/ru/custom/android-sdk/inventory/widgets) — это элементы интерфейса, которые сообщают пользователю о возможности оплатить покупку в рассрочку через Сплит или получить кешбэк.

# Требования к подключению

Поддерживаемая версия: **Android 7.0** и выше.\
Поддерживаемая версия **iOS SDK: 14.0** и выше.

Для полноценной работы инвентаря в вашем приложении желательно подключить и настроить **YPay SDK**. Убедитесь, что выполнили все шаги по подключению и протестировали работу бибилиотеки на обеих платформах. Подробнее можно ознакомиться на странице пакета [ypay](https://pub.dev/packages/ypay)

# Подключение

Добавьте это в файл pubspec.yaml вашего пакета:

```yaml
dependencies:
  ypay_inventory: ^1.0.3
```

# Использование

Для ознакомления доступно example приложение с настройками проекта и всеми вариантами виджетов и бейджей, а также их кастомизация.

**Добавление импорта:**
```dart
import 'package:ypay_inventory/ypay_inventory.dart';
``` 


**Создание экземпляра:**
```dart
final ypayInventoryPlugin = YPayInventory.instance;
``` 

**Инициализируйте инвентарь:**
```dart
ypayInventoryPlugin.init(
  configuration: const Configuration(
      // ваш Merchant ID
      merchantId: 'your merchant id',
      // название вашего магазина
      merchantName: 'Demo Merchant',
      // ссылка на ваш магазин
      merchantUrl: "https://example.ru/",
      // [необзятально] режим отладки (по умолчанию - true)
      testMode: true,
      // [необзятально] режим скрытия бейджей в случае отсутствия данных (по умолчанию - YPayBadgeHidingPolicy.gone)
      badgeHidingPolicy: YPayBadgeHidingPolicy.gone,
    ),
  );
``` 

# Основные виджеты

Визуально посмотреть все возможные варианты состояния виджетов можно на официальной на [странице](https://pay.yandex.ru/docs/ru/custom/android-sdk/inventory/widgets) нативного SDK

К бейджам относится **YPayBadge**, к виджетам - **YPaySimpleWidgetView**, **YPayInfoWidgetView** и **YPayBnplPreviewWidgetView**.

- Названия и свойства виджетов основаны на Android SDK.
- Все бейджи и виджеты - это нативные view, которые показываются через PlatformView.
- Для каждого бейджа или виджета обязательным аргументом является сумма (стоимость товара).  
- У каждого бейджа и виджета можно изменить тему: системная, светлая, темная.
- Все виджеты имеют минимальную ширину равную 280 pt.

**Android**\
Для корректного завершения работы с компонентами бейджей, используйте следующий код:

```dart
/// деинициализация компонентов бейджей:
ypayInventoryPlugin.clear()
```

#### YPayBadge

Виджет для показа бейджей.\
Есть два типа виджетов - кэшбэк и сплит. **CashbackBadgeRenderData** вернет бейдж с кэшбэком, **SplitBadgeRenderData** вернет бейдж со сплитом.  

```dart
/// Бейдж кэшбэка
return YPayBadge(
	sum: 1230,
	width: 200,
	renderData: CashbackBadgeRenderData(
		// Тема виджета: светлая (YPayWidgetTheme.light), или темная (YPayWidgetTheme.dark), или системная (YPayWidgetTheme.system)
		theme: YPayBadgeTheme.system,
		// Выравнивание бейджа относительно контейнера: (YPayBadgeAlign.left, YPayBadgeAlign.center, YPayBadgeAlign.right)
		align: YPayBadgeAlign.left,
		// Цвет бейджа: (SplitBadgeColor.primary, SplitBadgeColor.green, SplitBadgeColor.grey, SplitBadgeColor.transparent)
		color: CashbackBadgeColor.primary,
		// Версия бейджа
		variant: CashbackBadgeVariant.detailed,
	),
);
```

```dart
/// Бейдж сплита
return YPayBadge(
	sum: 1230,
	width: 200,
	renderData: SplitBadgeRenderData(
		// Тема виджета: светлая (YPayWidgetTheme.light), или темная (YPayWidgetTheme.dark), или системная (YPayWidgetTheme.system)
		theme: YPayBadgeTheme.system, 
		// Выравнивание бейджа относительно контейнера: (YPayBadgeAlign.left, YPayBadgeAlign.center, YPayBadgeAlign.right)
		align: YPayBadgeAlign.left,
		// Цвет бейджа: (SplitBadgeColor.primary, SplitBadgeColor.green, SplitBadgeColor.grey, SplitBadgeColor.transparent)
		color: SplitBadgeColor.primary,
		// Версия бейджа, только для типа со Сплитом
		variant: SplitBadgeVariant.simple,
	),
);
```

#### YPaySimpleWidgetView

По умолчанию содержит в себе два блока: Сплит и баллы Плюса. На каждый блок можно нажать и перейти на страницу соответствующего лендинга с более подробной информацией о продуктах Сплита и Плюса.

```dart
return YPaySimpleWidgetView(
	// Сумма заказа
	sum: 10000,
	renderData: SimpleWidgetRenderData(
		// Настройки прозрачности: сплошной (YPayWidgetStyle.solid) или прозрачный (YPayWidgetStyle.transparent)
		style: YPayWidgetStyle.solid,
		// Тема виджета: светлая (YPayWidgetTheme.light), или темная (YPayWidgetTheme.dark), или системная (YPayWidgetTheme.system)
		theme: YPayWidgetTheme.system,
		// Тип данных в виджете: Сплит, кешбэк или оба варианта
		types: {YPayWidgetType.split, YPayWidgetType.cashback},
	),
);
```

#### YPayInfoWidgetView

Отображение можно настроить так, чтобы показывался только сплит, только кэшбэк или три блока сразу. По умолчанию содержит в себе три секции: баллы Плюса, BNPL-план Сплита и информацию об оплате без первоначального взноса.

```dart
return YPayInfoWidgetView(
	// Сумма заказа
	sum: 1230,
	renderData: InfoWidgetRenderData(
		// Тема виджета: светлая (YPayWidgetTheme.light), или темная (YPayWidgetTheme.dark), или системная (YPayWidgetTheme.system)
		theme: YPayWidgetTheme.system,
		// Тип данных в виджете: Сплит, кешбэк или оба варианта
		types: {YPayWidgetType.split, YPayWidgetType.cashback},
	),
);
```

#### YPayBnplPreviewWidgetView

Кастомизируемый BNPL-виджет позволяет предварительно ознакомиться с условиями доступных некредитных планов Сплит и выбрать подходящий.  
Виджет состоит из четырех частей:
-   Кликабельная шапка с логотипом Сплит и краткой информацией о платежах и комиссии выбранного плана;
-   Селектор планов (отображается, если пользователю доступно более одного плана Сплита);
-   Информация о платежах по датам;
-   Кнопка «Оформить» (по умолчанию скрыта).

Для шапки и кнопки «Оформить» можно задать свои функции на клик.

Виджет изменяет ширину, чтобы соблюдать установленные ограничения, однако для каждой его конфигурации существует минимальная ширина. Виджет динамически рассчитывает собственную высоту в зависимости от контента, поэтому мы не рекомендуем добавлять для нее дополнительные constraints.


```dart
return YPayBnplPreviewWidgetView(
	// Сумма заказа
    sum: 1230,
	// Слушатель клика по шапке виджета (при установленном YPayWidgetHeader.standard)
	onHeaderClick: () {
	// Показ информации об оплате частями
	},
	// Слушатель клика по кнопке «Оформить» (параметр selectedPlan содержит количество месяцев выбранного плана Сплита)
	onCheckoutButtonClick: (int selectedPlan) {
	// Переход на экран оплаты
	},    
	renderData: BnplPreviewWidgetRenderData(
		// Тема виджета: светлая (YPayWidgetTheme.light), или темная (YPayWidgetTheme.dark), или системная (YPayWidgetTheme.system)
		theme: YPayWidgetTheme.system,
		// Тип отображения шапки виджета: стандартный (YPayWidgetHeader.standard) или уменьшенный (YPayWidgetHeader.minified)
		header: YPayWidgetHeader.standard
		// Фон виджета: стандартный (YPayWidgetBackground.standard), прозрачный (YPayWidgetBackground.transparent) или произвольный (YPayWidgetBackground.custom)
		background: YPayWidgetBackground.standard,
		// Наличие обводки виджета
		hasOutline: true
		// Радиус виджета в пикселях
		radius: 30
		// Наличие внутреннего отступа виджета
		hasPadding: true
		// Размер виджета: средний (YPayWidgetSize.medium) или маленький (YPayWidgetSize.small)
		size: YPayWidgetSize.medium,
		// Наличие кнопки «Оформить»
		hasCheckoutButton: false,
		// Цвет фона виджета (при установленном YPayWidgetBackground.custom)
		backgroundColor: 0x000000,
	),
);
```

# Пример отображения

Рекомендуем запустить example для ознакомления со всеми вариантами кастомизации и отображения или посетить официальные страницы виджетов и бейджей для iOS и Android.

![View](https://raw.githubusercontent.com/headless-devs/ypay-inventory-flutter/refs/heads/stable/assets/views.png)