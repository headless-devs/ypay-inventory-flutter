import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ypay_inventory_platform_interface/ypay_inventory_platform_interface.dart';

import 'package:ypay_inventory_platform_interface/src/platform_views.dart';
import 'widget.dart';
export  'package:ypay_inventory_platform_interface/src/platform_views.dart';

class YPayPlatformWidget extends StatelessWidget {
  const YPayPlatformWidget({
    super.key,
    required this.viewType,
    required this.creationParams,
    this.onPlatformViewCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  final String viewType;
  final ValueChanged<int>? onPlatformViewCreated;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final dynamic creationParams;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (AndroidYPayInventory.useAndroidViewSurface) {
        return PlatformViewLink(
            viewType: viewType,
            surfaceFactory: (BuildContext context, PlatformViewController controller) => AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  gestureRecognizers: gestureRecognizers,
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                ),
            onCreatePlatformView: (PlatformViewCreationParams params) {
              final view = PlatformViewsService.initExpensiveAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () => params.onFocusChanged(true),
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
              if (onPlatformViewCreated != null) {
                view.addOnPlatformViewCreatedListener(onPlatformViewCreated!);
              }
              return view;
            });
      } else {
        return AndroidView(
          viewType: viewType,
          onPlatformViewCreated: onPlatformViewCreated,
          gestureRecognizers: gestureRecognizers,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: creationParams,
        );
      }
    } else {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
      );
    }
  }
}

// abstract class YPayPlatformSizedWidget extends StatefulWidget {}
enum YPayPlatformWidgetSize { hug, hugHeight, hugWidth, none }

class YPayPlatformSizedWidget extends StatefulWidget {
  const YPayPlatformSizedWidget({
    super.key,
    required this.viewType,
    required this.creationParams,
    this.widgetSize = YPayPlatformWidgetSize.hugHeight,
    this.onPlatformViewCreated,
    this.initialSize,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.builder,
    this.sizedCallHandler,
  });

  final String viewType;
  final ValueChanged<int>? onPlatformViewCreated;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final dynamic creationParams;

  final YPayPlatformWidgetSize widgetSize;
  final PlatformViewSizedBuilder? builder;
  final PlatformViewSize? initialSize;
  final YPayPlatformViewStateControllerSizedCallHandler? sizedCallHandler;

  @override
  State<YPayPlatformSizedWidget> createState() => _YPayPlatformSizedWidgetState();
}

class _YPayPlatformSizedWidgetState extends YPayPlatformSizedWidgetState<YPayPlatformSizedWidget> {
  @override
  dynamic get creationParams => widget.creationParams;

  @override
  Set<Factory<OneSequenceGestureRecognizer>> get gestureRecognizers => widget.gestureRecognizers;

  @override
  String get viewType => widget.viewType;

  @override
  YPayPlatformWidgetSize get widgetSize => widget.widgetSize;

  @override
  void onPlatformViewCreated(int id) {
    widget.onPlatformViewCreated?.call(id);
    super.onPlatformViewCreated(id);
  }

