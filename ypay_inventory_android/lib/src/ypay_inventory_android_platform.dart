import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

/// An [YPayInventoryPlatform] that wraps YPayInventory Android SDK.
class YPayInventoryAndroidPlatform extends YPayInventoryPlatform {
  YPayInventoryAndroidPlatform._();

  static final YPayInventoryMethodHandler _methodHandler = YPayInventoryMethodHandler();

  /// Registers this class as the default instance of [YPayInventoryPlatform].
  static void registerPlatform() {
    /// Register the platform instance with the plugin platform interface.
    YPayInventoryPlatform.instance = YPayInventoryAndroidPlatform._();
  }

  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  @override
  Future<void> init({required YPayInventoryConfiguration configuration}) async {
    await _methodHandler.init(configuration: configuration);
  }

  @override
  Future<void> clearBadges() {
    return _methodHandler.clearBadges();
  }

  @override
  Future<void> clearWidgets() {
    return _methodHandler.clearWidgets();
  }
}
