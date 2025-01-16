/// The class represents the information for SDK initialization.
class YPayInventoryConfiguration {
  /// Constructs a Configuration.
  const YPayInventoryConfiguration({
    required this.merchantId,
    required this.merchantName,
    required this.merchantUrl,
    this.testMode = true,
    this.badgeHidingPolicy = YPayBadgeHidingPolicy.gone,
  });

  /// Unique identifier of the merchant.
  ///
  /// It can be obtained when registering the merchant in the Yandex Pay service
  /// [https://pay.yandex.ru/ru/docs/console/settings#merchant-id]
  final String merchantId;

  /// URL of the merchant, which will be displayed to the user.
  final String merchantUrl;

  /// Name of the merchant, which will be displayed to the user.
  final String merchantName;

  /// The environment of the Yandex Pay SDK.
  ///
  /// `true` - SANDBOX environment (test)
  ///
  /// `false` - PRODUCTION environment (prod)
  final bool testMode;

  /// HidingPolicy for badge
  final YPayBadgeHidingPolicy badgeHidingPolicy;

  /// Returns map of parameters
  Map<String, dynamic> toMap() => {
        'merchantId': merchantId,
        'merchantName': merchantName,
        'merchantUrl': merchantUrl,
        'testMode': testMode,
        'badgeHidingPolicy': badgeHidingPolicy.name,
      };

  @override
  String toString() {
    return 'YPayConfig{merchantId: $merchantId, testMode: $testMode, merchantName: $merchantName, merchantUrl: $merchantUrl}';
  }
}

/// Defines the visibility of badge if it is unavailable
enum YPayBadgeHidingPolicy {
  /// YPayBadgeView will become invisible
  invisible,

  /// YPayBadgeView will become gone
  gone,
}
