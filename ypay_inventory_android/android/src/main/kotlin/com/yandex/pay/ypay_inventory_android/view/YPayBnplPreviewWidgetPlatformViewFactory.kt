package com.yandex.pay.ypay_inventory_android.view

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.MethodChannel

import io.flutter.plugin.common.BinaryMessenger

class YPayBnplPreviewWidgetPlatformViewFactory(
    private val messenger: BinaryMessenger,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return YPayBnplPreviewWidgetPlatformView(
            context, viewId, creationParams,
            messenger
        )
    }
}