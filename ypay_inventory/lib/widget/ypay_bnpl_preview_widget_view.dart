import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

import 'platform_widget.dart';

import 'package:ypay_inventory_platform_interface/src/platform_views.dart';

class _YPayBnplPreviewWidgetViewCallHandler extends YPayPlatformViewStateControllerSizedCallHandler {
  final ValueChanged<dynamic> onCheckoutButtonClick;
  final ValueChanged<dynamic> onHeaderClick;

  _YPayBnplPreviewWidgetViewCallHandler({
    required this.onCheckoutButtonClick,
    required this.onHeaderClick,
  });

  @override
  Future onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onHeaderClick':
        return onHeaderClick(call.arguments);
      case 'onCheckoutButtonClick':
        return onCheckoutButtonClick(call.arguments);
    }
    return super.onMethodCall(call);
  }
}

/// YPayBnplPreviewWidgetView
class YPayBnplPreviewWidgetView extends StatefulWidget with YPayPlatformViewControlledWidgetMixin {
  const YPayBnplPreviewWidgetView({
    super.key,
    required this.sum,
    required this.renderData,
    this.builder,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.onCheckoutButtonClick,
    this.onHeaderClick,
  });

  static const String _viewType = 'ypay-bnpl-preview-widget-view';

  final double sum;
  final BnplPreviewWidgetRenderData renderData;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final PlatformViewSizedBuilder? builder;
  final ValueChanged<int>? onCheckoutButtonClick;
  final VoidCallback? onHeaderClick;

  @override
  Map<String, dynamic> get creationParams => _creationParams();

  Map<String, dynamic> _creationParams() {
    return {
      'sum': sum,
      ...renderData.creationParams(),
      'withHeaderClickListener': onHeaderClick != null,
    };
  }

  @override
  State<YPayBnplPreviewWidgetView> createState() => _YPayBnplPreviewWidgetViewState();
}

class _YPayBnplPreviewWidgetViewState extends State<YPayBnplPreviewWidgetView>
    with YPayPlatformViewControlledStateMixin {
  int? _platformViewId;
  late final _callHandler = _YPayBnplPreviewWidgetViewCallHandler(
    onCheckoutButtonClick: _onCheckoutButtonClick,
    onHeaderClick: _onHeaderClick,
  );

  void _onCheckoutButtonClick(dynamic args) {
    widget.onCheckoutButtonClick?.call(args['selectedPlan'] as int);
  }

  void _onHeaderClick(dynamic _) {
    widget.onHeaderClick?.call();
  }

  @override
  void dispose() {
    if (_platformViewId != null) {
      YPayPlatformViewsService.instance.disposeEventCallback(
        _platformViewId!,
        YPayBnplPreviewWidgetView._viewType,
        'onCheckoutButtonClick',
      );
      YPayPlatformViewsService.instance.disposeEventCallback(
        _platformViewId!,
        YPayBnplPreviewWidgetView._viewType,
        'onHeaderClick',
      );
    }
    super.dispose();
  }

  bool get _listenerIsAttached => _platformViewId != null;

  void _onPlatformViewCreated(int id) {
    if (!_listenerIsAttached) {
      YPayPlatformViewsService.instance.addEventCallback(
        id,
        YPayBnplPreviewWidgetView._viewType,
        'onCheckoutButtonClick',
        _onCheckoutButtonClick,
      );
      YPayPlatformViewsService.instance.addEventCallback(
        id,
        YPayBnplPreviewWidgetView._viewType,
        'onHeaderClick',
        _onHeaderClick,
      );
    }
    _platformViewId = id;
    onPlatformViewControlledCreated(id);
  }

  @override
  YPayPlatformViewStateControllerCallHandler get callHandler => _callHandler;

  @override
  Widget build(BuildContext context) {
    return YPayPlatformSizedWidget(
      viewType: YPayBnplPreviewWidgetView._viewType,
      gestureRecognizers: widget.gestureRecognizers,
      builder: widget.builder,
      sizedCallHandler: _callHandler,
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: widget.creationParams,
    );
  }

  @override
  String get viewType => YPayBnplPreviewWidgetView._viewType;
}
