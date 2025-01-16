import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_inventory_ios/src/ypay_inventory_ios_platform.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    YPayInventoryIosPlatform.registerPlatform();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(inventoryChannel, ypayMockMethodCallHandler);
  });

  tearDown(
    () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(inventoryChannel, null);
    },
  );

  test(
    'init()',
    () async {
      final completer = Completer<String>();

      const validConfig = YPayInventoryConfiguration(
        merchantId: 'merchantId',
        merchantName: 'merchantName',
        merchantUrl: 'merchantUrl',
      );

      await YPayInventoryPlatform.instance
          .init(configuration: validConfig)
          .then((value) => completer.complete('initialized'));

      expect(completer.isCompleted, isTrue);
    },
  );

  test(
    'When config is invalid, init() calling should throws YPayInventoryException',
    () async {
      const invalidConfig = YPayInventoryConfiguration(
        merchantId: '',
        merchantName: '',
        merchantUrl: '',
      );

      expect(() async => YPayInventoryPlatform.instance.init(configuration: invalidConfig),
          throwsA(isA<YPayInventoryInitializeError>()));
    },
  );
}
