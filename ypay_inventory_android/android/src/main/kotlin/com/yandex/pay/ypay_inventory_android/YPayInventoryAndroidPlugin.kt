package com.yandex.pay.ypay_inventory_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import com.yandex.pay.ypay_inventory_android.view.YPayBadgePlatformViewFactory
import com.yandex.pay.ypay_inventory_android.view.YPaySimpleWidgetPlatformViewFactory
import com.yandex.pay.ypay_inventory_android.view.YPayInfoWidgetPlatformViewFactory
import com.yandex.pay.ypay_inventory_android.view.YPayBnplPreviewWidgetPlatformViewFactory
import io.flutter.plugin.common.MethodChannel

class YPayInventoryAndroidPlugin : FlutterPlugin, ActivityAware {

    private val pluginDelegate: YPayInventoryPluginDelegate = YPayInventoryPluginDelegate

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginDelegate.onAttachedToEngine(binding)

        val channel =
            MethodChannel(binding.binaryMessenger, YPayInventoryAndroidPlugin.METHOD_CHANNEL_NAME)
        binding
            .platformViewRegistry
            .registerViewFactory(
                "ypay-badge-view",
                YPayBadgePlatformViewFactory(binding.binaryMessenger)
            )

        binding
            .platformViewRegistry
            .registerViewFactory(
                "ypay-simple-widget-view",
                YPaySimpleWidgetPlatformViewFactory(binding.binaryMessenger)
            )

        binding
            .platformViewRegistry
            .registerViewFactory(
                "ypay-info-widget-view",
                YPayInfoWidgetPlatformViewFactory(binding.binaryMessenger)
            )

        binding
            .platformViewRegistry
            .registerViewFactory(
                "ypay-bnpl-preview-widget-view",
                YPayBnplPreviewWidgetPlatformViewFactory(binding.binaryMessenger)
            )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginDelegate.onDetachedFromEngine()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        pluginDelegate.setActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        pluginDelegate.setActivityBinding(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        pluginDelegate.setActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        pluginDelegate.setActivityBinding(null)
    }

    companion object {
        const val METHOD_CHANNEL_NAME = "com.yandex.pay.flutter_channel/inventory_methods"
        const val EVENT_CHANNEL_NAME = "com.yandex.pay.flutter_channel/inventory_events"
    }
}
