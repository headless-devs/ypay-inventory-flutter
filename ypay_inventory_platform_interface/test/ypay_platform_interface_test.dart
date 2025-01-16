import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$YPayInventoryPlatform', () {
    test('Can be extended', () {
      YPayInventoryPlatform.instance = ExtendsYPayInventoryPlatform();
    });

    final yPayPlatform = ExtendsYPayInventoryPlatform();

    test(
        'Default implementation of init()'
        'should throw unimplemented error', () {
      expect(
        () => yPayPlatform.init(
            configuration: const YPayInventoryConfiguration(
          merchantId: 'merchantId',
          merchantName: 'merchantName',
          merchantUrl: 'merchantUrl',
        )),
        throwsUnimplementedError,
      );
    });
  });
}

class ExtendsYPayInventoryPlatform extends YPayInventoryPlatform {
  @override
  Future<void> clearBadges() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearWidgets() {
    throw UnimplementedError();
  }
}
