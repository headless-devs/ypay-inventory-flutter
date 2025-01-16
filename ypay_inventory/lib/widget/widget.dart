export 'ypay_badge.dart';
export 'ypay_bnpl_preview_widget_view.dart';
export 'ypay_info_widget_view.dart';
export 'ypay_simple_widget_view.dart';

class AndroidYPayInventory {
  /// This comes at the cost of some performance on Android versions below 10.
  /// See https://flutter.dev/docs/development/platform-integration/platform-views#performance for more information.
  ///
  /// Defaults to true.
  static bool useAndroidViewSurface = true;
}
