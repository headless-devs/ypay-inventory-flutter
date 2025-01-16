import '../ypay_inventory_platform_interface.dart';

/// The interface that implementations of 'YPay' must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `YPay` does not consider newly added methods to be breaking changes.
/// Extending this class(using `extends`) ensures that the subclass will get the
/// default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added [YPayPlatform] methods.
abstract class YPayInventoryPlatform {
  /// Should only be accessed after setter is called.
  static late YPayInventoryPlatform _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [YPayPlatform] when they register themselves.
  // ignore: unnecessary_getters_setters
  static set instance(YPayInventoryPlatform instance) {
    _instance = instance;
  }

  /// The instance of [YPayPlatform] to use.
  ///
  /// Must be set before accessing.
  // ignore: unnecessary_getters_setters
  static YPayInventoryPlatform get instance => _instance;

  /// Initializes the SDK for further work
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required YPayInventoryConfiguration configuration}) => throw UnimplementedError('init() has not been implemented.');

  /// Для корректного завершения работы с компонентами виджетов
  ///
  /// Android API, не поддерживает iOS
  Future<void> clearWidgets();

  /// Для корректного завершения работы с компонентами бейджей
  ///
  /// Android API, не поддерживает iOS
  Future<void> clearBadges();
}
