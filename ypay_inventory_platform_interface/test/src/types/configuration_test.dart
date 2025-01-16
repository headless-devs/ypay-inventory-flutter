import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_inventory_platform_interface/src/types/configuration.dart';

void main() {
  test('Constructor Test', () {
    // Arrange
    const configuration = YPayInventoryConfiguration(
      merchantId: 'merchantId',
      merchantName: 'merchantName',
      merchantUrl: 'merchantUrl',
      testMode: false,
    );

    // Assert
    expect(configuration.merchantId, 'merchantId');
    expect(configuration.testMode, false);
  });
}
