import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

// ignore_for_file: unchecked_use_of_nullable_value
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late YPayInventoryMethodHandler handler;

  setUp(() {
    handler = YPayInventoryMethodHandler();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      inventoryChannel,
      ypayMockMethodCallHandler,
    );
  });

  tearDown(
    () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        inventoryChannel,
        null,
      );
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

      await handler.init(configuration: validConfig).then((value) => completer.complete('initialized'));

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

      expect(() async => handler.init(configuration: invalidConfig), throwsA(isA<YPayInventoryInitializeError>()));
    },
  );
}
