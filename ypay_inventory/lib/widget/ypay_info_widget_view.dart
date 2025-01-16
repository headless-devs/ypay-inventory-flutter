import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

import 'platform_widget.dart';

/// YPayInfoWidgetView
class YPayInfoWidgetView extends StatefulWidget with YPayPlatformViewControlledWidgetMixin {
  const YPayInfoWidgetView({
    super.key,
    required this.sum,
    required this.renderData,
    this.builder,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  static const String _viewType = 'ypay-info-widget-view';

  final double sum;
  final InfoWidgetRenderData renderData;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final PlatformViewSizedBuilder? builder;

  Map<String, dynamic> _creationParams() {
    return {'sum': sum, ...renderData.creationParams()};
  }

  @override
  State<YPayInfoWidgetView> createState() => _YPayInfoWidgetViewState();

  @override
  Map<String, dynamic> get creationParams => _creationParams();
}

class _YPayInfoWidgetViewState extends State<YPayInfoWidgetView> with YPayPlatformViewControlledStateMixin {
  final _callHandler = YPayPlatformViewStateControllerSizedCallHandler();

  @override
  YPayPlatformViewStateControllerCallHandler get callHandler => _callHandler;

  @override
  Widget build(BuildContext context) {
    return YPayPlatformSizedWidget(
      viewType: YPayInfoWidgetView._viewType,
      gestureRecognizers: widget.gestureRecognizers,
      builder: widget.builder,
      sizedCallHandler: _callHandler,
      onPlatformViewCreated: onPlatformViewControlledCreated,
      creationParams: widget.creationParams,
    );
  }

  @override
  String get viewType => YPayInfoWidgetView._viewType;
}
