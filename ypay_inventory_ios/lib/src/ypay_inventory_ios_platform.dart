import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

/// An [YPayInventoryPlatform] that wraps YPayInventory iOS SDK.
class YPayInventoryIosPlatform extends YPayInventoryPlatform {
  YPayInventoryIosPlatform._();

  static final YPayInventoryMethodHandler _methodHandler = YPayInventoryMethodHandler();

  /// Registers this class as the default instance of [YPayInventoryPlatform].
  static void registerPlatform() {
    /// Register the platform instance with the plugin platform interface.
    YPayInventoryPlatform.instance = YPayInventoryIosPlatform._();
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
  Future<void> clearBadges() => Future.value();

  @override
  Future<void> clearWidgets() => Future.value();
}
