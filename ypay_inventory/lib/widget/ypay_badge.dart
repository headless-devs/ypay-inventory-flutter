import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

import 'platform_widget.dart';

/// YPayBadge
class YPayBadge extends StatefulWidget with YPayPlatformViewControlledWidgetMixin {
  const YPayBadge({
    super.key,
    required this.sum,
    required this.renderData,
    this.width,
    this.height,
    this.builder,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  static const String _viewType = 'ypay-badge-view';

  final double sum;
  final BadgeRenderData renderData;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  // final BadgeSizeType sizeType;
  final PlatformViewSizedBuilder? builder;

  final double? width, height;

  @override
  State<YPayBadge> createState() => _YPayBadgeState();

  Map<String, dynamic> _creationParams() {
    final size = calculateViewSize();
    return {
      'sum': sum,
      ...renderData.creationParams(),
      'width': size?.width ?? 0,
      'height': size?.height ?? 0,
      // 'width': calculateViewSize()?.width ?? 0,
    };
  }

  @override
  Map<String, dynamic> get creationParams => _creationParams();

  static const double simpleSplitAspectRatio = 24.0 / 252.0;
  static const double detailedSplitAspectRatio = 24.0 / 310.0;
  static const double detailedCashbackAspectRatio = 24.0 / 245.0;
  static const double simpleCashbackAspectRatio = 24.0 / 100.0;

  static double getAspectRatio(BadgeRenderData renderData) {
    switch (renderData) {
      case SplitBadgeRenderData():
        if (renderData.variant == SplitBadgeVariant.simple) {
          return simpleSplitAspectRatio;
        } else {
          return detailedSplitAspectRatio;
        }
      case CashbackBadgeRenderData():
        if (renderData.variant == CashbackBadgeVariant.simple) {
          return simpleCashbackAspectRatio;
        } else {
          return detailedCashbackAspectRatio;
        }
      default:
        return detailedSplitAspectRatio;
    }
  }

  PlatformViewSize? calculateViewSize() {
    if (height != null) {
      return calculateViewSizeByHeight(height!);
    }
    if (width != null) {
      return calculateViewSizeByWidth(width!);
    }

    return null;
  }

  PlatformViewSize calculateViewSizeByHeight(double height) {
    final aspectRatio = getAspectRatio(renderData);
    return PlatformViewSize((height / aspectRatio).ceilToDouble(), height);
  }

  PlatformViewSize calculateViewSizeByWidth(double width) {
    final aspectRatio = getAspectRatio(renderData); // return AndroidSize(

    return PlatformViewSize(width, (width * aspectRatio).floorToDouble());
  }
}

class _YPayBadgeState extends State<YPayBadge> with YPayPlatformViewControlledStateMixin {
  @override
  String get viewType => YPayBadge._viewType;

  @override
  Future<void> onUpdateViewOptions(
    Map<String, dynamic> oldCreationParams,
    Map<String, dynamic> newCreationParams,
    Map<String, dynamic> updates,
  ) async {
    if (updates.isEmpty) {
      return;
    }
    return super.onUpdateViewOptions(
      oldCreationParams,
      newCreationParams,
      newCreationParams,
    );
  }

  final _callHandler = YPayPlatformViewStateControllerSizedCallHandler();

  @override
  YPayPlatformViewStateControllerCallHandler get callHandler => _callHandler;

  @override
  Widget build(BuildContext context) {
    return YPayPlatformSizedWidget(
      viewType: YPayBadge._viewType,
      gestureRecognizers: widget.gestureRecognizers,
      creationParams: widget.creationParams,
      builder: widget.builder,
      initialSize: widget.calculateViewSize(),
      sizedCallHandler: _callHandler,
      widgetSize:
         (widget.width == null && widget.height == null)? YPayPlatformWidgetSize.none : YPayPlatformWidgetSize.hug,
      onPlatformViewCreated: onPlatformViewControlledCreated,
    );
  }
}
