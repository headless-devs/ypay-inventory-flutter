package com.yandex.pay.ypay_inventory_android.view

import android.content.Context
import android.widget.LinearLayout
import com.yandex.pay.widgets.badge.api.view.YPayBadgeView
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import java.math.BigDecimal
import java.util.EnumSet
import android.view.View
import com.yandex.pay.widgets.info.api.view.YPaySimpleWidgetView
import com.yandex.pay.widgets.info.api.model.render.WidgetType
import com.yandex.pay.widgets.info.api.model.render.WidgetTheme
import com.yandex.pay.widgets.info.api.model.render.WidgetStyle
import android.view.ViewTreeObserver
import android.util.TypedValue
import android.widget.FrameLayout
import android.view.View.MeasureSpec


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class YPaySimpleWidgetPlatformView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    messenger: BinaryMessenger
) :
    PlatformView,
    MethodChannel.MethodCallHandler {

    private val yPaySimpleView = YPaySimpleWidgetView(context).apply {
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
    }
    private val controllerChannel =
        MethodChannel(messenger, "com.yandex.pay.flutter_channel/ypay-simple-widget-view_" + id)

    init {
        controllerChannel.setMethodCallHandler(this)
        applyViewOptions(creationParams!!)
        yPaySimpleView.viewTreeObserver.addOnGlobalLayoutListener {
            val width = yPaySimpleView.measuredWidth
            yPaySimpleView.measure(
                MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED)
            )
            val height = yPaySimpleView.measuredHeight

//            val widthDp = pxToDp(context, width)
            val heightDp = pxToDp(context, height)
            // Отправляем размеры в Flutter
            controllerChannel
                .invokeMethod(
                    "onSizeChanged", mapOf(
                        "id" to id,
                        "viewType" to "ypay-simple-widget-view",
                        "height" to heightDp
                    )
                )
        }
    }

    override fun  dispose() {
        controllerChannel.setMethodCallHandler(null);
    }
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "updateViewOptions" -> {
                updateViewOptions(call)
                result.success(null)
            }

            "waitForInit" -> {
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    fun updateViewOptions(call: MethodCall) {
        applyViewOptions(call.arguments as Map<String?, Any?>)
    }

    override fun getView(): View {
        return yPaySimpleView
    }

    private fun pxToDp(context: Context, px: Int): Float {
        val density = context.resources.displayMetrics.density
        return px / density
    }

    private fun applyViewOptions(params: Map<String?, Any?>) {
        if (params["types"] != null) {
            yPaySimpleView.setTypes(
                (params["types"] as? List<String>)?.mapNotNull {
                    WidgetType.valueOf(it.uppercase())
                }?.let {
                    // Сразу создать EnumSet из списка элементов
                    EnumSet.copyOf(it)
                } ?: EnumSet.noneOf(WidgetType::class.java)
            )
        }
        if (params["theme"] != null) {
            yPaySimpleView.setTheme(
                WidgetTheme.valueOf((params["theme"] as? String)?.uppercase() ?: "SYSTEM")
            )
        }
        if (params["style"] != null) {
            yPaySimpleView.setStyle(
                WidgetStyle.valueOf((params["style"] as? String)?.uppercase() ?: "SOLID")
            )
        }
        if (params["sum"] != null) {
            yPaySimpleView.setSum(BigDecimal((params["sum"] as? Double) ?: 0.0))
        }
    }
}
