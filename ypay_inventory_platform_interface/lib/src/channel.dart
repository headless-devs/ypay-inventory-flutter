import 'package:flutter/services.dart';

/// A constant [MethodChannel] for invoking inventory methods.
const MethodChannel inventoryChannel = MethodChannel('com.yandex.pay.flutter_channel/inventory_methods');

/// A constant [EventChannel] for listening to inventory events.
const EventChannel inventoryEventChannel = EventChannel('com.yandex.pay.flutter_channel/inventory_events');
