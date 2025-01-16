import 'package:flutter/services.dart';

import '../channel.dart';
import '../errors/ypay_inventory_error.dart';
import 'configuration.dart';

/// This class contains the necessary logic of the order of method calls
/// for the correct SDK working.
///
/// Platform implementations can use this class for platform calls.
class YPayInventoryMethodHandler {
  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required YPayInventoryConfiguration configuration}) async {
    try {
      //ignore: unnecessary_null_comparison
      if (ServicesBinding.instance == null) {
        throw YPayInventoryInitializeError(
            message: 'Initialization error',
            data: 'Try to invoke \'WidgetsFlutterBinding.ensureInitialized()\' '
                'before initialization.');
      }
      await inventoryChannel.invokeMethod('init', configuration.toMap());
    } on PlatformException catch (e) {
      throw YPayInventoryInitializeError(message: e.message ?? '', data: e.details ?? '');
    }
  }

  Future<void> clearBadges() async {
    try {
      //ignore: unnecessary_null_comparison
      if (ServicesBinding.instance == null) {
        throw YPayInventoryInitializeError(
            message: 'clearBadges error',
            data: 'Try to invoke \'WidgetsFlutterBinding.ensureInitialized()\' '
                'before initialization.');
      }
      await inventoryChannel.invokeMethod('clearBadges');
    } on PlatformException catch (e) {
      throw YPayInventoryInternalError(message: e.message ?? '', data: e.details ?? '');
    }
  }

  Future<void> clearWidgets() async {
    try {
      //ignore: unnecessary_null_comparison
      if (ServicesBinding.instance == null) {
        throw YPayInventoryInitializeError(
            message: 'clearWidgets error',
            data: 'Try to invoke \'WidgetsFlutterBinding.ensureInitialized()\' '
                'before initialization.');
      }
      await inventoryChannel.invokeMethod('clearWidgets');
    } on PlatformException catch (e) {
      throw YPayInventoryInternalError(message: e.message ?? '', data: e.details ?? '');
    }
  }
}