  @override
  void didUpdateWidget(covariant YPayPlatformSizedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widgetSize != oldWidget.widgetSize || widget.initialSize != oldWidget.initialSize) {
      setState(() {
        _size = initialSize;
        _isInitialSize = true;
      });
    } else if (widget.initialSize != null && _size.isZero) {
      setState(() {
        _size = initialSize;
        _isInitialSize = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.sizedCallHandler?.onSizeChangedCallback = onSizeChange;
  }

  @override
  PlatformViewSizedBuilder? get builder => widget.builder;

  @override
  PlatformViewSize get initialSize {
    if (widget.initialSize != null) {
      return widget.initialSize!;
    }
    switch (widgetSize) {
      case YPayPlatformWidgetSize.hug:
        return const PlatformViewSize(0, 0);
      case YPayPlatformWidgetSize.hugHeight:
        return const PlatformViewSize(null, 0);
      case YPayPlatformWidgetSize.hugWidth:
        return const PlatformViewSize(0, null);
      case YPayPlatformWidgetSize.none:
        return const PlatformViewSize(null, null);
    }
  }
}

abstract class YPayPlatformSizedWidgetState<T extends StatefulWidget> extends State<T> {
  int? _platformViewId;

  PlatformViewSizedBuilder? get builder;

  String get viewType;

  PlatformViewSize get initialSize => const PlatformViewSize(null, 0);

  YPayPlatformWidgetSize get widgetSize => YPayPlatformWidgetSize.hugHeight;

  late PlatformViewSize _size = initialSize;

  PlatformViewSize transformSize(PlatformViewSize size) => size.ceil();

  void onSizeChange(PlatformViewSize size) {
    size = transformSize(size);
    PlatformViewSize? newSize;
    switch (widgetSize) {
      case YPayPlatformWidgetSize.hug:
        newSize = size;
      case YPayPlatformWidgetSize.hugHeight:
        newSize = PlatformViewSize(null, size.height);
      case YPayPlatformWidgetSize.hugWidth:
        newSize = PlatformViewSize(size.width, null);

      case YPayPlatformWidgetSize.none:
        break;
    }
    if (_size != newSize) {
      setState(() {
        _size = newSize!;
      });
    }

    if (_isInitialSize) {
      setState(() {
        _isInitialSize = false;
      });
    }
  }

  bool _callbackIsInit = false;
  bool _isInitialSize = true;

  @mustCallSuper
  void onPlatformViewCreated(int id) {
    _platformViewId = id;
    _onPlatformViewCreated(id);
  }

  void _onPlatformViewCreated(int id) {
    if (!_callbackIsInit) {
      YPayPlatformViewsService.instance.addSizeCallback(id, viewType, onSizeChange);
      _callbackIsInit = true;
    }
  }

  @override
  void dispose() {
    if (_platformViewId != null) {
      YPayPlatformViewsService.instance.disposeSizeCallback(_platformViewId!, viewType);
    }
    super.dispose();
  }

  dynamic get creationParams;

  Set<Factory<OneSequenceGestureRecognizer>> get gestureRecognizers;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: _size.width,
      height: _size.height,
      child: YPayPlatformWidget(
        viewType: viewType,
        creationParams: creationParams,
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
      ),
    );
    final builder = this.builder;
    return builder != null ? builder(_size, _isInitialSize, child) : child;
  }
}

typedef PlatformViewSizedBuilder = Widget Function(PlatformViewSize size, bool isInitial, Widget child);

mixin YPayPlatformViewControlledWidgetMixin on StatefulWidget {
  Map<String, dynamic> get creationParams;
}

mixin YPayPlatformViewControlledStateMixin<T extends YPayPlatformViewControlledWidgetMixin> on State<T> {
  Completer<YPayPlatformViewStateController> _controller = Completer<YPayPlatformViewStateController>();

  @override
  void dispose() async {
    super.dispose();
    final controller = await _controller.future;

    controller.dispose();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateViewOptions(oldWidget.creationParams, widget.creationParams);
  }

  void _updateViewOptions(
    Map<String, dynamic> oldCreationParams,
    Map<String, dynamic> newCreationParams,
  ) async {
    final updates = {...newCreationParams}..removeWhere(
        (String key, dynamic value) {
          if (value is Map) return mapEquals(oldCreationParams[key], value);
          if (value is List) return listEquals(oldCreationParams[key], value);
          return oldCreationParams[key] == value;
        },
      );

    await onUpdateViewOptions(oldCreationParams, newCreationParams, updates);
  }

  Future<void> onUpdateViewOptions(
    Map<String, dynamic> oldCreationParams,
    Map<String, dynamic> newCreationParams,
    Map<String, dynamic> updates,
  ) async {
    if (updates.isEmpty) {
      return;
    }
    final controller = await _controller.future;

    controller.updateViewOptions(updates);
  }

  String get viewType;

  Future<void> onPlatformViewControlledCreated(int id) async {
    final controller = await YPayPlatformViewStateController.init(
      id,
      viewType,
      callHandler: callHandler,
    );

    _controller.complete(controller);
  }

  YPayPlatformViewStateControllerCallHandler? get callHandler => null;
}
