import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

import 'platform_widget.dart';

/// YPaySimpleWidgetView
class YPaySimpleWidgetView extends StatefulWidget with YPayPlatformViewControlledWidgetMixin {
  const YPaySimpleWidgetView({
    super.key,
    required this.sum,
    required this.renderData,
    this.builder,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  static const String _viewType = 'ypay-simple-widget-view';

  final double sum;
  final SimpleWidgetRenderData renderData;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final PlatformViewSizedBuilder? builder;

  @override
  State<YPaySimpleWidgetView> createState() => _YPaySimpleWidgetViewState();

  Map<String, dynamic> _creationParams() {
    return {'sum': sum, ...renderData.creationParams()};
  }

  @override
  Map<String, dynamic> get creationParams => _creationParams();
}

class _YPaySimpleWidgetViewState extends State<YPaySimpleWidgetView> with YPayPlatformViewControlledStateMixin {
  @override
  String get viewType => YPaySimpleWidgetView._viewType;

  final _callHandler = YPayPlatformViewStateControllerSizedCallHandler();

  @override
  YPayPlatformViewStateControllerCallHandler get callHandler => _callHandler;

  @override
  Widget build(BuildContext context) {
    return YPayPlatformSizedWidget(
      viewType: YPaySimpleWidgetView._viewType,
      gestureRecognizers: widget.gestureRecognizers,
      builder: widget.builder,
      sizedCallHandler: _callHandler,
      onPlatformViewCreated: onPlatformViewControlledCreated,
      creationParams: widget._creationParams(),
    );
  }
}
