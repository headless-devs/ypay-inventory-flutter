import 'package:flutter/foundation.dart';
import 'package:ypay_inventory_android/ypay_inventory_android.dart';
import 'package:ypay_inventory_ios/ypay_inventory_ios.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';
export 'package:ypay_inventory_platform_interface/src/types/configuration.dart';
export 'package:ypay_inventory_platform_interface/src/widget_params/widget_params.dart';
export 'widget/widget.dart';

/// Basic YPayInventory API.
class YPayInventory {
  YPayInventory._();

  static YPayInventory? _instance;

  /// The instance of the [YPayInventory] to use.
  static YPayInventory get instance => _getOrCreateInstance();

  /// Returns the instance of the [YPayInventory] to use.
  ///
  /// You can use this function to get the instance of the [YPayInventory] class.
  /// It will create a new instance if it doesn't exist yet.
  ///
  /// Returns:
  ///   A [YPayInventory] instance.
  static YPayInventory _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      YPayInventoryAndroidPlatform.registerPlatform();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      YPayInventoryIosPlatform.registerPlatform();
    }

    _instance = YPayInventory._();
    return _instance!;
  }

  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required YPayInventoryConfiguration configuration}) {
    return YPayInventoryPlatform.instance.init(configuration: configuration);
  }

  /// Для корректного завершения работы с компонентами виджетов
  Future<void> clearBadges(){
    return YPayInventoryPlatform.instance.clearBadges();
  }
  /// Для корректного завершения работы с компонентами виджетов
  Future<void> clearWidgets(){
    return YPayInventoryPlatform.instance.clearWidgets();
  }
}
