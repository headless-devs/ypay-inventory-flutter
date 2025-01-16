import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'channel.dart';

class YPayPlatformViewStateControllerCallHandler {
  @mustCallSuper
  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw UnimplementedError("${call.method} was invoked but isn't implemented by YPayPlatformViewsService");
    }
  }
}

class YPayPlatformViewStateController {
  static Future<YPayPlatformViewStateController> init(int id, String viewType,
      {YPayPlatformViewStateControllerCallHandler? callHandler}) async {
    final methodChannel = MethodChannel('com.yandex.pay.flutter_channel/${viewType}_$id');
    await methodChannel.invokeMethod('waitForInit');

    ///??

    return YPayPlatformViewStateController._(methodChannel, callHandler: callHandler);
  }

  YPayPlatformViewStateController._(
    this._channel, {
    YPayPlatformViewStateControllerCallHandler? callHandler,
  }) {
    _channel.setMethodCallHandler(callHandler?.onMethodCall);
  }

  final MethodChannel _channel;

  void dispose() {
    _channel.setMethodCallHandler(null);
  }

  /// Changes current options
  Future<void> updateViewOptions(Map<String, dynamic> options) async {
    await _channel.invokeMethod('updateViewOptions', options);
  }
}

mixin PlatformViewSizedCallHandler on YPayPlatformViewStateControllerCallHandler {
  void onSizeChanged(PlatformViewSize size);

  @override
  Future onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSizeChanged':
        final newHeight = (call.arguments['height'] as num?)?.toDouble();
        final newWidth = (call.arguments['width'] as num?)?.toDouble();

        onSizeChanged(PlatformViewSize(newWidth, newHeight));
        break;
      default:
        return super.onMethodCall(call);
    }
  }
}

class YPayPlatformViewStateControllerSizedCallHandler extends YPayPlatformViewStateControllerCallHandler
    with PlatformViewSizedCallHandler {
  YPayPlatformViewStateControllerSizedCallHandler();

  Function(PlatformViewSize size)? onSizeChangedCallback;

  @override
  void onSizeChanged(PlatformViewSize size) {
    onSizeChangedCallback?.call(size);
  }
}

class YPayPlatformViewsService {
  YPayPlatformViewsService._() {
    inventoryChannel.setMethodCallHandler(_onMethodCall);
  }

  static final YPayPlatformViewsService instance = YPayPlatformViewsService._();

  Future<void> _onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'onSizeChanged':
        final int id = call.arguments['id'] as int;
        final viewType = call.arguments['viewType'] as String;

        final newHeight = (call.arguments['height'] as num?)?.toDouble();
        final newWidth = (call.arguments['width'] as num?)?.toDouble();

        final key = _widgetKey(id, viewType);
        if (_sizeCallbacks.containsKey(key)) {
          _sizeCallbacks[key]!(PlatformViewSize(newWidth, newHeight));
        }
      case 'onEvent':
        final id = call.arguments['id'] as int;
        final viewType = call.arguments['viewType'] as String;
        final event = call.arguments['event'] as String;
        final key = _widgetEventKey(id, viewType, event);
        if (_eventCallbacks.containsKey(key)) {
          final handler = _eventCallbacks[key]!;
          handler.call(call.arguments);
        }
      default:
        throw UnimplementedError("${call.method} was invoked but isn't implemented by YPayPlatformViewsService");
    }
    return Future<void>.value();
  }

  /// Maps platform view IDs to focus callbacks.
  ///
  /// The callbacks are invoked when the platform view asks to be focused.
  final Map<String, OnPlatformSizeChangedCallback> _sizeCallbacks = {};

  final Map<String, OnPlatformEventCallback> _eventCallbacks = {};

  String _widgetKey(int id, String viewType) => '${viewType}_$id';

  String _widgetEventKey(int id, String viewType, String event) => '${viewType}_$id:$event';

  void addSizeCallback(int id, String viewType, OnPlatformSizeChangedCallback callback) {
    _sizeCallbacks[_widgetKey(id, viewType)] = callback;
  }

  void disposeSizeCallback(int id, String viewType) {
    _sizeCallbacks.remove(_widgetKey(id, viewType));
  }

  void addEventCallback(int id, String viewType, String event, OnPlatformEventCallback callback) {
    _eventCallbacks[_widgetEventKey(id, viewType, event)] = callback;
  }

  void disposeEventCallback(int id, String viewType, String event) {
    _eventCallbacks.remove(_widgetEventKey(id, viewType, event));
  }
}

typedef OnPlatformSizeChangedCallback = void Function(PlatformViewSize size);
typedef OnPlatformEventCallback = void Function(dynamic args);

class PlatformViewSize {
  const PlatformViewSize(this.width, this.height);

  final double? width;
  final double? height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformViewSize && runtimeType == other.runtimeType && width == other.width && height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  PlatformViewSize ceil() {
    return PlatformViewSize(width?.ceilToDouble(), height?.ceilToDouble());
  }

  bool get isZero => width == 0 || height == 0;
}
