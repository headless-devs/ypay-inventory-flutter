
Версии плагина Yandex Pay на момент написания (29.11.2024):  
> **iOS** - 1.13.0  
> **Android** - 2.3.10
----------
Официальная документация Yandex Pay
[**iOS**](https://pay.yandex.ru/docs/ru/custom/ios-sdk/)
[**Android**](https://pay.yandex.ru/docs/ru/custom/android-sdk/)

## Технические требования
Минимальная версия iOS - 14.0

## Android
Минимальная версия SDK - 24

----------
Версия Flutter не ниже 2.0.0, версия Dart - не ниже 3.0.0.
~~~
/// pubspec.yaml
environment:
	sdk: ">=3.0.0 <4.0.0"
	flutter: ">=2.0.0"
~~~

## **Подключение**
Добавьте в pubspec.yaml проекта следующую зависимость:
`ypay_inventory: ^0.0.2`
или
~~~
ypay_inventory:  
   git:  
        url: https://git.thehead.ru/adamas/ypay_inventory.git  
        ref: stable  
        path: ypay_inventory
~~~
## **Создание YPayInventory**
YPayInventory - класс для инициализации плагина.
Создайте экземпляр YPayInventory и вызовите метод .init() с ключами Яндекса для инициализации:

~~~
final _ypayPlugin = YPayInventory.instance;  
  
Future<void> _init() async {  
    await _ypayPlugin.init(  
        configuration: const YPayInventoryConfiguration(  
        merchantId: 'merchantId',  
        merchantName: 'merchantName',  
	    merchantUrl: 'merchantUrl',  
	));  
}
~~~
## **Основные виджеты**

К бейджам относится **YPayBadge**, к виджетам - **YPaySimpleWidgetView**, **YPayInfoWidgetView** и **YPayBnplPreviewWidgetView**.

Все бейджи и виджеты - это нативные view, которые показываются через PlatformView.

Каждый бейдж и виджет обязательным параметром принимает в себя сумму (стоимость товара).

У каждого бейджа и виджета можно изменить тему (системная, светлая, темная).

> Все **виджеты** имеют минимальную ширину равную 280 pt.

### YPayBadge

Виджет для показа бейджей. Бейджи — небольшие элементы интерфейса, которые содержат информацию о кешбэке Плюса или платежах Яндекс Сплит.  
Есть два типа виджетов - кэшбэк и сплит. Они отличаются передаваемыми параметрами (**CashbackBadgeRenderData** вернет бейдж с кэшбэком, **SplitBadgeRenderData** вернет бейдж со сплитом).  

![IMAGE 2024-12-02 19:45:20](https://github.com/user-attachments/assets/f9b0f3c4-a93a-437b-9032-612fd94a452b)
![IMAGE 2024-12-02 19:45:45](https://github.com/user-attachments/assets/18a82857-7d74-4100-8c0a-58df038b5d84)
~~~
/// Бейдж кэшбэка
return YPayBadge(
	sum: 1230,
	width: 200,
	renderData: CashbackBadgeRenderData(
		theme: YPayBadgeTheme.system,
		align: YPayBadgeAlign.left,
		color: CashbackBadgeColor.primary,
		variant: CashbackBadgeVariant.detailed,
	),
);
~~~
~~~
/// Бейдж сплита
return YPayBadge(
	sum: 1230,
	width: 200,
	renderData: SplitBadgeRenderData(
		theme: YPayBadgeTheme.system,
		align: YPayBadgeAlign.left,
		color: SplitBadgeColor.primary,
		variant: SplitBadgeVariant.detailed,
	),
);
~~~

### YPaySimpleWidgetView
![IMAGE 2024-12-02 19:46:08](https://github.com/user-attachments/assets/6c7f352d-d8cc-4b29-8d74-5e70aa233955)

Отображение можно настроить так, чтобы показывался только сплит, только кэшбэк или оба блока сразу. Клик на блок открывает соответствующую модалку с информацией. По умолчанию содержит оба блока.

~~~
return YPaySimpleWidgetView(
	sum: controllers.selectedValues.amount,
	renderData: SimpleWidgetRenderData(
		style: YPayWidgetStyle.solid,
		theme: YPayWidgetTheme.system,
		types: {YPayWidgetType.split, YPayWidgetType.cashback},
	),
);
~~~

### YPayInfoWidgetView
![IMAGE 2024-12-02 19:46:35](https://github.com/user-attachments/assets/4506adbe-102e-45a6-ae14-885db5d64d20)

Отображение можно настроить так, чтобы показывался только сплит, только кэшбэк или три блока сразу. По умолчанию содержит в себе три секции: баллы Плюса, BNPL-план Сплита и информацию об оплате без первоначального взноса.

~~~
return YPayInfoWidgetView(
	sum: 1230,
	renderData: InfoWidgetRenderData(
		theme: YPayWidgetTheme.system,
		types: {YPayWidgetType.split, YPayWidgetType.cashback},
	),
);
~~~

### YPayBnplPreviewWidgetView
![IMAGE 2024-12-02 19:47:01](https://github.com/user-attachments/assets/3840dc2d-2ef2-499d-8be2-526945e2a69b)
Кастомизируемый BNPL-виджет позволяет предварительно ознакомиться с условиями доступных некредитных планов Сплит и выбрать подходящий.  
Виджет состоит из четырех частей:
-   Кликабельная шапка с логотипом Сплит и краткой информацией о платежах и комиссии выбранного плана;
-   Селектор планов (отображается, если пользователю доступно более одного плана Сплита);
-   Информация о платежах по датам;
-   Кнопка «Оформить» (по умолчанию скрыта).

Для шапки и кнопки "Оформить" можно задать свои функции на клик.

~~~
return YPayBnplPreviewWidgetView(
    sum: 1230,          
	renderData: BnplPreviewWidgetRenderData(
        theme: YPayWidgetTheme.system,
		header: YPayWidgetHeader.standard
		background: YPayWidgetBackground.standard,
		hasOutline: true
		radius: 30
		hasPadding: true
		size: YPayWidgetSize.medium,
		hasCheckoutButton: false,
	),
);
~~~